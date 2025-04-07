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
add wave -noupdate /traffic_light_tb/clk
add wave -noupdate /traffic_light_tb/clk_period
add wave -noupdate /traffic_light_tb/clk_stop
add wave -noupdate /traffic_light_tb/res_n
add wave -noupdate /traffic_light_tb/btn_n
add wave -noupdate /traffic_light_tb/pl
add wave -noupdate /traffic_light_tb/tl
add wave -noupdate /traffic_light_tb/CLK_FREQ
add wave -noupdate /traffic_light_tb/WAIT_TIME
add wave -noupdate -expand -subitemconfig {/traffic_light_tb/uut/s.clk_cnt -expand} /traffic_light_tb/uut/s
add wave -noupdate -expand /traffic_light_tb/uut/s_nxt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {17465139442 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 212
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
WaveRestoreZoom {0 ps} {11195154382470 ps}
