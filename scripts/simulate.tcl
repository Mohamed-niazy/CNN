source ../scripts/common.tcl

# Compile first
do ../scripts/compile.tcl

# Start simulation (GUI)
vsim {*}$VSIM_OPTS \
    -wlf $WLF_FILE \
    +LOG_DIR=$TB_LOG_DIR \
    +TXT_DIR=$TXT_DIR \
        work.$TB_TOP

# Run
do ../scripts/run.tcl
