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
eccount = {}
open genes_file do |f|
	until (line = f.gets).nil?
		next if line.strip.empty?
		gene = line.strip
		genes << gene
		eccount[gene] = 0.0
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
					oldec = eccount.clone
					genes.each do |g|
						c = f_c.gets.strip.to_i
						e = f_e.gets.strip.to_i
						if c == 1 or e == 1
							klass[g] = "EC"
							eccount[g] = oldec[g] + 1
						else
							klass[g] = "O"
						end
					end
				end
			end
			
			size = {"EC" => 0, "O" => 0}
			min_genes.each do |g|
				size[klass[g]] = size[klass[g]] + 1
			end
			stats << "#{p1}, #{p2}, #{p3} - EC: #{size["EC"]}, O: #{size["O"]}"
			
			interactions = {"EC" => {"EC" => 0, "O" => 0},
							"O"  => {"EC" => 0, "O" => 0}
							}
			
			
			edges.each do |e|
				s, t = e.first, e.last
				sklass, tklass = klass[s], klass[t]
				interactions[sklass][tklass] = interactions[sklass][tklass] + 1 unless sklass.nil? or tklass.nil?
			end
			
			ratios[p1][p2][p3] = {
				"EC" => {"EC" => interactions["EC"]["EC"].to_f/(size["EC"]*size["EC"]-size["EC"])/multifactor,
						"O" => interactions["EC"]["O"].to_f/(size["EC"]*size["O"])/multifactor},
				"O" => {"O" => interactions["O"]["O"].to_f/(size["O"]*size["O"]-size["O"])/multifactor,
						"EC" => interactions["O"]["EC"].to_f/(size["O"]*size["EC"])/multifactor}
				}
		
		end
	end
end


open("#{subdir}/ec_percent.out", "w"){ |f| eccount.map{|k,v| [k,v/total]}.sort{|a,b| b.last == a.last ? a.first <=> b.first : b.last <=> a.last}.each{|pair| f.puts pair.join "    "} }
open("#{subdir}/ec_stats.out", "w"){|f| f.puts stats.join("\n")}

matrix = ""
klasses = ["EC", "O"]

=begin
row_labels = p1_vals.map{|p1| "#{(p2_vals.size/2).times.map{"' '"}.join(" ")} '#{p1}' #{(p2_vals.size - p2_vals.size/2 - 1).times.map{"' '"}.join(" ")}"}.join " "
col_labels = 2.times.map{p3_vals.map{|p3| "'#{p3/10.0}' ' '"}}.join " "
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

row_labels = 2.times.map{p1_vals.map{|p1| "#{(p2_vals.size/2).times.map{"' '"}.join(" ")} '#{p1}' #{(p2_vals.size - p2_vals.size/2 - 1).times.map{"' '"}.join(" ")}"}.join " "}.join " "
col_labels = 2.times.map{p3_vals.map{|p3| "'#{p3/10.0}'"}}.join " "
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

open "#{subdir}/e_u_c.m", "w" do |f|
	f.puts "RL = {#{row_labels}}"
	f.puts "CL = {#{col_labels}}"
	f.puts "Matrix = [#{matrix}]"
	f.puts "HM = HeatMap(Matrix, 'RowLabels', RL, 'ColumnLabels', CL, 'Symmetric', false, 'ColorMap', colormap('JET'))"
end










