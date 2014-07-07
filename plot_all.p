reset
set term png size 1280,960 transparent truecolor linewidth 3 24

# E class distribution for all three lineages
set xrange [1:1200]
set yrange [-0.03:1.03]
set xlabel "Gene rank"
set ylabel "Probability of being in E class"
set output "e_distr.png"
plot "ectoderm/e_percent.out" using 2 w l t "ectoderm",\
	 "mesoderm/e_percent.out" using 2 w l t "mesoderm",\
	 "endoderm/e_percent.out" using 2 w l t "endoderm"
set output

# C class distribution for all three lineages
set xrange[1:3200]
set yrange [-0.03:1.03]
set xlabel "Gene rank"
set ylabel "Probability of being in C class"
set output "c_distr.png"
plot "mesoderm/c_percent.out" using 2 w l t "mesoderm",\
	 "ectoderm/c_percent.out" using 2 w l t "ectoderm",\
	 "endoderm/c_percent.out" using 2 w l t "endoderm"
set output