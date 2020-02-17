	mySystem u0 (
		.clk_clk                                         (<connected-to-clk_clk>),                                         //                                       clk.clk
		.reset_reset_n                                   (<connected-to-reset_reset_n>),                                   //                                     reset.reset_n
		.new_sdram_controller_0_wire_addr                (<connected-to-new_sdram_controller_0_wire_addr>),                //               new_sdram_controller_0_wire.addr
		.new_sdram_controller_0_wire_ba                  (<connected-to-new_sdram_controller_0_wire_ba>),                  //                                          .ba
		.new_sdram_controller_0_wire_cas_n               (<connected-to-new_sdram_controller_0_wire_cas_n>),               //                                          .cas_n
		.new_sdram_controller_0_wire_cke                 (<connected-to-new_sdram_controller_0_wire_cke>),                 //                                          .cke
		.new_sdram_controller_0_wire_cs_n                (<connected-to-new_sdram_controller_0_wire_cs_n>),                //                                          .cs_n
		.new_sdram_controller_0_wire_dq                  (<connected-to-new_sdram_controller_0_wire_dq>),                  //                                          .dq
		.new_sdram_controller_0_wire_dqm                 (<connected-to-new_sdram_controller_0_wire_dqm>),                 //                                          .dqm
		.new_sdram_controller_0_wire_ras_n               (<connected-to-new_sdram_controller_0_wire_ras_n>),               //                                          .ras_n
		.new_sdram_controller_0_wire_we_n                (<connected-to-new_sdram_controller_0_wire_we_n>),                //                                          .we_n
		.altpll_0_c1_clk                                 (<connected-to-altpll_0_c1_clk>),                                 //                               altpll_0_c1.clk
		.clock_bridge_0_in_clk_clk                       (<connected-to-clock_bridge_0_in_clk_clk>),                       //                     clock_bridge_0_in_clk.clk
		.video_vga_controller_0_external_interface_CLK   (<connected-to-video_vga_controller_0_external_interface_CLK>),   // video_vga_controller_0_external_interface.CLK
		.video_vga_controller_0_external_interface_HS    (<connected-to-video_vga_controller_0_external_interface_HS>),    //                                          .HS
		.video_vga_controller_0_external_interface_VS    (<connected-to-video_vga_controller_0_external_interface_VS>),    //                                          .VS
		.video_vga_controller_0_external_interface_BLANK (<connected-to-video_vga_controller_0_external_interface_BLANK>), //                                          .BLANK
		.video_vga_controller_0_external_interface_SYNC  (<connected-to-video_vga_controller_0_external_interface_SYNC>),  //                                          .SYNC
		.video_vga_controller_0_external_interface_R     (<connected-to-video_vga_controller_0_external_interface_R>),     //                                          .R
		.video_vga_controller_0_external_interface_G     (<connected-to-video_vga_controller_0_external_interface_G>),     //                                          .G
		.video_vga_controller_0_external_interface_B     (<connected-to-video_vga_controller_0_external_interface_B>)      //                                          .B
	);

