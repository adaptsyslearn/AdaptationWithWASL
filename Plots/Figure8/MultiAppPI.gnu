eps_type=2
op_type = eps_type

if(op_type == eps_type) \
set term postscript enhanced eps color font 28 dashed


set output 'multiAppPI.eps'
set size 2, 1
set lmargin 7
set rmargin 1

set key top right horizontal samplen 2.5


set boxwidth 0.15 relative

set style line 1 lc rgb 'red30' lt 1 lw 2
set style line 2 lc rgb 'black30' lt 1 lw 2
set style line 3 lc rgb 'blue50' lt 1 lw 2

set xtics rotate by 15 font ", 25"
set xtics offset -9, -1.3
set ylabel 'N-P95 Tail Latency' 
set xlabel "Multiple Applications (PI Module)" offset 0.5, -1
set yrange [-0.15:37]

set autoscale xfix

set offset 0.25, 0.25

set grid


plot \
'MultiAppPI.csv' u ($0-0.15):($3/$2) w boxes ls 2 fs pattern 4 title "Uncoordinated", \
	''      u ($0):($2/$2):xticlabel(1) w boxes ls 1 fs pattern 1 title "WASL", \
	''      u ($0+0.15):($5/$4) w boxes ls 2 fs pattern 4 notitle, \
        ''     u ($0+0.3):($4/$4) w boxes ls 1 fs pattern 1 notitle " "
     

#Normalized by column $2 and $4, $3 & 5 - Uncoordinated, $2 and 4: WASL  






