counts = {}
open "geneNames.csv" do |f|
	until(line = f.gets).nil?
		gene = line.strip
		counts[gene] = 0 if counts[gene].nil?
		counts[gene] = counts[gene] + 1
	end
end
open "gene_counts.out", "w" do |f|
	counts.sort{|a,b| b.last <=> a.last}.each{|a| f.puts a.join "  "}
end