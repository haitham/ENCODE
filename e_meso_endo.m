RL = {'0.0' '0.05' '0.1' '0.15' '0.2' '0.25' '0.3' '0.35' '0.4' '0.45' '0.5' '0.55' '0.6' '0.65' '0.7' '0.75' '0.8' '0.85' '0.9' '0.95'}
CL = {'0.0' '0.05' '0.1' '0.15' '0.2' '0.25' '0.3' '0.35' '0.4' '0.45' '0.5' '0.55' '0.6' '0.65' '0.7' '0.75' '0.8' '0.85' '0.9' '0.95'}
Matrix = [11 5 1 2 0 2 4 1 1 1 1 0 1 0 0 0 1 0 0 0
8 10 7 9 4 2 2 2 1 2 0 1 3 1 2 0 4 1 2 4
4 4 3 3 0 2 1 2 0 0 1 2 0 1 1 0 1 0 0 0
6 5 4 7 0 6 1 4 0 2 2 1 1 0 1 0 1 0 3 5
3 1 3 0 0 0 1 1 1 0 0 0 0 2 1 1 0 0 0 2
0 2 0 1 0 4 1 1 0 1 0 0 0 0 3 0 0 0 1 2
1 1 1 0 1 0 1 0 0 1 0 1 0 1 0 1 0 0 1 1
2 3 0 6 0 1 1 0 2 2 0 1 0 1 0 0 0 0 1 1
1 1 2 0 1 0 1 0 0 1 0 0 0 1 0 0 0 0 1 0
1 4 1 3 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
1 1 0 1 0 1 0 1 1 1 0 2 0 0 1 0 0 0 0 0
1 4 0 1 1 0 1 1 1 0 0 0 0 0 1 0 1 0 2 1
1 5 4 1 1 0 0 2 1 0 1 0 0 0 1 1 0 0 0 0
0 0 0 0 0 1 0 0 1 1 0 2 1 3 0 0 0 0 0 2
1 1 2 2 2 2 2 2 3 1 0 0 0 1 2 0 2 0 0 0
2 3 0 1 0 0 0 0 0 0 2 0 0 0 0 0 2 0 0 0
1 0 3 0 1 1 0 0 1 0 2 0 1 0 1 0 1 0 1 1
0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 0 0
1 1 0 0 0 1 1 0 0 0 1 0 0 0 2 0 0 0 0 0
2 3 0 2 0 0 0 1 1 1 1 0 2 1 1 1 3 1 0 5]
HM = HeatMap(Matrix, 'RowLabels', RL, 'ColumnLabels', CL, 'Symmetric', false, 'ColorMap', colormap('JET'))
addXLabel(HM, 'E class probability: Mesoderm', 'FontWeight', 'bold')
addYLabel(HM, 'E class probability: Endoderm', 'FontWeight', 'bold')
