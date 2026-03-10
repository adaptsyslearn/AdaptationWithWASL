eps_type=2
op_type = eps_type

if(op_type == eps_type) \
set term postscript eps color font 28 dashed

set output 'stddevRL.eps'
set size 1, 1
set lmargin 7
set rmargin 1

set key top right samplen 2.5

set boxwidth 0.20

set style line 1 lc rgb 'red30' lt 1 lw 2
set style line 2 lc rgb 'black30' lt 1 lw 2
set style line 3 lc rgb 'blue50' lt 1 lw 2

set xtics rotate by 30
set xtics offset -6, -1.8
set ylabel "Std. Deviation" offset 1.5
set xlabel "Applications (RL Module)" offset 0.5, -1
set yrange [-0.15:4]


set offset 0.5, 0.5

set grid


plot 'stability.csv' u ($0-0.2):($5) w boxes ls 2 fs pattern 4 title "Uncoordinated", \
	''      u ($0):($6):xticlabel(1) w boxes ls 1 fs pattern 1 title "WASL", \
         ''     u ($0+0.2):($2) w boxes ls 8 fs pattern 2 title "Monolithic" 
      






