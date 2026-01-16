source ../scripts/common.tcl

echo "==============================="
echo " Compile started"
echo "==============================="

# Create library
if {![file exists "$WORK_DIR/work"]} {
    vlib work
}
vmap work work




# Create timestamped log file
set ts [clock format [clock seconds] -format "%Y-%m-%d__%H-%M"]
set LOG_FILE "$LOG_DIR/$TB_TOP/compile_$ts.log"

# Enable logging
transcript file $LOG_FILE
transcript on

set TB_V_FILES  [glob -nocomplain $TB_DIR/*.v]
set TB_SV_FILES [glob -nocomplain $TB_DIR/*.sv]

set RTL_V_FILES  [glob -nocomplain $RTL_DIR/*.v]
set RTL_SV_FILES [glob -nocomplain $RTL_DIR/*.sv]

# Compile RTL
if {[llength $RTL_V_FILES]} {
    vlog {*}$VLOG_OPTS {*}$RTL_V_FILES
}
if {[llength $RTL_SV_FILES]} {
    vlog {*}$VLOG_OPTS {*}$RTL_SV_FILES
}

# Compile TB
if {[llength $TB_V_FILES]} {
    vlog {*}$VLOG_OPTS {*}$TB_V_FILES
}
if {[llength $TB_SV_FILES]} {
    vlog {*}$VLOG_OPTS {*}$TB_SV_FILES
}


# Check errors
if {[string match "*Error:*" [transcript]]} {
    echo "❌ Compilation failed"
    quit -code 1
}

# Stop logging
transcript off

echo "✅ Compilation finished"
