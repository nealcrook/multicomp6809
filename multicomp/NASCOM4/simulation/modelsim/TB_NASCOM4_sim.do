restart
force clk 1 0, 0 10ns -repeat 20ns
force n_reset 0
run 100ns
force n_reset 1

