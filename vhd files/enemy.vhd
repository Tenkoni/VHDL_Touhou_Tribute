-- ****************************************************
--                    Proyecto Final   
-- ****************************************************
-- Integrantes:
--   Garrido Lopez Luis Enrique
--   Miramonte Sarabia Luis Enrique
--   Ortiz Figueroa Maria Fernanda
-- ****************************************************

-- ****************************************************
--        Modulo para dibujar al los personajes
-- ****************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity enemy_control is
	port(
		-- Reloj de 25.175 MHz
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
		 e1_del, e2_del, e3_del, e4_del, e5_del, e6_del,e7_del, e8_del, e9_del: in std_logic
	);
end enemy_control;

architecture fairies of enemy_control is
	
	signal sprite_count1, sprite_count2, sprite_count3, sprite_count4, sprite_count5, sprite_count6, sprite_count7, sprite_count8, sprite_count9: integer:= 0; 
	signal fire_clock, shot_created_int, mov_signal, aux_mov, fairy_spawn: std_logic := '0';
	signal spawn_x: integer := 162;
	signal spawn_y: integer := 46;
	type rom_sprite is array (0 to 998) of std_logic_vector(11 downto 0);
	constant fairy : rom_sprite := (x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"667",x"888",x"878",x"999",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"767",x"889",x"AAB",x"A9B",x"A9A",x"AAA",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"BBB",x"999",x"AAA",x"CCD",x"DCD",x"CCD",x"DCD",x"EEE",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"EED",x"EEE",x"FFF",x"0F0",x"0F0",x"0F0",x"0F0",x"CCC",x"989",x"A9A",x"CBC",x"AAC",x"DDE",x"EDE",x"FEE",x"EDE",x"FFF",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"EED",x"EEE",x"FFF",x"FFF",x"FFF",x"0F0",x"0F0",x"EEE",x"989",x"888",x"AAA",x"BBC",x"77A",x"A9D",x"EDE",x"FFF",x"EEE",x"DDD",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"DEC",x"EFE",x"FFF",x"FFF",x"FFF",x"FFE",x"0F0",x"DDD",x"555",x"888",x"BBB",x"99B",x"77A",x"65C",x"BAC",x"EEE",x"DDE",x"BBC",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"EED",x"DEB",x"EED",x"FFF",x"EED",x"EEE",x"0F0",x"888",x"445",x"A9A",x"A9C",x"95C",x"CAD",x"87D",x"87B",x"BAC",x"BBC",x"999",x"EEE",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"EFD",x"EFD",x"DEB",x"CDA",x"CDB",x"0F0",x"0F0",x"989",x"556",x"989",x"335",x"637",x"FFF",x"EDE",x"326",x"435",x"A9A",x"889",x"EDE",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"FFF",x"BDB",x"5B7",x"0F0",x"0F0",x"0F0",x"777",x"666",x"001",x"434",x"FFF",x"FFE",x"337",x"001",x"667",x"999",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"294",x"7D9",x"0F0",x"0F0",x"778",x"333",x"113",x"97B",x"EDF",x"FFF",x"A9B",x"113",x"555",x"AAB",x"0F0",x"FFF",x"FFF",x"FFF",x"FFF",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"EEE",x"EEE",x"EEE",x"EEF",x"EEF",x"0F0",x"CED",x"295",x"ADC",x"8BA",x"375",x"112",x"112",x"448",x"77D",x"BAD",x"557",x"223",x"457",x"A8A",x"AAD",x"BBD",x"DCE",x"DDE",x"EEE",x"FFF",x"FFF",x"FFF",x"FFE",x"EEE",x"EEE",x"0F0",x"0F0",x"EDE",x"DDD",x"DDD",x"DDE",x"FFE",x"FFF",x"FFF",x"FFF",x"FFF",x"FEF",x"DCE",x"AAC",x"5B8",x"0A4",x"194",x"222",x"127",x"227",x"183",x"373",x"125",x"345",x"77B",x"78B",x"A9B",x"AAD",x"AAD",x"CBD",x"EDE",x"EEF",x"FFF",x"FFF",x"FFF",x"FEE",x"EEE",x"EDD",x"EDD",x"EDD",x"DCD",x"DDD",x"EEE",x"FFF",x"FFF",x"FFF",x"EEE",x"DCE",x"BAD",x"A9D",x"B9D",x"78E",x"574",x"0B4",x"253",x"527",x"97B",x"7EA",x"8DA",x"869",x"459",x"A9F",x"98E",x"77B",x"BAD",x"CCE",x"DCE",x"CCE",x"EEE",x"FFF",x"FFF",x"FFF",x"EEE",x"EED",x"EED",x"EEE",x"EEF",x"EDE",x"DDD",x"EEE",x"FEF",x"FFF",x"FFF",x"FFF",x"EDE",x"BBD",x"CBE",x"DBD",x"349",x"139",x"242",x"094",x"588",x"DBF",x"FFF",x"DDF",x"97A",x"236",x"98D",x"77E",x"46B",x"DDD",x"FFF",x"FFF",x"DDE",x"CCE",x"EEF",x"EEF",x"FFF",x"EEE",x"EEE",x"FFF",x"0F0",x"0F0",x"FFF",x"FFF",x"FFF",x"FFF",x"FFF",x"FFF",x"DDE",x"DCE",x"EDE",x"EEF",x"668",x"026",x"24B",x"223",x"052",x"194",x"598",x"789",x"769",x"445",x"112",x"335",x"56C",x"35C",x"569",x"BBC",x"FFF",x"DDE",x"AAD",x"DDE",x"EDF",x"FFF",x"FFF",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"FFF",x"FFF",x"FFF",x"FFF",x"EEF",x"FFF",x"0F0",x"015",x"338",x"485",x"0A4",x"094",x"264",x"153",x"163",x"143",x"222",x"212",x"112",x"348",x"35D",x"23A",x"236",x"AAC",x"FFF",x"FFF",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"238",x"96A",x"559",x"676",x"488",x"557",x"223",x"223",x"366",x"174",x"063",x"163",x"253",x"549",x"55C",x"239",x"558",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"569",x"77A",x"DCF",x"57D",x"758",x"669",x"679",x"557",x"98B",x"8BA",x"0B5",x"7DA",x"6A9",x"286",x"386",x"495",x"484",x"495",x"5C8",x"6C8",x"9EB",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"015",x"446",x"EDE",x"BAB",x"668",x"99C",x"AAC",x"98B",x"EDF",x"BEC",x"8DA",x"FEF",x"CBD",x"BAC",x"889",x"249",x"44A",x"55B",x"886",x"6C8",x"4B7",x"2B5",x"8DA",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"68B",x"114",x"015",x"548",x"88A",x"99B",x"DDE",x"DDE",x"DCE",x"FFF",x"EFF",x"EFF",x"DDE",x"BBD",x"CCE",x"EDE",x"56D",x"24E",x"25F",x"89F",x"0F0",x"0F0",x"0F0",x"AEC",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"349",x"127",x"24A",x"97A",x"99C",x"EEE",x"FFF",x"FFF",x"FFF",x"FFF",x"FFF",x"FFF",x"EEF",x"CCE",x"CBE",x"EFF",x"BCF",x"46E",x"46E",x"67E",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"78B",x"12A",x"24A",x"96B",x"BBD",x"EEF",x"FFF",x"DCE",x"EEF",x"FFF",x"FFF",x"FFF",x"FFF",x"DCD",x"76B",x"67C",x"67D",x"77F",x"98F",x"88E",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"56C",x"13A",x"23A",x"35B",x"66B",x"CAC",x"ABE",x"EEF",x"FFF",x"FFF",x"FFF",x"FFF",x"68D",x"13B",x"24C",x"56E",x"98F",x"88F",x"DDD",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"23B",x"13A",x"13B",x"13C",x"35C",x"AAD",x"DDF",x"AAF",x"BBF",x"DDF",x"CCF",x"35E",x"24D",x"24E",x"66E",x"88E",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"89D",x"45D",x"45D",x"45E",x"66F",x"98F",x"98F",x"88F",x"88F",x"98F",x"67E",x"24E",x"14E",x"24E",x"78E",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"9AD",x"99E",x"98F",x"88F",x"88F",x"88F",x"88F",x"66E",x"24E",x"24E",x"46D",x"89E",x"DCD",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"CCE",x"BBE",x"BBD",x"BBE",x"BAE",x"89E",x"89D",x"CCE",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0");

	
begin
	process(clk)
	variable cuenta_mov: integer := 0;
	begin
		if rising_edge(clk) then
			if (cuenta_mov = 125115) then
				cuenta_mov := 0;
				mov_signal <= '1';
			else
				cuenta_mov := cuenta_mov + 1;
				mov_signal <= '0';
			end if;
		end if;
	end process;
	
	process(spawn_x)
	begin
		if(spawn_x = 161) then	
			aux_mov <= '0';
		elsif(spawn_x = 665) then
			aux_mov <= '1';
		end if;
	end process;
		
	process(mov_signal)
	begin
		if(mov_signal='1') then
			if(aux_mov = '0') then
				spawn_x <= spawn_x + 1;
			else
				spawn_x <= spawn_x - 1;
			end if;
		end if;
	end process;
	
	process (clk)
	begin
		if rising_edge(clk) then
			if (fairy_spawn = '1') then --  condición con random = 1 y una distancia de 37 contra el spawn anterior
				if(e1_x = 0) then
					e1_x <= spawn_x;
					e1_y <= spawn_y + 5;
					--fairy_created_int <= '1';
				elsif(e2_x = 0) then
					e2_x <= spawn_x;
					e2_y <= spawn_y + 5;
					--fairy_created_int <= '1';
				elsif(e3_x = 0) then
					e3_x <= spawn_x;
					e3_y <= spawn_y + 5;
					--fairy_created_int <= '1';
				elsif(e4_x = 0) then
					e4_x <= spawn_x;
					e4_y <= spawn_y + 5;
					--fairy_created_int <= '1';
				elsif(e5_x = 0) then
					e5_x <= spawn_x;
					e5_y <= spawn_y + 5;
					--fairy_created_int <= '1';
				elsif(e6_x = 0) then
					e6_x <= spawn_x;
					e6_y <= spawn_y + 5;
					--fairy_created_int <= '1';
				elsif(e7_x = 0) then
					e7_x <= spawn_x;
					e7_y <= spawn_y + 5;
					--fairy_created_int <= '1';
				elsif(e8_x = 0) then
					e8_x <= spawn_x;
					e8_y <= spawn_y + 5;
					--fairy_created_int <= '1';
				elsif(e9_x = 0) then
					e9_x <= spawn_x;
					e9_y <= spawn_y + 5;
					--fairy_created_int <= '1';
--				else
--					fairy_created_int <= '0';
				end if;
--			else
--				fairy_created_int <= '0';
			end if;
				
			if (fairy_signal = '1') then
			
				if(e1_x /= 0) then
					if( (e1_y + 6 ) > 495) then
						e1_x <= 0;
						e1_y <= 0;
						sprite_count1 <= 0;
					else
						e1_y <= e1_y + 6;
					end if;
				end if;
				
				if(e2_x /= 0) then
					if( (e2_y + 6 ) > 495) then
						e2_x <= 0;
						e2_y <= 0;
						sprite_count2 <= 0;
					else
						e2_y <= e2_y + 6;
					end if;
				end if;
				
				if(e3_x /= 0) then
					if( (e3_y + 6) > 495) then
						e3_x <= 0;
						e3_y <= 0;
						sprite_count3 <= 0;
					else
						e3_y <= e3_y + 6;
					end if;
				end if;
				
				if(e4_x /= 0) then
					if( (e4_y + 6 ) > 495) then
						e4_x <= 0;
						e4_y <= 0;
						sprite_count4 <= 0;
					else
						e4_y <= e4_y + 6;
					end if;
				end if;
				
				if(e5_x /= 0) then
					if( (e5_y + 6 ) > 495) then
						e5_x <= 0;
						e5_y <= 0;
						sprite_count5 <= 0;
					else
						e5_y <= e5_y + 6;
					end if;
				end if;
				
				if(e6_x /= 0) then
					if( (e6_y + 6) > 495) then
						e6_x <= 0;
						e6_y <= 0;
						sprite_count6 <= 0;
					else
						e6_y <= e6_y + 6;
					end if;
				end if;
				
				if(e7_x /= 0) then
					if( (e6_y + 6) > 495) then
						e7_x <= 0;
						e7_y <= 0;
						sprite_count7 <= 0;
					else
						e7_y <= e7_y + 6;
					end if;
				end if;
				
				if(e8_x /= 0) then
					if( (e8_y + 6) > 495) then
						e8_x <= 0;
						e8_y <= 0;
						sprite_count8 <= 0;
					else
						e8_y <= e8_y + 6;
					end if;
				end if;
				
				if(e9_x /= 0) then
					if( (e9_y + 6 ) > 495) then
						e9_x <= 0;
						e9_y <= 0;
						sprite_count9 <= 0;
					else
						e9_y <= e9_y + 6;
					end if;
				end if;
				
			end if;
			
			if(xcur>e1_x and xcur<=e1_x+37 and ycur>e1_y and ycur<=e1_y+27 and e1_x /= 0 and e1_y /= 0) then
				draw <= '1';
				if (sprite_count1 < 999) then
					if (fairy(sprite_count1) /= x"0F0") then
						rgb<= fairy(sprite_count1); 
						e_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						e_type <= "10";
					end if;
					
					if (sprite_count1 = 998) then
						sprite_count1 <= 0;
					else
						sprite_count1 <= sprite_count1 + 1;
					end if;
					
				end if;
				
				elsif(xcur>e2_x and xcur<=e2_x+37 and ycur>e2_y and ycur<=e2_y+27 and e2_x /= 0 and e2_y /= 0) then
				draw <= '1';
				if (sprite_count2 < 999) then
					if (fairy(sprite_count2) /= x"0F0") then
						rgb<= fairy(sprite_count2); 
						e_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						e_type <= "10";
					end if;
					
					if (sprite_count2 = 998) then
						sprite_count2 <= 0;
					else
						sprite_count2 <= sprite_count2 + 1;
					end if;
					
				end if;									
			elsif(xcur>e3_x and xcur<=e3_x+37 and ycur>e3_y and ycur<=e3_y+27 and e3_x /= 0 and e3_y /= 0) then
				draw <= '1';
				if (sprite_count3 < 999) then
					if (fairy(sprite_count3) /= x"0F0") then
						rgb<= fairy(sprite_count3); 
						e_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						e_type <= "10";
					end if;
					
					if (sprite_count3 = 998) then
						sprite_count3 <= 0;
					else
						sprite_count3 <= sprite_count3 + 1;
					end if;
					
				end if;					
				
			elsif(xcur>e4_x and xcur<=e4_x+37 and ycur>e4_y and ycur<=e4_y+27 and e4_x /= 0 and e4_y /= 0) then
				draw <= '1';
				if (sprite_count4 < 999) then
					if (fairy(sprite_count4) /= x"0F0") then
						rgb<= fairy(sprite_count4); 
						e_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						e_type <= "10";
					end if;
					
					if (sprite_count4 = 998) then
						sprite_count4 <= 0;
					else
						sprite_count4 <= sprite_count4 + 1;
					end if;
					
				end if;				
				
			elsif(xcur>e5_x and xcur<=e5_x+37 and ycur>e5_y and ycur<=e5_y+27  and e5_x /= 0 and e5_y /= 0) then
				draw <= '1';
				if (sprite_count5 < 999) then
					if (fairy(sprite_count5) /= x"0F0") then
						rgb<= fairy(sprite_count5); 
						e_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						e_type <= "10";
					end if;	
					
					if (sprite_count5 = 998) then
						sprite_count5 <= 0;
					else
						sprite_count5 <= sprite_count5 + 1;
					end if;
					
				end if;	
				
			elsif(xcur>e6_x and xcur<=e6_x+37 and ycur>e6_y and ycur<=e6_y+27 and e6_x /= 0 and e6_y /= 0) then
				draw <= '1';
				if (sprite_count6 < 999) then
					if (fairy(sprite_count6) /= x"0F0") then
						rgb<= fairy(sprite_count6); 
						e_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						e_type <= "10";
					end if;
					
					if (sprite_count6 = 998) then
						sprite_count6 <= 0;
					else
						sprite_count6 <= sprite_count6 + 1;
					end if;
				end if;
				
			elsif(xcur>e7_x and xcur<=e7_x+37 and ycur>e7_y and ycur<=e7_y+27 and e7_x /= 0 and e7_y /= 0) then
				draw <= '1';
				if (sprite_count7 < 999) then
					if (fairy(sprite_count7) /= x"0F0") then
						rgb<= fairy(sprite_count7); 
						e_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						e_type <= "10";
					end if;
					
					if (sprite_count7 = 998) then
						sprite_count7 <= 0;
					else
						sprite_count7 <= sprite_count7 + 1;
					end if;
				end if;	
				
			elsif(xcur>e8_x and xcur<=e8_x+37 and ycur>e8_y and ycur<=e8_y+27 and e8_x /= 0 and e8_y /= 0) then
				draw <= '1';
				if (sprite_count8 < 999) then
					if (fairy(sprite_count8) /= x"0F0") then
						rgb<= fairy(sprite_count8); 
						e_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						e_type <= "10";
					end if;
					
					if (sprite_count8 = 998) then
						sprite_count8 <= 0;
					else
						sprite_count8 <= sprite_count8 + 1;
					end if;
				end if;	
				
			elsif(xcur>e9_x and xcur<=e9_x+37 and ycur>e9_y and ycur<=e9_y+27 and e9_x /= 0 and e9_y /= 0) then
				draw <= '1';
				if (sprite_count9 < 999) then
					if (fairy(sprite_count9) /= x"0F0") then
						rgb<= fairy(sprite_count9); 
						e_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						e_type <= "10";
					end if;
					
					if (sprite_count9 = 998) then
						sprite_count9 <= 0;
					else
						sprite_count9 <= sprite_count9 + 1;
					end if;
				end if;	
			else
				draw <= '0';
			end if;
			
			
			if(((b1_x > e1_x and b1_x <= e1_x+37) or (b1_x+15 > e1_x and b1_x+15 <= e1_x+37)) and (b1_y > e1_y and b1_y <= e1_y+27) and b1_x /= 0) then
				e1_x <= 0;
				e1_y <= 0;
				b1_del <= '1';
				sprite_count1 <= 0;

			elsif(((b1_x > e2_x and b1_x <= e2_x+37) or (b1_x+15 > e2_x and b1_x+15 <= e2_x+37)) and (b1_y > e2_y and b1_y <= e2_y+27) and b1_x /= 0) then
				e2_x <= 0;
				e2_y <= 0;
				b1_del <= '1';
				sprite_count2 <= 0;

			elsif(((b1_x > e3_x and b1_x <= e3_x+37) or (b1_x+15 > e3_x and b1_x+15 <= e3_x+37)) and (b1_y > e3_y and b1_y <= e3_y+27) and b1_x /= 0) then
				e3_x <= 0;
				e3_y <= 0;
				b1_del <= '1';
				sprite_count3 <= 0;

			elsif(((b1_x > e4_x and b1_x <= e4_x+37) or (b1_x+15 > e4_x and b1_x+15 <= e4_x+37)) and (b1_y > e4_y and b1_y <= e4_y+27) and b1_x /= 0) then
				e4_x <= 0;
				e4_y <= 0;
				b1_del <= '1';
				sprite_count4 <= 0;

			elsif(((b1_x > e5_x and b1_x <= e5_x+37) or (b1_x+15 > e5_x and b1_x+15 <= e5_x+37)) and (b1_y > e5_y and b1_y <= e5_y+27) and b1_x /= 0) then
				e5_x <= 0;
				e5_y <= 0;
				b1_del <= '1';
				sprite_count5 <= 0;

			elsif(((b1_x > e6_x and b1_x <= e6_x+37) or (b1_x+15 > e6_x and b1_x+15 <= e6_x+37)) and (b1_y > e6_y and b1_y <= e6_y+27) and b1_x /= 0) then
				e6_x <= 0;
				e6_y <= 0;
				b1_del <= '1';
				sprite_count6 <= 0;

			elsif(((b1_x > e7_x and b1_x <= e7_x+37) or (b1_x+15 > e7_x and b1_x+15 <= e7_x+37)) and (b1_y > e7_y and b1_y <= e7_y+27) and b1_x /= 0) then
				e7_x <= 0;
				e7_y <= 0;
				b1_del <= '1';
				sprite_count7 <= 0;

			elsif(((b1_x > e8_x and b1_x <= e8_x+37) or (b1_x+15 > e8_x and b1_x+15 <= e8_x+37)) and (b1_y > e8_y and b1_y <= e8_y+27) and b1_x /= 0) then
				e8_x <= 0;
				e8_y <= 0;
				b1_del <= '1';
				sprite_count8 <= 0;

			elsif(((b1_x > e9_x and b1_x <= e9_x+37) or (b1_x+15 > e9_x and b1_x+15 <= e9_x+37)) and (b1_y > e9_y and b1_y <= e9_y+27) and b1_x /= 0) then
				e9_x <= 0;
				e9_y <= 0;
				b1_del <= '1';
				sprite_count9 <= 0;
			else
				b1_del <= '0';
			end if;

			
			if(((b2_x > e1_x and b2_x <= e1_x+37) or (b2_x+15 > e1_x and b2_x+15 <= e1_x+37)) and (b2_y > e1_y and b2_y <= e1_y+27) and b2_x /= 0) then
				e1_x <= 0;
				e1_y <= 0;
				b2_del <= '1';
				sprite_count1 <= 0;

			elsif(((b2_x > e2_x and b2_x <= e2_x+37) or (b2_x+15 > e2_x and b2_x+15 <= e2_x+37)) and (b2_y > e2_y and b2_y <= e2_y+27) and b2_x /= 0) then
				e2_x <= 0;
				e2_y <= 0;
				b2_del <= '1';
				sprite_count2 <= 0;

			elsif(((b2_x > e3_x and b2_x <= e3_x+37) or (b2_x+15 > e3_x and b2_x+15 <= e3_x+37)) and (b2_y > e3_y and b2_y <= e3_y+27) and b2_x /= 0) then
				e3_x <= 0;
				e3_y <= 0;
				b2_del <= '1';
				sprite_count3 <= 0;

			elsif(((b2_x > e4_x and b2_x <= e4_x+37) or (b2_x+15 > e4_x and b2_x+15 <= e4_x+37)) and (b2_y > e4_y and b2_y <= e4_y+27) and b2_x /= 0) then
				e4_x <= 0;
				e4_y <= 0;
				b2_del <= '1';
				sprite_count4 <= 0;

			elsif(((b2_x > e5_x and b2_x <= e5_x+37) or (b2_x+15 > e5_x and b2_x+15 <= e5_x+37)) and (b2_y > e5_y and b2_y <= e5_y+27) and b2_x /= 0) then
				e5_x <= 0;
				e5_y <= 0;
				b2_del <= '1';
				sprite_count5 <= 0;

			elsif(((b2_x > e6_x and b2_x <= e6_x+37) or (b2_x+15 > e6_x and b2_x+15 <= e6_x+37)) and (b2_y > e6_y and b2_y <= e6_y+27) and b2_x /= 0) then
				e6_x <= 0;
				e6_y <= 0;
				b2_del <= '1';
				sprite_count6 <= 0;

			elsif(((b2_x > e7_x and b2_x <= e7_x+37) or (b2_x+15 > e7_x and b2_x+15 <= e7_x+37)) and (b2_y > e7_y and b2_y <= e7_y+27) and b2_x /= 0) then
				e7_x <= 0;
				e7_y <= 0;
				b2_del <= '1';
				sprite_count7 <= 0;

			elsif(((b2_x > e8_x and b2_x <= e8_x+37) or (b2_x+15 > e8_x and b2_x+15 <= e8_x+37)) and (b2_y > e8_y and b2_y <= e8_y+27) and b2_x /= 0) then
				e8_x <= 0;
				e8_y <= 0;
				b2_del <= '1';
				sprite_count8 <= 0;
	
			elsif(((b2_x > e9_x and b2_x <= e9_x+37) or (b2_x+15 > e9_x and b2_x+15 <= e9_x+37)) and (b2_y > e9_y and b2_y <= e9_y+27) and b2_x /= 0) then
				e9_x <= 0;
				e9_y <= 0;
				b2_del <= '1';
				sprite_count9 <= 0;
			else
				b2_del <= '0';
			end if;
			

			if(((b3_x > e1_x and b3_x <= e1_x+37) or (b3_x+15 > e1_x and b3_x+15 <= e1_x+37)) and (b3_y > e1_y and b3_y <= e1_y+27) and b3_x /= 0) then
				e1_x <= 0;
				e1_y <= 0;
				b3_del <= '1';
				sprite_count1 <= 0;

			elsif(((b3_x > e2_x and b3_x <= e2_x+37) or (b3_x+15 > e2_x and b3_x+15 <= e2_x+37)) and (b3_y > e2_y and b3_y <= e2_y+27) and b3_x /= 0) then
				e2_x <= 0;
				e2_y <= 0;
				b3_del <= '1';
				sprite_count2 <= 0;

			elsif(((b3_x > e3_x and b3_x <= e3_x+37) or (b3_x+15 > e3_x and b3_x+15 <= e3_x+37)) and (b3_y > e3_y and b3_y <= e3_y+27) and b3_x /= 0) then
				e3_x <= 0;
				e3_y <= 0;
				b3_del <= '1';
				sprite_count3 <= 0;

			elsif(((b3_x > e4_x and b3_x <= e4_x+37) or (b3_x+15 > e4_x and b3_x+15 <= e4_x+37)) and (b3_y > e4_y and b3_y <= e4_y+27) and b3_x /= 0) then
				e4_x <= 0;
				e4_y <= 0;
				b3_del <= '1';
				sprite_count4 <= 0;

			elsif(((b3_x > e5_x and b3_x <= e5_x+37) or (b3_x+15 > e5_x and b3_x+15 <= e5_x+37)) and (b3_y > e5_y and b3_y <= e5_y+27) and b3_x /= 0) then
				e5_x <= 0;
				e5_y <= 0;
				b3_del <= '1';
				sprite_count5 <= 0;

			elsif(((b3_x > e6_x and b3_x <= e6_x+37) or (b3_x+15 > e6_x and b3_x+15 <= e6_x+37)) and (b3_y > e6_y and b3_y <= e6_y+27) and b3_x /= 0) then
				e6_x <= 0;
				e6_y <= 0;
				b3_del <= '1';
				sprite_count6 <= 0;

			elsif(((b3_x > e7_x and b3_x <= e7_x+37) or (b3_x+15 > e7_x and b3_x+15 <= e7_x+37)) and (b3_y > e7_y and b3_y <= e7_y+27) and b3_x /= 0) then
				e7_x <= 0;
				e7_y <= 0;
				b3_del <= '1';
				sprite_count7 <= 0;

			elsif(((b3_x > e8_x and b3_x <= e8_x+37) or (b3_x+15 > e8_x and b3_x+15 <= e8_x+37)) and (b3_y > e8_y and b3_y <= e8_y+27) and b3_x /= 0) then
				e8_x <= 0;
				e8_y <= 0;
				b3_del <= '1';
				sprite_count8 <= 0;
	
			elsif(((b3_x > e9_x and b3_x <= e9_x+37) or (b3_x+15 > e9_x and b3_x+15 <= e9_x+37)) and (b3_y > e9_y and b3_y <= e9_y+27) and b3_x /= 0) then
				e9_x <= 0;
				e9_y <= 0;
				b3_del <= '1';
				sprite_count9 <= 0;
			else
				b3_del <= '0';
			end if;

			if(((b4_x > e1_x and b4_x <= e1_x+37) or (b4_x+15 > e1_x and b4_x+15 <= e1_x+37)) and (b4_y > e1_y and b4_y <= e1_y+27) and b4_x /= 0) then
				e1_x <= 0;
				e1_y <= 0;
				b4_del <= '1';
				sprite_count1 <= 0;

			elsif(((b4_x > e2_x and b4_x <= e2_x+37) or (b4_x+15 > e2_x and b4_x+15 <= e2_x+37)) and (b4_y > e2_y and b4_y <= e2_y+27) and b4_x /= 0) then
				e2_x <= 0;
				e2_y <= 0;
				b4_del <= '1';
				sprite_count2 <= 0;

			elsif(((b4_x > e3_x and b4_x <= e3_x+37) or (b4_x+15 > e3_x and b4_x+15 <= e3_x+37)) and (b4_y > e3_y and b4_y <= e3_y+27) and b4_x /= 0) then
				e3_x <= 0;
				e3_y <= 0;
				b4_del <= '1';
				sprite_count3 <= 0;

			elsif(((b4_x > e4_x and b4_x <= e4_x+37) or (b4_x+15 > e4_x and b4_x+15 <= e4_x+37)) and (b4_y > e4_y and b4_y <= e4_y+27) and b4_x /= 0) then
				e4_x <= 0;
				e4_y <= 0;
				b4_del <= '1';
				sprite_count4 <= 0;

			elsif(((b4_x > e5_x and b4_x <= e5_x+37) or (b4_x+15 > e5_x and b4_x+15 <= e5_x+37)) and (b4_y > e5_y and b4_y <= e5_y+27) and b4_x /= 0) then
				e5_x <= 0;
				e5_y <= 0;
				b4_del <= '1';
				sprite_count5 <= 0;

			elsif(((b4_x > e6_x and b4_x <= e6_x+37) or (b4_x+15 > e6_x and b4_x+15 <= e6_x+37)) and (b4_y > e6_y and b4_y <= e6_y+27) and b4_x /= 0) then
				e6_x <= 0;
				e6_y <= 0;
				b4_del <= '1';
				sprite_count6 <= 0;

			elsif(((b4_x > e7_x and b4_x <= e7_x+37) or (b4_x+15 > e7_x and b4_x+15 <= e7_x+37)) and (b4_y > e7_y and b4_y <= e7_y+27) and b4_x /= 0) then
				e7_x <= 0;
				e7_y <= 0;
				b4_del <= '1';
				sprite_count7 <= 0;

			elsif(((b4_x > e8_x and b4_x <= e8_x+37) or (b4_x+15 > e8_x and b4_x+15 <= e8_x+37)) and (b4_y > e8_y and b4_y <= e8_y+27) and b4_x /= 0) then
				e8_x <= 0;
				e8_y <= 0;
				b4_del <= '1';
				sprite_count8 <= 0;

			elsif(((b4_x > e9_x and b4_x <= e9_x+37) or (b4_x+15 > e9_x and b4_x+15 <= e9_x+37)) and (b4_y > e9_y and b4_y <= e9_y+27) and b4_x /= 0) then
				e9_x <= 0;
				e9_y <= 0;
				b4_del <= '1';
				sprite_count9 <= 0;
			else
				b4_del <= '0';
			end if;

			if(((b5_x > e1_x and b5_x <= e1_x+37) or (b5_x+15 > e1_x and b5_x+15 <= e1_x+37)) and (b5_y > e1_y and b5_y <= e1_y+27) and b5_x /= 0) then
				e1_x <= 0;
				e1_y <= 0;
				b5_del <= '1';
				sprite_count1 <= 0;

			elsif(((b5_x > e2_x and b5_x <= e2_x+37) or (b5_x+15 > e2_x and b5_x+15 <= e2_x+37)) and (b5_y > e2_y and b5_y <= e2_y+27) and b5_x /= 0) then
				e2_x <= 0;
				e2_y <= 0;
				b5_del <= '1';
				sprite_count2 <= 0;

			elsif(((b5_x > e3_x and b5_x <= e3_x+37) or (b5_x+15 > e3_x and b5_x+15 <= e3_x+37)) and (b5_y > e3_y and b5_y <= e3_y+27) and b5_x /= 0) then
				e3_x <= 0;
				e3_y <= 0;
				b5_del <= '1';
				sprite_count3 <= 0;

			elsif(((b5_x > e4_x and b5_x <= e4_x+37) or (b5_x+15 > e4_x and b5_x+15 <= e4_x+37)) and (b5_y > e4_y and b5_y <= e4_y+27) and b5_x /= 0) then
				e4_x <= 0;
				e4_y <= 0;
				b5_del <= '1';
				sprite_count4 <= 0;

			elsif(((b5_x > e5_x and b5_x <= e5_x+37) or (b5_x+15 > e5_x and b5_x+15 <= e5_x+37)) and (b5_y > e5_y and b5_y <= e5_y+27) and b5_x /= 0) then
				e5_x <= 0;
				e5_y <= 0;
				b5_del <= '1';
				sprite_count5 <= 0;

			elsif(((b5_x > e6_x and b5_x <= e6_x+37) or (b5_x+15 > e6_x and b5_x+15 <= e6_x+37)) and (b5_y > e6_y and b5_y <= e6_y+27) and b5_x /= 0) then
				e6_x <= 0;
				e6_y <= 0;
				b5_del <= '1';
				sprite_count6 <= 0;

			elsif(((b5_x > e7_x and b5_x <= e7_x+37) or (b5_x+15 > e7_x and b5_x+15 <= e7_x+37)) and (b5_y > e7_y and b5_y <= e7_y+27) and b5_x /= 0) then
				e7_x <= 0;
				e7_y <= 0;
				b5_del <= '1';
				sprite_count7 <= 0;

			elsif(((b5_x > e8_x and b5_x <= e8_x+37) or (b5_x+15 > e8_x and b5_x+15 <= e8_x+37)) and (b5_y > e8_y and b5_y <= e8_y+27) and b5_x /= 0) then
				e8_x <= 0;
				e8_y <= 0;
				b5_del <= '1';
				sprite_count8 <= 0;
	
			elsif(((b5_x > e9_x and b5_x <= e9_x+37) or (b5_x+15 > e9_x and b5_x+15 <= e9_x+37)) and (b5_y > e9_y and b5_y <= e9_y+27) and b5_x /= 0) then
				e9_x <= 0;
				e9_y <= 0;
				b5_del <= '1';
				sprite_count9 <= 0;
			else
				b5_del <= '0';
			end if;

			if(((b6_x > e1_x and b6_x <= e1_x+37) or (b6_x+15 > e1_x and b6_x+15 <= e1_x+37)) and (b6_y > e1_y and b6_y <= e1_y+27) and b6_x /= 0) then
				e1_x <= 0;
				e1_y <= 0;
				b6_del <= '1';
				sprite_count1 <= 0;

			elsif(((b6_x > e2_x and b6_x <= e2_x+37) or (b6_x+15 > e2_x and b6_x+15 <= e2_x+37)) and (b6_y > e2_y and b6_y <= e2_y+27) and b6_x /= 0) then
				e2_x <= 0;
				e2_y <= 0;
				b6_del <= '1';
				sprite_count2 <= 0;

			elsif(((b6_x > e3_x and b6_x <= e3_x+37) or (b6_x+15 > e3_x and b6_x+15 <= e3_x+37)) and (b6_y > e3_y and b6_y <= e3_y+27) and b6_x /= 0) then
				e3_x <= 0;
				e3_y <= 0;
				b6_del <= '1';
				sprite_count3 <= 0;

			elsif(((b6_x > e4_x and b6_x <= e4_x+37) or (b6_x+15 > e4_x and b6_x+15 <= e4_x+37)) and (b6_y > e4_y and b6_y <= e4_y+27) and b6_x /= 0) then
				e4_x <= 0;
				e4_y <= 0;
				b6_del <= '1';
				sprite_count4 <= 0;

			elsif(((b6_x > e5_x and b6_x <= e5_x+37) or (b6_x+15 > e5_x and b6_x+15 <= e5_x+37)) and (b6_y > e5_y and b6_y <= e5_y+27) and b6_x /= 0) then
				e5_x <= 0;
				e5_y <= 0;
				b6_del <= '1';
				sprite_count5 <= 0;

			elsif(((b6_x > e6_x and b6_x <= e6_x+37) or (b6_x+15 > e6_x and b6_x+15 <= e6_x+37)) and (b6_y > e6_y and b6_y <= e6_y+27) and b6_x /= 0) then
				e6_x <= 0;
				e6_y <= 0;
				b6_del <= '1';
				sprite_count6 <= 0;

			elsif(((b6_x > e7_x and b6_x <= e7_x+37) or (b6_x+15 > e7_x and b6_x+15 <= e7_x+37)) and (b6_y > e7_y and b6_y <= e7_y+27) and b6_x /= 0) then
				e7_x <= 0;
				e7_y <= 0;
				b6_del <= '1';
				sprite_count7 <= 0;

			elsif(((b6_x > e8_x and b6_x <= e8_x+37) or (b6_x+15 > e8_x and b6_x+15 <= e8_x+37)) and (b6_y > e8_y and b6_y <= e8_y+27) and b6_x /= 0) then
				e8_x <= 0;
				e8_y <= 0;
				b6_del <= '1';
				sprite_count8 <= 0;
	
			elsif(((b6_x > e9_x and b6_x <= e9_x+37) or (b6_x+15 > e9_x and b6_x+15 <= e9_x+37)) and (b6_y > e9_y and b6_y <= e9_y+27) and b6_x /= 0) then
				e9_x <= 0;
				e9_y <= 0;
				b6_del <= '1';
				sprite_count9 <= 0;
			else
				b6_del <= '0';
			end if;

			
			if (e1_del) then
				e1_x <= 0;
				e1_y <= 0;
				sprite_count1 <= 0;
			end if;
			if (e2_del) then
				 e2_x <= 0;
				 e2_y <= 0;
				 sprite_count2 <= 0;
			end if;
			if (e3_del) then
				 e3_x <= 0;
				 e3_y <= 0;
				 sprite_count3 <= 0;
			end if;
			if (e4_del) then
				 e4_x <= 0;
				 e4_y <= 0;
				 sprite_count4 <= 0;
			end if;
			if (e5_del) then
				 e5_x <= 0;
				 e5_y <= 0;
				 sprite_count5 <= 0;
			end if;
			if (e6_del) then
				 e6_x <= 0;
				 e6_y <= 0;
				 sprite_count6 <= 0;
			end if;
			if (e7_del) then
				 e7_x <= 0;
				 e7_y <= 0;
				 sprite_count7 <= 0;
			end if;
			if (e8_del) then
				 e8_x <= 0;
			 	 e8_y <= 0;
				 sprite_count8 <= 0;
			end if;
			if (e9_del) then
				 e9_x <= 0;
				 e9_y <= 0;
				 sprite_count9 <= 0;
			end if;
			
			
			
			
		end if;
	end process;
	
	fairydistance: process(clk)
	variable distance: integer:=0;
	begin
		if rising_edge(clk) then
			if (distance < 5004600) then
				distance:=distance+1;
				fairy_spawn <= '0';
			elsif (distance = 5004600) then 
				fairy_spawn <= '1';
				distance:=distance + 1;
			elsif (distance > 38) then
					--fairy_spawn <= '1';
					--if (random_bit = '1') then
				distance :=0;
				fairy_spawn <= '0';
				--	end if;
				end if;
		end if;
	end process;
	
end fairies;
