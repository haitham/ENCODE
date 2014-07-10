#This script reads all files in subdir, and generates a matlab file to heatmap them
subdir, network_file, multifactor, genes_file = ARGV
p1_vals, p2_vals = Dir.glob("#{subdir}/sclass_*").map{|f| f.split("_").last(2).map{|v| v.to_f}}.transpose.map{|a| a.uniq.sort}
p1_vals = p1_vals.map{|v| v.to_i}
total = p1_vals.size * p2_vals.size
stats = []
multifactor = multifactor.to_f


#read gene names
genes = []
scount = {}
ncount = {}
open genes_file do |f|
	until (line = f.gets).nil?
		next if line.strip.empty?
		gene = line.strip
		genes << gene
		scount[gene] = 0.0
		ncount[gene] = 0.0
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
			
		klass = {}
		open "#{subdir}/sclass_#{p1}_#{p2}" do |f_s|
			open "#{subdir}/nsclass_#{p1}_#{p2}" do |f_n|
				olds, oldn = scount.clone, ncount.clone
				genes.each do |g|
					s = f_s.gets.strip.to_i
					n = f_n.gets.strip.to_i
					if s == 1
						klass[g] = "S"
						scount[g] = olds[g] + 1
					elsif n == 1
						klass[g] = "N"
						ncount[g] = oldn[g] + 1
					end
				end
			end
		end
		
		size = {"S" => 0, "N" => 0}
		min_genes.each do |g|
			size[klass[g]] = size[klass[g]] + 1
		end
		stats << "#{p1}, #{p2} - S: #{size["S"]}, N: #{size["N"]}"
		
		
		interactions = {"S" => {"S" => 0, "N" => 0},
						"N" => {"S" => 0, "N" => 0}
						}
		
		edges.each do |e|
			s, t = e.first, e.last
			sklass, tklass = klass[s], klass[t]
			interactions[sklass][tklass] = interactions[sklass][tklass] + 1 unless sklass.nil? or tklass.nil?
		end
		
		ratios[p1][p2] = {
			"S" => {"S" => interactions["S"]["S"].to_f/(size["S"]*size["S"]-size["S"])/multifactor,
					"N" => interactions["S"]["N"].to_f/(size["S"]*size["N"])/multifactor},
			"N" => {"N" => interactions["N"]["N"].to_f/(size["N"]*size["N"]-size["N"])/multifactor,
					"S" => interactions["N"]["S"].to_f/(size["N"]*size["S"])/multifactor}
			}
	
	end
end


open("#{subdir}/s_percent.out", "w"){ |f| scount.map{|k,v| [k,v/total]}.sort{|a,b| b.last == a.last ? a.first <=> b.first : b.last <=> a.last}.each{|pair| f.puts pair.join "    "} }
open("#{subdir}/n_percent.out", "w"){ |f| ncount.map{|k,v| [k,v/total]}.sort{|a,b| b.last == a.last ? a.first <=> b.first : b.last <=> a.last}.each{|pair| f.puts pair.join "    "} }
open("#{subdir}/stats.out", "w"){|f| f.puts stats.join("\n")}

matrix = ""
klasses = ["S", "N"]

=begin
row_labels = p1_vals.map{|p1| "'#{p1/10.0}'"}.join " "
col_labels = 2.times.map{p2_vals.map{|p2| "'#{p2/10.0}' ' '"}.join " "}.join " "
p1_vals.each do |p1|
	klasses.each do |k1|
		p2_vals.each do |p2|
			klasses.each do |k2|
				matrix = "#{matrix}#{ratios[p1][p2][k1][k2]} "
			end
		end
	end
	matrix = "#{matrix}\n"
end
=end

row_labels = 2.times.map{p1_vals.map{|p1| "'#{p1/10.0}'"}.join " "}.join " "
col_labels = 2.times.map{p2_vals.map{|p2| "'#{p2/10.0}'"}.join " "}.join " "
klasses.each do |k2|
	p1_vals.each do |p1|
		klasses.each do |k1|
			p2_vals.each do |p2|			
				matrix = "#{matrix}#{ratios[p1][p2][k1][k2]} "
			end
		end
		matrix = "#{matrix}\n"
	end
end

open "#{subdir}/heatmap.m", "w" do |f|
	f.puts "RL = {#{row_labels}}"
	f.puts "CL = {#{col_labels}}"
	f.puts "Matrix = [#{matrix}]"
	f.puts "HM = HeatMap(Matrix, 'RowLabels', RL, 'ColumnLabels', CL, 'Symmetric', false, 'ColorMap', colormap('JET'))"
end










