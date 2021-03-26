restart
force clk 1 0, 0 10ns -repeat 20ns
force SerRxBdClk 1 0, 0 400ns -repeat 800ns
force SerTxBdClk 1 0, 0 600ns -repeat 1200ns
## COLD RESET
force n_SwRst 0
force n_SwWarmRst 1
force n_SwNMI 1
run 100ns
force n_SwRst 1
force n_SwWarmRst 1
# run long enough for SBootROM to clear the COLD bit
run 10000ns
## WARM RESET
#force n_SwWarmRst 0
#run 100ns
#force n_SwWarmRst 1
#run 2000ns



## force n_SwNMI 0
## # needs to be low long enough for debounce counter to expire
## run 10000ns
## force n_SwNMI 1

## run 5000ns

