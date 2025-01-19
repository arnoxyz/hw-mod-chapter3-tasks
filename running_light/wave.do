onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /running_light_tb/LEDS_WIDTH
add wave -noupdate -expand /running_light_tb/leds
add wave -noupdate -divider {clk stuff}
add wave -noupdate /running_light_tb/stop_clk
add wave -noupdate /running_light_tb/clk
add wave -noupdate /running_light_tb/res_n
add wave -noupdate /running_light_tb/CLK_PERIOD
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {210764 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 252
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {651 ns}
