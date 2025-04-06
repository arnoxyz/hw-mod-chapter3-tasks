onerror {resume}
radix define redlight {
    "1'b0" "OFF" -color "white",
    "1'b1" "ON" -color "red",
    -default binary
}
radix define greenlight {
    "1'b0" "OFF" -color "white",
    "1'b1" "ON" -color "green",
    -default binary
}
radix define yelllight {
    "1'b0" "OFF" -color "white",
    "1'b1" "ON" -color "yellow",
    -default binary
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /timer_tb/clk_stop
add wave -noupdate /timer_tb/clk
add wave -noupdate /timer_tb/res_n
add wave -noupdate /timer_tb/en
add wave -noupdate /timer_tb/tick
add wave -noupdate /timer_tb/N
add wave -noupdate /timer_tb/clk_period
add wave -noupdate -expand /timer_tb/uut/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {32408 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {5844 ps}
