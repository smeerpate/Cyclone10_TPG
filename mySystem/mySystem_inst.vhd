	component mySystem is
		port (
			alt_vip_cl_cvo_0_clocked_video_vid_clk                         : in    std_logic                     := 'X';             -- vid_clk
			alt_vip_cl_cvo_0_clocked_video_vid_data                        : out   std_logic_vector(23 downto 0);                    -- vid_data
			alt_vip_cl_cvo_0_clocked_video_underflow                       : out   std_logic;                                        -- underflow
			alt_vip_cl_cvo_0_clocked_video_vid_datavalid                   : out   std_logic;                                        -- vid_datavalid
			alt_vip_cl_cvo_0_clocked_video_vid_v_sync                      : out   std_logic;                                        -- vid_v_sync
			alt_vip_cl_cvo_0_clocked_video_vid_h_sync                      : out   std_logic;                                        -- vid_h_sync
			alt_vip_cl_cvo_0_clocked_video_vid_f                           : out   std_logic;                                        -- vid_f
			alt_vip_cl_cvo_0_clocked_video_vid_h                           : out   std_logic;                                        -- vid_h
			alt_vip_cl_cvo_0_clocked_video_vid_v                           : out   std_logic;                                        -- vid_v
			clk_clk                                                        : in    std_logic                     := 'X';             -- clk
			pio_0_external_connection_export                               : out   std_logic_vector(1 downto 0);                     -- export
			reset_reset_n                                                  : in    std_logic                     := 'X';             -- reset_n
			uart_0_external_connection_rxd                                 : in    std_logic                     := 'X';             -- rxd
			uart_0_external_connection_txd                                 : out   std_logic;                                        -- txd
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_addr  : out   std_logic_vector(12 downto 0);                    -- sdram_addr
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_ba    : out   std_logic_vector(1 downto 0);                     -- sdram_ba
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cas_n : out   std_logic;                                        -- sdram_cas_n
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cke   : out   std_logic;                                        -- sdram_cke
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cs_n  : out   std_logic;                                        -- sdram_cs_n
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_dq    : inout std_logic_vector(15 downto 0) := (others => 'X'); -- sdram_dq
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_dqm   : out   std_logic_vector(1 downto 0);                     -- sdram_dqm
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_ras_n : out   std_logic;                                        -- sdram_ras_n
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_we_n  : out   std_logic                                         -- sdram_we_n
		);
	end component mySystem;

	u0 : component mySystem
		port map (
			alt_vip_cl_cvo_0_clocked_video_vid_clk                         => CONNECTED_TO_alt_vip_cl_cvo_0_clocked_video_vid_clk,                         --                     alt_vip_cl_cvo_0_clocked_video.vid_clk
			alt_vip_cl_cvo_0_clocked_video_vid_data                        => CONNECTED_TO_alt_vip_cl_cvo_0_clocked_video_vid_data,                        --                                                   .vid_data
			alt_vip_cl_cvo_0_clocked_video_underflow                       => CONNECTED_TO_alt_vip_cl_cvo_0_clocked_video_underflow,                       --                                                   .underflow
			alt_vip_cl_cvo_0_clocked_video_vid_datavalid                   => CONNECTED_TO_alt_vip_cl_cvo_0_clocked_video_vid_datavalid,                   --                                                   .vid_datavalid
			alt_vip_cl_cvo_0_clocked_video_vid_v_sync                      => CONNECTED_TO_alt_vip_cl_cvo_0_clocked_video_vid_v_sync,                      --                                                   .vid_v_sync
			alt_vip_cl_cvo_0_clocked_video_vid_h_sync                      => CONNECTED_TO_alt_vip_cl_cvo_0_clocked_video_vid_h_sync,                      --                                                   .vid_h_sync
			alt_vip_cl_cvo_0_clocked_video_vid_f                           => CONNECTED_TO_alt_vip_cl_cvo_0_clocked_video_vid_f,                           --                                                   .vid_f
			alt_vip_cl_cvo_0_clocked_video_vid_h                           => CONNECTED_TO_alt_vip_cl_cvo_0_clocked_video_vid_h,                           --                                                   .vid_h
			alt_vip_cl_cvo_0_clocked_video_vid_v                           => CONNECTED_TO_alt_vip_cl_cvo_0_clocked_video_vid_v,                           --                                                   .vid_v
			clk_clk                                                        => CONNECTED_TO_clk_clk,                                                        --                                                clk.clk
			pio_0_external_connection_export                               => CONNECTED_TO_pio_0_external_connection_export,                               --                          pio_0_external_connection.export
			reset_reset_n                                                  => CONNECTED_TO_reset_reset_n,                                                  --                                              reset.reset_n
			uart_0_external_connection_rxd                                 => CONNECTED_TO_uart_0_external_connection_rxd,                                 --                         uart_0_external_connection.rxd
			uart_0_external_connection_txd                                 => CONNECTED_TO_uart_0_external_connection_txd,                                 --                                                   .txd
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_addr  => CONNECTED_TO_w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_addr,  -- w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end.sdram_addr
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_ba    => CONNECTED_TO_w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_ba,    --                                                   .sdram_ba
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cas_n => CONNECTED_TO_w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cas_n, --                                                   .sdram_cas_n
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cke   => CONNECTED_TO_w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cke,   --                                                   .sdram_cke
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cs_n  => CONNECTED_TO_w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_cs_n,  --                                                   .sdram_cs_n
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_dq    => CONNECTED_TO_w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_dq,    --                                                   .sdram_dq
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_dqm   => CONNECTED_TO_w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_dqm,   --                                                   .sdram_dqm
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_ras_n => CONNECTED_TO_w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_ras_n, --                                                   .sdram_ras_n
			w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_we_n  => CONNECTED_TO_w9825g6kh_sdramcontroller_100mhz_cl3_0_conduit_end_sdram_we_n   --                                                   .sdram_we_n
		);

