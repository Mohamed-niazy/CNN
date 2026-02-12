# Load shared variables and settings (paths, options, etc.)
source ../scripts/common.tcl

# Print compile banner
echo "==============================="
echo " Compile started"
echo "==============================="

# Create and map work library if it doesn't exist
if {![file exists "$WORK_DIR/work"]} {
    vlib work
}
vmap work work


# ------------------------------------------------------------
# Recursively collect files matching a given pattern
# (used because older Tcl does not support -recursive)
# ------------------------------------------------------------
proc recursive_glob {dir pattern} {
    set result {}

    # Collect matching files in current directory
    foreach file [glob -nocomplain -directory $dir -types f $pattern] {
        lappend result $file
    }

    # Search subdirectories recursively
    foreach subdir [glob -nocomplain -directory $dir -types d *] {
        set result [concat $result [recursive_glob $subdir $pattern]]
    }

    return $result
}

# Create timestamped compile log file
set ts [clock format [clock seconds] -format "%Y-%m-%d__%H-%M"]
set LOG_FILE "$LOG_DIR/$TB_TOP/compile_$ts.log"

# Enable transcript logging
transcript file $LOG_FILE
transcript on

# Collect Testbench files
set TB_V_FILES   [recursive_glob $TB_DIR  *.v]
set TB_SV_FILES  [recursive_glob $TB_DIR  *.sv]
set TB_SVH_FILES [recursive_glob $TB_DIR  *.svh]

# Collect RTL files
set RTL_V_FILES   [recursive_glob $RTL_DIR  *.v]
set RTL_SV_FILES  [recursive_glob $RTL_DIR  *.sv]
set RTL_SVH_FILES [recursive_glob $RTL_DIR  *.svh]

# ------------------------------------------------------------
# Compile RTL files (only if list is non-empty)
# ------------------------------------------------------------
if {[llength $RTL_V_FILES]} {
    vlog {*}$VLOG_OPTS {*}$RTL_V_FILES
}
if {[llength $RTL_SV_FILES]} {
    vlog {*}$VLOG_OPTS {*}$RTL_SV_FILES
}
if {[llength $RTL_SVH_FILES]} {
    vlog {*}$VLOG_OPTS {*}$RTL_SVH_FILES
}

# ------------------------------------------------------------
# Compile Testbench files
# ------------------------------------------------------------
if {[llength $TB_V_FILES]} {
    vlog {*}$VLOG_OPTS {*}$TB_V_FILES
}
if {[llength $TB_SV_FILES]} {
    vlog {*}$VLOG_OPTS {*}$TB_SV_FILES
}
if {[llength $TB_SVH_FILES]} {
    vlog {*}$VLOG_OPTS {*}$TB_SVH_FILES
}

# Check transcript for compilation errors
if {[string match "*Error:*" [transcript]]} {
    echo "❌ Compilation failed"
    quit -code 1
}

# Disable logging
transcript off

echo "✅ Compilation finished"
