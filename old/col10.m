%%%  Same as col8 
%%%  The key difference is that input data is split into 
%%%    two files, one for expression and one for replication timing
%%%

%function resultprint = col9(subdir, expIN, rtIN, percent, sc, rtc)
function [fileE, fileC] = col10(subdir, percent, sc, rtc)


%%% initializations start here

switchCutoff = sc/10; 
RTcutoff = rtc/10;


eFile = strcat(subdir, '/eclass.', num2str(percent), '.',  num2str(sc), '.', strrep(num2str(rtc), '.', ''))


cFile = strcat(subdir, '/cclass.', num2str(percent), '.', num2str(sc), '.', strrep(num2str(rtc), '.', ''))


fileE = eFile;
fileC = cFile;
% switchCutoff, RTcutoff
