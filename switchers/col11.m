%%%  Reports the switching genes
%%%  A gene is switching if all the following conditions hold
%%%    1. Early replicating at least once 
%%%    2. Late replicating at least once 
%%%    3. maxRT - minRT >= switch cutoff

function resultprint = col11(subdir, expIN, rtIN, sc, rtc)

transcribed = load(expIN);
rawRT = load(rtIN);

%%% initializations start here
switchCutoff = sc/10; 
RTcutoff = rtc/10;

%earlyreplicated = a(:,5:8);
[m, n] = size(transcribed);
%foo = a(:,5:8);

earlyreplicated = ones(m,n);
for i = 1:m  % rows
  for j = 1:n % columns
    if (rawRT(i,j) <= RTcutoff)
      earlyreplicated(i,j) = 0;
    end
  end
end



SwitchClass = zeros(m,1);
NonSwitchClass = ones(m,1);
allOnes = NonSwitchClass;

%%% initializations end here


for i = 1:m


%%% CONDITION 1 & 2: Check whether the gene is regulatory in terms of replication timing
s = sum (earlyreplicated(i, :));
isRegulatory = 0;
if ( and(s > 0, s < n) )
  isRegulatory = 1;
end


%%% CONDITION 3: Check whether the gene is switching in terms of replication timing
%%% A gene is switching if MAX{cell_line} - MIN{cell_line} >= threshold
minRT = min(rawRT(i, :));
maxRT = max(rawRT(i, :));
isSwitching = 0;
if ( maxRT - minRT >= switchCutoff)
  isSwitching = 1;
end




%%% Set Switching-class
if (isRegulatory * isSwitching == 1)
  SwitchClass(i) = 1;
end


%%% Set NonSwitching-class

NonSwitchClass = allOnes - SwitchClass;
end

resultprint = [switchCutoff*100, sum(SwitchClass), sum(NonSwitchClass)]
%resultprint = [eclass cclass];


sFile = strcat(subdir, '/sclass_', num2str(sc), '_', num2str(rtc, '%2.1f'))
fid = fopen(sFile, 'w');
fprintf(fid,'%d\n', SwitchClass);
fclose(fid);

nsFile = strcat(subdir, '/nsclass_', num2str(sc), '_', num2str(rtc, '%2.1f'))
fid = fopen(nsFile, 'w');
fprintf(fid,'%d\n', NonSwitchClass);
fclose(fid);

% switchCutoff, RTcutoff
