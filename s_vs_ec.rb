layer = ARGV[0]
ec_prob, s_prob, outdeg, indeg = {}, {}, {}, {}
open "#{layer}/ec_percent.out" do |f|
	until (line = f.gets).nil?
		g, p = line.strip.split
		ec_prob[g] = p.to_f
	end
end
open "switchers/#{layer}/s_percent.out" do |f|
	until (line = f.gets).nil?
		g, p = line.strip.split
		s_prob[g] = p.to_f
	end
end
open "#{layer}/neph.txt" do |f|
	until (line = f.gets).nil?
		s, t = line.strip.split
		outdeg[s] = 0 if outdeg[s].nil?
		outdeg[s] = outdeg[s] + 1
		indeg[t] = 0 if indeg[t].nil?
		indeg[t] = indeg[t] + 1
	end
end

raise "ec_percent and s_percent have different lenghts!" if ec_prob.size != s_prob.size

genes = ec_prob.keys.reject{|g| indeg[g].nil? and outdeg[g].nil?}.sort do |a, b|
	a_diff, b_diff = ec_prob[a] - s_prob[a], ec_prob[b] - s_prob[b]
	if a_diff == b_diff
		(outdeg[a] || 0) <=> (outdeg[b] || 0)
	else
		a_diff <=> b_diff
	end
end
open "#{layer}_s_vs_ec.txt", "w" do |f|
	f.puts "#{sprintf "%-15s", "gene"}#{sprintf "%-15s", "ec_prob"}#{sprintf "%-15s", "s_prob"}#{sprintf "%-10s", "outdeg"}indeg"
	f.puts genes.map{|g| "#{sprintf "%-15s", g}#{sprintf "%-15s", ec_prob[g].round(5).to_s}#{sprintf "%-15s", s_prob[g].round(5).to_s}#{sprintf "%-10d", outdeg[g] || 0}#{indeg[g] || 0}"}.join("\n")
end