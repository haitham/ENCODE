%%% Create the E-class and C-class numbers by 
%%% - Vary the RT cutoff from -0.5 to +0.5 at increments of 0.1
%%% - Fix percent to 1 (at least one cell line supports E-class)
%%% - Vary the switchCutoff between -0.5 to 1 at increments of 0.1

function script10


%for sc =0: 1: 10
%for rtc = -5: 1: 5
%  col9(100, sc, rtc);
%end
%end

%for rtc = 0: 1: 5
%  col8(50, sc, rtc);
%end
%for rtc = 0: 1: 5
%  col8(100, sc, rtc);
%end

%j=0;
%x = zeros(264, 5);
%for pct = [1, 10, 25, 50]
%for sc =0: 1: 5
%for rtc = -5: 1: 5
%  j = j+1
%  x(j, :) = col9(pct, sc, rtc);
%end
%end
%end

%x

fendo = fopen('endoderm_python2.txt', 'w');
fecto = fopen('ectoderm_python2.txt', 'w');
fmeso = fopen('mesoderm_python2.txt', 'w');

for rtc = -4.3: 0.1: -3.8
	 fprintf(fendo, 'python combinedHeatmaps2014.py gerstein_network geneNames.csv ');
	 fprintf(fecto, 'python combinedHeatmaps2014.py gerstein_network geneNames.csv ');
	 fprintf(fmeso, 'python combinedHeatmaps2014.py gerstein_network geneNames.csv ');

for pct = 10:10:50
for sc =0: 1: 10
	[ectoE, ectoC] = col10('ectoderm', pct, sc, rtc);
	[endoE, endoC] = col10('endoderm', pct, sc, rtc);
	[mesoE, mesoC] = col10('mesoderm', pct, sc, rtc);
	fprintf(fendo, '%s %s ', endoE, endoC);
	fprintf(fecto, '%s %s ', endoE, ectoC);
	fprintf(fmeso, '%s %s ', mesoE, mesoC);
end
end
fprintf(fendo,'\n');
fprintf(fecto,'\n');
fprintf(fmeso,'\n');
end
fclose(fendo);
fclose(fecto);
fclose(fmeso);
