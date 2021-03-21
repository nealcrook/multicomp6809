restart
force clk 1 0, 0 10ns -repeat 20ns
force n_SwRst 1
force n_SwWarmRst 0
force n_SwNMI 1
run 100ns
force n_SwRst 1
force n_SwWarmRst 1
run 1000ns
force n_SwNMI 0
# needs to be low long enough for debounce counter to expire
run 10000ns
force n_SwNMI 1
run 5000ns

