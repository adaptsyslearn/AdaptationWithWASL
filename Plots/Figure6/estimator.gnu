eps_type=2
op_type = eps_type

if(op_type == eps_type) \
set term postscript eps color font 18 dashed

set output 'estimator.eps'
set size 1.2, 0.8


set key top horizontal samplen 2.5

set boxwidth 0.20

set style line 1 lc rgb 'red30' lt 1 lw 2
set style line 2 lc rgb 'black30' lt 1 lw 2
set style line 3 lc rgb 'blue50' lt 1 lw 2

set xtics rotate 60
set ylabel "detour (Normalized)" offset 1.5
set xlabel "Statistical Estimators" offset 0.5, 0.5

set yrange [-0.15:2.25]

set autoscale xfix

set offset 0.5, 0.5

set grid

set object 1 rect from  0.5,0 to 5.25,1.8
set object 1 rect fc rgb "grey90" fillstyle solid 1.0


set object 2 rect from  5.55,0 to 11.25,1.8
set object 2 rect fc rgb "beige" fillstyle solid 1.0

set object 3 rect from  11.55,0 to 17.25,1.8
set object 3 rect fc rgb "honeydew" fillstyle solid 1.0

plot \
'Fig-2Data.csv' u ($0-0.2):($2/17.09) w boxes ls 1 fs pattern 1 title "System-Level", \
	''      u ($0):($3/16.99):xticlabels(1) w boxes ls 2 fs pattern 4 title "Application-Level",\
      






