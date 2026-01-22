
# read constraints
read_xdc "basys3.xdc"

# synth
synth_design -top "top" -part "xc7a35ticpg236-1L"

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "flash.bit"
