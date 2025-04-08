onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /running_light_tb/leds
add wave -noupdate /running_light_tb/clk
add wave -noupdate /running_light_tb/res_n
add wave -noupdate /running_light_tb/CLK_PERIOD
add wave -noupdate -divider UUT-Internal
add wave -noupdate /running_light_tb/UUT/WAIT_TIME
add wave -noupdate /running_light_tb/UUT/CLK_FREQ
add wave -noupdate /running_light_tb/UUT/CLK_PERIOD
add wave -noupdate /running_light_tb/UUT/CC_WAIT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {125287 ps}
