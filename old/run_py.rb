require 'fileutils'
["endoderm", "ectoderm", "mesoderm"].each do |derm|
	open "#{derm}_python2.txt" do |f|
		until (line = f.gets).nil?
			next if line.strip.empty?
			cmd = line.strip
			rtc = line.split[4].split(".").last
			puts "running #{derm} RTC = #{rtc}"
			`#{cmd}`
			FileUtils.mv "hm.png", "figures/#{derm}-RTC#{rtc}.png"
		end
	end
end