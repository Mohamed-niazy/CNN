# ===============================
# Project paths
# ===============================
set PROJ_ROOT "E:/CNN"

set RTL_DIR   "$PROJ_ROOT/HDL/RTL"
set TB_DIR    "$PROJ_ROOT/HDL/TB"
set LOG_DIR   "$PROJ_ROOT/QuestaSim/logs"
set WORK_DIR  "$PROJ_ROOT/QuestaSim/work"
set WAVE_DIR  "$PROJ_ROOT/QuestaSim/waves"

set ENABLE_LINT 1


# ===============================
# Tops (CHANGE WHEN NEEDED)
# ===============================
set RTL_TOP "rtl_top"
set TB_TOP  "conv_buffer_tb"


# Dynamic wave files (per TB top)
set WAVE_DO  "$WAVE_DIR/${TB_TOP}/wave.do"
set WLF_FILE "$WAVE_DIR/${TB_TOP}/wave.wlf"
# ===============================
# used to logs the simulation results of the current TB
set TB_LOG_DIR "$LOG_DIR/${TB_TOP}"  


# ===============================
# Simulator options
# ===============================
# ===============================
# VLOG options (LIST)
# ===============================
set VLOG_OPTS {
    -sv
    -work
    work
    +acc
    -lint
}

if {$ENABLE_LINT} {
    lappend VLOG_OPTS -lint
}
# ===============================
# VSIM options (LIST)
# ===============================
set VSIM_OPTS {
    -voptargs=+acc
    -t
    1ns
}



# ===============================
# Create dirs if not exist
# ===============================
foreach dir [list $WORK_DIR $WAVE_DIR $LOG_DIR $TB_LOG_DIR] {
    if {![file exists $dir]} {
        file mkdir $dir
    }
}


alias re {
    do ../scripts/compile.tcl
    restart
    run -all
}