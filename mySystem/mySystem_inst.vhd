	component mySystem is
		port (
			clk_clk                                         : in    std_logic                     := 'X';             -- clk
			reset_reset_n                                   : in    std_logic                     := 'X';             -- reset_n
			new_sdram_controller_0_wire_addr                : out   std_logic_vector(12 downto 0);                    -- addr
			new_sdram_controller_0_wire_ba                  : out   std_logic_vector(1 downto 0);                     -- ba
			new_sdram_controller_0_wire_cas_n               : out   std_logic;                                        -- cas_n
			new_sdram_controller_0_wire_cke                 : out   std_logic;                                        -- cke
			new_sdram_controller_0_wire_cs_n                : out   std_logic;                                        -- cs_n
			new_sdram_controller_0_wire_dq                  : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			new_sdram_controller_0_wire_dqm                 : out   std_logic_vector(1 downto 0);                     -- dqm
			new_sdram_controller_0_wire_ras_n               : out   std_logic;                                        -- ras_n
			new_sdram_controller_0_wire_we_n                : out   std_logic;                                        -- we_n
			altpll_0_c1_clk                                 : out   std_logic;                                        -- clk
			clock_bridge_0_in_clk_clk                       : in    std_logic                     := 'X';             -- clk
			video_vga_controller_0_external_interface_CLK   : out   std_logic;                                        -- CLK
			video_vga_controller_0_external_interface_HS    : out   std_logic;                                        -- HS
			video_vga_controller_0_external_interface_VS    : out   std_logic;                                        -- VS
			video_vga_controller_0_external_interface_BLANK : out   std_logic;                                        -- BLANK
			video_vga_controller_0_external_interface_SYNC  : out   std_logic;                                        -- SYNC
			video_vga_controller_0_external_interface_R     : out   std_logic_vector(7 downto 0);                     -- R
			video_vga_controller_0_external_interface_G     : out   std_logic_vector(7 downto 0);                     -- G
			video_vga_controller_0_external_interface_B     : out   std_logic_vector(7 downto 0)                      -- B
		);
	end component mySystem;

	u0 : component mySystem
		port map (
			clk_clk                                         => CONNECTED_TO_clk_clk,                                         --                                       clk.clk
			reset_reset_n                                   => CONNECTED_TO_reset_reset_n,                                   --                                     reset.reset_n
			new_sdram_controller_0_wire_addr                => CONNECTED_TO_new_sdram_controller_0_wire_addr,                --               new_sdram_controller_0_wire.addr
			new_sdram_controller_0_wire_ba                  => CONNECTED_TO_new_sdram_controller_0_wire_ba,                  --                                          .ba
			new_sdram_controller_0_wire_cas_n               => CONNECTED_TO_new_sdram_controller_0_wire_cas_n,               --                                          .cas_n
			new_sdram_controller_0_wire_cke                 => CONNECTED_TO_new_sdram_controller_0_wire_cke,                 --                                          .cke
			new_sdram_controller_0_wire_cs_n                => CONNECTED_TO_new_sdram_controller_0_wire_cs_n,                --                                          .cs_n
			new_sdram_controller_0_wire_dq                  => CONNECTED_TO_new_sdram_controller_0_wire_dq,                  --                                          .dq
			new_sdram_controller_0_wire_dqm                 => CONNECTED_TO_new_sdram_controller_0_wire_dqm,                 --                                          .dqm
			new_sdram_controller_0_wire_ras_n               => CONNECTED_TO_new_sdram_controller_0_wire_ras_n,               --                                          .ras_n
			new_sdram_controller_0_wire_we_n                => CONNECTED_TO_new_sdram_controller_0_wire_we_n,                --                                          .we_n
			altpll_0_c1_clk                                 => CONNECTED_TO_altpll_0_c1_clk,                                 --                               altpll_0_c1.clk
			clock_bridge_0_in_clk_clk                       => CONNECTED_TO_clock_bridge_0_in_clk_clk,                       --                     clock_bridge_0_in_clk.clk
			video_vga_controller_0_external_interface_CLK   => CONNECTED_TO_video_vga_controller_0_external_interface_CLK,   -- video_vga_controller_0_external_interface.CLK
			video_vga_controller_0_external_interface_HS    => CONNECTED_TO_video_vga_controller_0_external_interface_HS,    --                                          .HS
			video_vga_controller_0_external_interface_VS    => CONNECTED_TO_video_vga_controller_0_external_interface_VS,    --                                          .VS
			video_vga_controller_0_external_interface_BLANK => CONNECTED_TO_video_vga_controller_0_external_interface_BLANK, --                                          .BLANK
			video_vga_controller_0_external_interface_SYNC  => CONNECTED_TO_video_vga_controller_0_external_interface_SYNC,  --                                          .SYNC
			video_vga_controller_0_external_interface_R     => CONNECTED_TO_video_vga_controller_0_external_interface_R,     --                                          .R
			video_vga_controller_0_external_interface_G     => CONNECTED_TO_video_vga_controller_0_external_interface_G,     --                                          .G
			video_vga_controller_0_external_interface_B     => CONNECTED_TO_video_vga_controller_0_external_interface_B      --                                          .B
		);

