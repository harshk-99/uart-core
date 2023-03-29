export UART_HOME = ${PWD}/../..
export RTL_HOME = ${UART_HOME}/src
export DV_HOME  = ${UART_HOME}/dv

UVM_HOME   = ${UART_HOME}/uvm
SIMULATOR	:= SYNOPSYS
VCS				 = vcs -licqueue -timescale=1ns/1ns +vcs+flush+all +warn=all -sverilog +incdir+${UVM_HOME}/src ${UVM_HOME}/src/uvm.sv ${UVM_HOME}/src/dpi/uvm_dpi.cc -CFLAGS -DVCS ${UVM_HOME}/src/uvm_pkg.sv
VLOG		   = vlib work && vlog -writetoplevels questa.tops -timescale 1ns/1ns +incdir+${UVM_HOME}/src -L ${QUESTA_HOME}/uvm-1.2
XRUN       = xrun -Q -unbuffered -timescale 1ns/1ns -sysv -access +rw -uvmnocdnsextra -uvmhome ${UVM_HOME} ${UVM_HOME}/src/uvm_macros.svh
VSIM			 = vsim -f questa.tops -batch -do "vsim -voptargs=+acc=npr; run 10 ms; exit" -voptargs=+acc=npr
SIMV       = simv
VERDI      = verdi -autoalias -nologo
URG        = urg -full64 -warn none -format both
SEED       = 1
TEST      := rand_baud_test

all: compile simulate

compile:
	ifeq (${SIMULATOR}, SYNOPSYS)
		${VCS} -f ${DV_HOME}/sv/top/uart.f -ntb_opts uvm-1.2 ${OPT}
	else ifeq ((${SIMULATOR}, QUESTA))
		${VLOG} -f ${DV_HOME}/sv/top/uart.f
	else ifeq ((${SIMULATOR}, CADENCE))
		${XRUN} -f ${DV_HOME}/sv/top/uart.f
simulate:
	ifeq (${SIMULATOR}, SYNOPSYS)
		${SIMV} +UVM_TESTNAME=${TEST} +seed=${SEED} +ntb_random_seed=${SEED} +debussy -l simulate.log ${OPT}
	else ifeq (${SIMULATOR}, QUESTA)
		${VSIM} -sv_uvm_set_testname ${TEST} -sv_seed ${SEED} -l simulate.log
	else ifeq (${SIMULATOR}, CADENCE)
		xrun +UVM_TESTNAME=${TEST} +UVM_SEED=${SEED} +UVM_RANDOM_SEED=${SEED} +UVM_LOG_FILE=simulate.log

waveform: 
	${VERDI} -ssf debussy.fsdb -f ${DV_HOME}/tb/alu.f -top alu_tb ${OPT}

coverage: 
	${URG} -dir ${COV_DB} -report coverage_report ${OPT}

.PHONY: all

clean:
	@find . -maxdepth 1 \( -type f -o -type d \) \( ! -name '.' -a ! -name 'Makefile' -a ! -name '*.csh' -a ! -name '*.f' -a ! -name '*.pl' \) -exec rm -rf {} +
