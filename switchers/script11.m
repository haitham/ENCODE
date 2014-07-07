%%% Create the E-class and C-class numbers by 
%%% - Vary the RT cutoff from -0.5 to +0.5 at increments of 0.1
%%%
%%% - Vary the switchCutoff between 0.5 to 1 at increments of 0.1

function script11


%sc = 5;

for sc =5: 1: 10
	for rtc = -5.0: 1.0: 5.0
		 col11('ectoderm', '../ectoderm-exp.csv', '../ectoderm-rt.csv', sc, rtc);
		 col11('endoderm', '../endoderm-exp.csv', '../endoderm-rt.csv', sc, rtc);
		 col11('mesoderm', '../mesoderm-exp.csv', '../mesoderm-rt.csv', sc, rtc);
	end	
end

%for rtc = 0: 1: 5
%  col8(50, sc, rtc);
%end
%for rtc = 0: 1: 5
%  col8(100, sc, rtc);
%end
