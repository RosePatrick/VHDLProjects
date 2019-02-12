# 100MHz Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
	
	# LEDs 0 through 5
    set_property PACKAGE_PIN U16 [get_ports {main_trafficl[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {main_trafficl[0]}]
    set_property PACKAGE_PIN E19 [get_ports {main_trafficl[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {main_trafficl[1]}]
    set_property PACKAGE_PIN U19 [get_ports {main_trafficl[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {main_trafficl[2]}]
    set_property PACKAGE_PIN V19 [get_ports {secondary_trafficl[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {secondary_trafficl[0]}]
    set_property PACKAGE_PIN W18 [get_ports {secondary_trafficl[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {secondary_trafficl[1]}]
    set_property PACKAGE_PIN U15 [get_ports {secondary_trafficl[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {secondary_trafficl[2]}]
        
#Switches
    set_property PACKAGE_PIN V17 [get_ports {reset}]					
        set_property IOSTANDARD LVCMOS33 [get_ports {reset}]
       
