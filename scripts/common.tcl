# ===============================
# Tops (CHANGE WHEN NEEDED)
# ===============================
set RTL_TOP "rtl_top"
set TB_TOP  "CNN_tb"

# ===============================
# Project paths
# ===============================
set PROJ_ROOT "E:/CNN"
set ENABLE_LINT 0

set RTL_DIR   "$PROJ_ROOT/HDL/RTL"
set TB_DIR    "$PROJ_ROOT/HDL/TB"
set WORK_DIR  "$PROJ_ROOT/QuestaSim/work"
set WAVE_DIR  "$PROJ_ROOT/QuestaSim/waves"
set LOG_DIR   "$PROJ_ROOT/QuestaSim/logs"
set TXT_DIR  "$PROJ_ROOT/TxtFiles"
set TB_LOG_DIR "$LOG_DIR/${TB_TOP}"; # used to logs the simulation results of the current TB


# Dynamic wave files (per TB top)
set WAVE_DO  "$WAVE_DIR/${TB_TOP}/wave.do"
set WLF_FILE "$WAVE_DIR/${TB_TOP}/wave.wlf"
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
foreach dir [list $WORK_DIR $WAVE_DIR $LOG_DIR $TB_LOG_DIR $TXT_DIR] {
    if {![file exists $dir]} {
        file mkdir $dir
    }
}


alias re {
    do ../scripts/compile.tcl
    restart
    run -all
}