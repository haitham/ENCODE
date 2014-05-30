@seg_size = 0.05
def load_segments filename
	segments = {}
	open filename do |f|
		until (line = f.gets).nil?
			gene, value = line.strip.split
			next if value.to_f.zero?
			seg = (((value.to_f-0.0001)/@seg_size).truncate * @seg_size).round 3
			segments[gene] = seg
		end
	end
	segments
end

genes = []
open "geneNames.csv" do |f|
	until (line = f.gets).nil?
		genes << line.strip
	end
end

["e", "c"].each do |klass|
	[["ecto", "meso"], ["meso", "endo"], ["ecto", "endo"]].each do |xline, yline|
		zero_limits = (1.0/@seg_size).round.times.map{|i| {(@seg_size*i).round(3) => 0}}.reduce :merge
		squares = zero_limits.keys.map{|i| {i => zero_limits.clone}}.reduce :merge
		xsegments = load_segments "#{xline}derm/#{klass}_percent.out"
		ysegments = load_segments "#{yline}derm/#{klass}_percent.out"
		genes.each do |gene|
			xseg = xsegments[gene]
			yseg = ysegments[gene]
			squares[xseg][yseg] = squares[xseg][yseg] + 1 unless xseg.nil? or yseg.nil?
		end
		labels = squares.keys.sort.map{|k| "'#{k}'"}.join " "
		matrix = squares.sort.transpose.last.map{|s| s.sort.transpose.last.join " "}.join "\n"
		open "#{klass}_#{xline}_#{yline}.m", "w" do |f|
			f.puts "RL = {#{labels}}"
			f.puts "CL = {#{labels}}"
			f.puts "Matrix = [#{matrix}]"
			f.puts "HM = HeatMap(Matrix, 'RowLabels', RL, 'ColumnLabels', CL, 'Symmetric', false, 'ColorMap', colormap('JET'))"
			f.puts "addXLabel(HM, '#{klass.upcase} class probability: #{xline.capitalize}derm', 'FontWeight', 'bold')"
			f.puts "addYLabel(HM, '#{klass.upcase} class probability: #{yline.capitalize}derm', 'FontWeight', 'bold')"
		end
	end
end