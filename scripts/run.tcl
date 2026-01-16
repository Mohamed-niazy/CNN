source ../scripts/common.tcl

if {[file exists $WAVE_DO]} {
    echo "Loading wave file: $WAVE_DO"
    do $WAVE_DO
} else {
    echo "Creating wave file for $TB_TOP"

    # TB hierarchy
    add wave -r sim:/$TB_TOP/*

    # DUT hierarchy (assumes dut instance name)
    if {[catch {add wave -r sim:/$TB_TOP/dut/*}]} {
        echo "⚠ DUT hierarchy not found"
    }

    # Save wave setup
    write format wave -window .main_pane.wave.interior $WAVE_DO
}

run -all

# Save waveform
write wlf $WLF_FILE

echo "Simulation completed"
