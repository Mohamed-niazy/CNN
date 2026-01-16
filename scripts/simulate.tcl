source ../scripts/common.tcl

# Compile first
do ../scripts/compile.tcl

# Start simulation (GUI)
vsim {*}$VSIM_OPTS \
    -wlf $WLF_FILE \
    +LOG_DIR=$TB_LOG_DIR/results.txt \
    work.$TB_TOP

# Run
do ../scripts/run.tcl
