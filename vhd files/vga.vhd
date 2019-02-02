-- ****************************************************
--                    Proyecto Final   
-- ****************************************************
-- Integrantes:
--   Garrido Lopez Luis Enrique
--   Miramonte Sarabia Luis Enrique
--   Ortiz Figueroa Maria Fernanda
-- ****************************************************

-- ****************************************************
--         Modulo para conectar los componentes 
--               principales del programa
-- ****************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga is
	port(
		-- CLK 
		clock_50: in std_logic_vector(1 downto 0);
		vga_hs, vga_vs, fire_led_o : out std_logic;
		-- Auxiliar para poder controlar lo que se ve en la
		-- pantalla, ya se han líneas verticales u horizontales		
		-- Control horizontal y vertical
		switch : in std_logic;
		-- Control color RGB
		vga_r, vga_g, vga_b: out std_logic_vector(3 downto 0);
		mov: in std_logic_vector (4 downto 0)
	);
end vga;

architecture main of vga is
	-- Variable auxiliar para el manejo de clk y reset
	signal vgaclk, reset, enable: std_logic := '0';
	signal address_mem : std_logic_vector(18 downto 0) := "0000000000000000000";
	signal data_in, data_out : std_logic_vector(11 downto 0);
	signal bullet_signal, shot_enable, shot_created, draw_bullet, draw_fairy, fairy_signal : std_logic;
	signal c_type, e_type: std_logic_vector(1 downto 0);
	signal hposo, vposo, fig_x1o, fig_y1o: integer;
	signal rgb_bullet, rgb_fairy: std_logic_vector(11 downto 0);
	signal button_deb, enable_rng, seed, done_rng: STD_LOGIC;
	signal data_stream_in, data_stream_out: std_logic_vector(31 downto 0);
	signal b1_x, b2_x, b3_x, b4_x, b5_x, b6_x, b1_y, b2_y, b3_y, b4_y, b5_y, b6_y: integer;
	signal b1_del, b2_del, b3_del, b4_del, b5_del, b6_del: std_logic;
	signal e1_x, e2_x, e3_x, e4_x, e5_x, e6_x, e7_x, e8_x, e9_x: integer := 0;
	signal e1_y, e2_y, e3_y, e4_y, e5_y, e6_y, e7_y, e8_y, e9_y: integer := 0;
	signal e1_del, e2_del, e3_del, e4_del, e5_del, e6_del, e7_del, e8_del, e9_del: std_logic := '0';

	
	-- Se define el siguiente componente para hacer
	-- uso del clock de la IP
	component clockd is
        port (
            clk_in_clk  : in  std_logic := 'X'; -- clk
				clk_out_clk : out std_logic;        -- clk
				reset_reset : in  std_logic := 'X'  -- reset

        );
	end component clockd;

	-- Se define el siguiente componente para hacer
	-- la sincronización, así como como el control RGB
	component sync is 
		port(
			clk: in std_logic;
			hsync, vsync: out std_logic;
			switch : in std_logic;
			r,g,b : out std_logic_vector(3 downto 0);
			movement: in std_logic_vector(4 downto 0);
			bullet_signal: out std_logic;
			shot_enable : out std_logic;
			shot_created: in std_logic;
			c_type: in std_logic_vector(1 downto 0);
			hpos_o, vpos_o, fig_x1_o, fig_y1_o: out integer;
			rgb_bullet: in std_logic_vector(11 downto 0);
			draw_bullet: in std_logic;
			button_debounced: in std_logic;
			fairy_signal: out std_logic;
			rgb_fairy: in std_logic_vector(11 downto 0);
			draw_fairy: in std_logic;
			e_type: in std_logic_vector(1 downto 0);
			b1_del, b2_del, b3_del, b4_del, b5_del, b6_del: in std_logic;
			e1_x, e2_x, e3_x, e4_x, e5_x, e6_x, e7_x, e8_x, e9_x: in integer;
			e1_y, e2_y, e3_y, e4_y, e5_y, e6_y, e7_y, e8_y, e9_y: in integer;
			e1_del, e2_del, e3_del, e4_del, e5_del, e6_del, e7_del,e8_del, e9_del: out std_logic:= '0'
		);
	end component sync;

	component bullet_tracking is 
		port(
			 clk: in std_logic;
		 shot_enable: in std_logic;
		 shot_created: out std_logic;
		 xcur, ycur, xpos_player, ypos_player: in integer;
		 rgb: out std_logic_vector(11 downto 0);
		 draw: out std_logic;
		 button: in std_logic;
		 bullet_signal: in std_logic;
		 c_type: out std_logic_vector(1 downto 0);
		 fire_led: out std_logic;
		 b1_x, b2_x, b3_x, b4_x, b5_x, b6_x: out integer:= 0;
		 b1_y, b2_y, b3_y, b4_y, b5_y, b6_y: out integer:= 0;
		 b1_del, b2_del, b3_del, b4_del, b5_del, b6_del: in std_logic
		);
	end component bullet_tracking;
	
	component Debounce_Switch is 
		port(
			i_Clk    : in  std_logic;
			i_Switch : in  std_logic;
			o_Switch : out std_logic
		);
	end component Debounce_Switch;
	
	component LFSR is 
		port(
	 i_Clk    : in std_logic;
    i_Enable : in std_logic;
    ---
    i_Seed_DV   : in std_logic;
    i_Seed_Data : in std_logic_vector(31 downto 0);
    ----
    o_LFSR_Data : out std_logic_vector(31 downto 0);
    o_LFSR_Done : out std_logic
		);
	end component LFSR;
	
	component enemy_control is 
		port(
		 clk: in std_logic;
		 xcur, ycur: in integer;
		 rgb: out std_logic_vector(11 downto 0);
		 draw: out std_logic;
		 fairy_signal: in std_logic;
		 e_type: out std_logic_vector(1 downto 0);
		 b1_x, b2_x, b3_x, b4_x, b5_x, b6_x: in integer;
		 b1_y, b2_y, b3_y, b4_y, b5_y, b6_y: in integer;
		 random_bit: in std_logic;
		 b1_del, b2_del, b3_del, b4_del, b5_del, b6_del: out std_logic := '0';
		 e1_x, e2_x, e3_x, e4_x, e5_x, e6_x, e7_x, e8_x, e9_x: out integer := 0;
		 e1_y, e2_y, e3_y, e4_y, e5_y, e6_y, e7_y, e8_y, e9_y: out integer := 0;
		 e1_del, e2_del, e3_del, e4_del, e5_del, e6_del, e7_del, e8_del, e9_del: in std_logic
		);
	end component enemy_control;	
	
	
	begin
	-- Al tener un programa modular, se procede
	-- a definir los respectivos PORT MAP
	butdebo:
		Debounce_Switch port map (clock_50(0), mov(4), button_deb);
	
	syncromon: 
		-- Módulo de sincronización horzontal y vertical
		sync port map(vgaclk, vga_hs, vga_vs, switch, vga_r, vga_g, vga_b, mov, bullet_signal, shot_enable, shot_created, c_type, hposo, vposo , fig_x1o, fig_y1o, rgb_bullet, draw_bullet, button_deb, fairy_signal, rgb_fairy, draw_fairy, e_type, b1_del, b2_del, b3_del, b4_del, b5_del, b6_del, e1_x, e2_x, e3_x, e4_x, e5_x, e6_x, e7_x, e8_x, e9_x, e1_y, e2_y, e3_y, e4_y, e5_y, e6_y, e7_y, e8_y, e9_y, e1_del, e2_del, e3_del, e4_del, e5_del, e6_del, e7_del,e8_del, e9_del);
	clock: 
		-- Módulo de reloj 
		clockd port map(clock_50(0),vgaclk, reset);
	bullets:
		--Módilo de balas
		bullet_tracking port map(vgaclk, shot_enable, shot_created, hposo, vposo, fig_x1o, fig_y1o, rgb_bullet, draw_bullet, button_deb, bullet_signal, c_type, fire_led_o, b1_x, b2_x, b3_x, b4_x, b5_x, b6_x, b1_y, b2_y, b3_y, b4_y, b5_y, b6_y, b1_del, b2_del, b3_del, b4_del, b5_del, b6_del);
		--pseudorandom
	randomnumbergenerator:
		LFSR port map (vgaclk, enable_rng, seed, data_stream_in, data_stream_out, done_rng);
		--enemy controller
	greatfairy:
		enemy_control port map (vgaclk, hposo, vposo, rgb_fairy, draw_fairy, fairy_signal, e_type, b1_x, b2_x, b3_x, b4_x, b5_x, b6_x, b1_y, b2_y, b3_y, b4_y, b5_y, b6_y ,data_stream_out(0), b1_del, b2_del, b3_del, b4_del, b5_del, b6_del, e1_x, e2_x, e3_x, e4_x, e5_x, e6_x, e7_x, e8_x, e9_x, e1_y, e2_y, e3_y, e4_y, e5_y, e6_y, e7_y, e8_y, e9_y, e1_del, e2_del, e3_del, e4_del, e5_del, e6_del, e7_del, e8_del, e9_del);
	
end main;