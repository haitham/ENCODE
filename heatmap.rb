#This script reads all files in subdir, and generates a matlab file to heatmap them
subdir, network_file, multifactor, genes_file = ARGV
p1_vals, p2_vals, p3_vals = Dir.glob("#{subdir}/eclass_*").map{|f| f.split("_").last(3).map{|v| v.to_f}}.transpose.map{|a| a.uniq.sort}
p1_vals = p1_vals.map{|v| v.to_i}
p2_vals = p2_vals.map{|v| v.to_i}
total = p1_vals.size * p2_vals.size * p3_vals.size
stats = []
multifactor = multifactor.to_f

#read gene names
genes = []
ecount = {}
ccount = {}
open genes_file do |f|
	until (line = f.gets).nil?
		next if line.strip.empty?
		gene = line.strip
		genes << gene
		ecount[gene] = 0.0
		ccount[gene] = 0.0
	end
end

#read network
edges = []
nodes = {}
open network_file do |f|
	until (line = f.gets).nil?
		next if line.strip.empty?
		s, t = line.strip.split
		nodes[s] = true
		nodes[t] = true
		edges << [s, t]
	end
end
min_genes = nodes.keys & genes
stats << "number of genes: #{genes.size}"
stats << "number of nodes: #{nodes.size}"
stats << "Overlap: #{min_genes.size}"

#Work on every combination of parameter values
ratios = {}
p1_vals.each do |p1|
	print "#{p1} "
	ratios[p1] = {}
	p2_vals.each do |p2|
		ratios[p1][p2] = {}
		p3_vals.each do |p3|
			
			klass = {}
			open "#{subdir}/cclass_#{p1}_#{p2}_#{p3}" do |f_c|
				open "#{subdir}/eclass_#{p1}_#{p2}_#{p3}" do |f_e|
					oldc, olde = ccount.clone, ecount.clone
					genes.each do |g|
						c = f_c.gets.strip.to_i
						e = f_e.gets.strip.to_i
						if c == 1
							klass[g] = "C"
							ccount[g] = oldc[g] + 1
						elsif e == 1
							klass[g] = "E"
							ecount[g] = olde[g] + 1
						else
							klass[g] = "O"
						end
					end
				end
			end
			
			size = {"C" => 0, "E" => 0, "O" => 0}
			min_genes.each do |g|
				size[klass[g]] = size[klass[g]] + 1
			end
			stats << "#{p1}, #{p2}, #{p3} - C: #{size["C"]}, E: #{size["E"]}, O: #{size["O"]}"
			
			interactions = {"C" => {"C" => 0, "E" => 0, "O" => 0},
							"E" => {"C" => 0, "E" => 0, "O" => 0},
							"O" => {"C" => 0, "E" => 0, "O" => 0}
							}
			
			
			edges.each do |e|
				s, t = e.first, e.last
				sklass, tklass = klass[s], klass[t]
				interactions[sklass][tklass] = interactions[sklass][tklass] + 1 unless sklass.nil? or tklass.nil?
			end
			
			ratios[p1][p2][p3] = {
				"C" => {"C" => interactions["C"]["C"].to_f/(size["C"]*size["C"]-size["C"])/multifactor,
						"E" => interactions["C"]["E"].to_f/(size["C"]*size["E"])/multifactor,
						"O" => interactions["C"]["O"].to_f/(size["C"]*size["O"])/multifactor},
				"E" => {"E" => interactions["E"]["E"].to_f/(size["E"]*size["E"]-size["E"])/multifactor,
						"C" => interactions["E"]["C"].to_f/(size["E"]*size["C"])/multifactor,
						"O" => interactions["E"]["O"].to_f/(size["E"]*size["O"])/multifactor},
				"O" => {"O" => interactions["O"]["O"].to_f/(size["O"]*size["O"]-size["O"])/multifactor,
						"C" => interactions["O"]["C"].to_f/(size["O"]*size["C"])/multifactor,
						"E" => interactions["O"]["E"].to_f/(size["O"]*size["E"])/multifactor}
				}
		
		end
	end
end


open("#{subdir}/e_percent.out", "w"){ |f| ecount.map{|k,v| [k,v/total]}.sort{|a,b| b.last == a.last ? a.first <=> b.first : b.last <=> a.last}.each{|pair| f.puts pair.join "    "} }
open("#{subdir}/c_percent.out", "w"){ |f| ccount.map{|k,v| [k,v/total]}.sort{|a,b| b.last == a.last ? a.first <=> b.first : b.last <=> a.last}.each{|pair| f.puts pair.join "    "} }
open("#{subdir}/stats.out", "w"){|f| f.puts stats.join("\n")}

matrix = ""
klasses = ["E", "C", "O"]

=begin
row_labels = p1_vals.map{|p1| "#{(p2_vals.size/2).times.map{"' '"}.join(" ")} '#{p1}' #{(p2_vals.size - p2_vals.size/2 - 1).times.map{"' '"}.join(" ")}"}.join " "
col_labels = 3.times.map{p3_vals.map{|p3| "' ' '#{p3/10.0}' ' '"}}.join " "
p1_vals.each do |p1|
	p2_vals.each do |p2|
		klasses.each do |k1|
			p3_vals.each do |p3|
				klasses.each do |k2|
					matrix = "#{matrix}#{ratios[p1][p2][p3][k1][k2]} "
				end
			end
		end
		matrix = "#{matrix}\n"
	end
end
=end

row_labels = 3.times.map{p1_vals.map{|p1| "#{(p2_vals.size/2).times.map{"' '"}.join(" ")} '#{p1}' #{(p2_vals.size - p2_vals.size/2 - 1).times.map{"' '"}.join(" ")}"}.join " "}.join " "
col_labels = 3.times.map{p3_vals.map{|p3| "'#{p3/10.0}'"}}.join " "
klasses.each do |k2|
	p1_vals.each do |p1|
		p2_vals.each do |p2|
			klasses.each do |k1|
				p3_vals.each do |p3|				
					matrix = "#{matrix}#{ratios[p1][p2][p3][k1][k2]} "
				end
			end
			matrix = "#{matrix}\n"
		end
	end
end

open "#{subdir}/heatmap.m", "w" do |f|
	f.puts "RL = {#{row_labels}}"
	f.puts "CL = {#{col_labels}}"
	f.puts "Matrix = [#{matrix}]"
	f.puts "HM = HeatMap(Matrix, 'RowLabels', RL, 'ColumnLabels', CL, 'Symmetric', false, 'ColorMap', colormap('JET'))"
end










