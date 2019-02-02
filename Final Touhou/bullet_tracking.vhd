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

entity bullet_tracking is
	port(
		-- Reloj de 25.175 MHz
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
end bullet_tracking;

architecture main of bullet_tracking is
	
	--signal b1_x, b2_x, b3_x, b4_x, b5_x, b6_x: integer := 0;
	--signal b1_y, b2_y, b3_y, b4_y, b5_y, b6_y: integer := 0;
	signal sprite_count1, sprite_count2, sprite_count3, sprite_count4, sprite_count5, sprite_count6: integer:= 0; 
	signal fire_clock, shot_created_int: std_logic := '0';
	type rom_sprite is array (0 to 239) of std_logic_vector(11 downto 0);
	constant star_bullet : rom_sprite := (x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"CCA",x"CCA",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"BB9",x"322",x"774",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"BB8",x"320",x"650",x"773",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"885",x"542",x"452",x"996",x"BB8",x"320",x"770",x"EE6",x"FF2",x"551",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"996",x"320",x"981",x"991",x"991",x"FE3",x"FEC",x"FFE",x"FE8",x"650",x"CDB",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"551",x"EC1",x"FFD",x"FFE",x"FFE",x"FFE",x"FFF",x"FFD",x"AA0",x"873",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"885",x"871",x"FFB",x"FFF",x"FFE",x"FFE",x"FFF",x"FFF",x"FE9",x"871",x"551",x"AA7",x"0F0",x"0F0",x"0F0",x"0F0",x"440",x"FE9",x"FFF",x"FFF",x"FFF",x"FFF",x"FFF",x"FFF",x"FFB",x"EE1",x"330",x"542",x"BB9",x"0F0",x"0F0",x"440",x"FFB",x"FFF",x"FFF",x"FFF",x"FFF",x"FFF",x"EED",x"FE8",x"EC1",x"330",x"431",x"BB8",x"0F0",x"996",x"871",x"FFD",x"FFF",x"FFF",x"FFF",x"FFF",x"FFE",x"FE4",x"981",x"551",x"A97",x"0F0",x"0F0",x"0F0",x"441",x"ED2",x"FFE",x"FFE",x"FFF",x"FFE",x"FFE",x"FFB",x"871",x"774",x"0F0",x"0F0",x"0F0",x"0F0",x"996",x"320",x"761",x"991",x"871",x"AA0",x"FE4",x"FFB",x"EE6",x"661",x"CDB",x"0F0",x"0F0",x"0F0",x"0F0",x"996",x"542",x"774",x"885",x"AA7",x"995",x"440",x"EC1",x"ED2",x"551",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"BB8",x"440",x"560",x"221",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"BB8",x"322",x"774",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0",x"BB9",x"CCA",x"0F0",x"0F0",x"0F0",x"0F0",x"0F0");

begin
	
	process (clk)
	begin
		if rising_edge(clk) then
			if (button = '1' and fire_clock = '1') then --  and fire_clock = '1')
				if(b1_x = 0) then
					b1_x <= xpos_player + 5;
					b1_y <= ypos_player - 21;
					shot_created_int <= '1';
				elsif(b2_x = 0) then
					b2_x <= xpos_player + 5;
					b2_y <= ypos_player - 21;
					shot_created_int <= '1';
				elsif(b3_x = 0) then
					b3_x <= xpos_player + 5;
					b3_y <= ypos_player - 21;
					shot_created_int <= '1';
				elsif(b4_x = 0) then
					b4_x <= xpos_player + 5;
					b4_y <= ypos_player - 21;
					shot_created_int <= '1';
				elsif(b5_x = 0) then
					b5_x <= xpos_player + 5;
					b5_y <= ypos_player - 21;
					shot_created_int <= '1';
				elsif(b6_x = 0) then
					b6_x <= xpos_player + 5;
					b6_y <= ypos_player - 21;
					shot_created_int <= '1';
				else
				shot_created_int <= '0';
				end if;
			else
				shot_created_int <= '0';
			end if;
			if (bullet_signal = '1') then
			
				if(b1_x /= 0) then
					if( (b1_y - 7) < 60) then
						b1_x <= 0;
						b1_y <= 0;
						sprite_count1 <= 0;
					elsif(b1_del /= '1') then
						b1_y <= b1_y - 7;
					end if;
				end if;
				
				if(b2_x /= 0) then
					if( (b2_y - 7) < 60) then
						b2_x <= 0;
						b2_y <= 0;
						sprite_count2 <= 0;
					elsif(b2_del /= '1') then
						b2_y <= b2_y - 7;
					end if;
				end if;
				
				if(b3_x /= 0) then
					if( (b3_y - 7) < 60) then
						b3_x <= 0;
						b3_y <= 0;
						sprite_count3 <= 0;
					elsif(b3_del /= '1') then
						b3_y <= b3_y - 7;
					end if;
				end if;
				
				if(b4_x /= 0) then
					if( (b4_y - 7) < 60) then
						b4_x <= 0;
						b4_y <= 0;
						sprite_count4 <= 0;
					elsif(b4_del /= '1') then
						b4_y <= b4_y - 7;
					end if;
				end if;
				
				if(b5_x /= 0) then
					if( (b5_y - 7) < 60 ) then
						b5_x <= 0;
						b5_y <= 0;
						sprite_count5 <= 0;
					elsif(b5_del /= '1') then
						b5_y <= b5_y - 7;
					end if;
				end if;
				
				if(b6_x /= 0) then
					if( (b6_y - 7) < 60 ) then
						b6_x <= 0;
						b6_y <= 0;
						sprite_count6 <= 0;
					elsif(b6_del /= '1') then
						b6_y <= b6_y - 7;
					end if;
				end if;
				
			end if;
			
			if(xcur>b1_x and xcur<=b1_x+15 and ycur>b1_y and ycur<=b1_y+16 and b1_x /= 0 and b1_y /= 0) then
				draw <= '1';
				if (sprite_count1 < 240) then
					if (star_bullet(sprite_count1) /= x"0F0") then
						rgb<= star_bullet(sprite_count1); 
						c_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						c_type <= "10";
					end if;
					
					if (sprite_count1 = 239) then
						sprite_count1 <= 0;
					else
						sprite_count1 <= sprite_count1 + 1;
					end if;
					
				end if;
				
			elsif(xcur>b2_x and xcur<=b2_x+15 and ycur>b2_y and ycur<=b2_y+16 and b2_x /= 0 and b2_y /= 0) then
				draw <= '1';
				if (sprite_count2 < 240) then
					if (star_bullet(sprite_count2) /= x"0F0") then
						rgb<= star_bullet(sprite_count2); 
						c_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						c_type <= "10";
					end if;
					
					if (sprite_count2 = 239) then
						sprite_count2 <= 0;
					else
						sprite_count2 <= sprite_count2 + 1;
					end if;
					
				end if;									
			elsif(xcur>b3_x and xcur<=b3_x+15 and ycur>b3_y and ycur<=b3_y+16 and b3_x /= 0 and b3_y /= 0) then
				draw <= '1';
				if (sprite_count3 < 240) then
					if (star_bullet(sprite_count3) /= x"0F0") then
						rgb<= star_bullet(sprite_count3); 
						c_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						c_type <= "10";
					end if;
					
					if (sprite_count3 = 239) then
						sprite_count3 <= 0;
					else
						sprite_count3 <= sprite_count3 + 1;
					end if;
					
				end if;					
				
			elsif(xcur>b4_x and xcur<=b4_x+15 and ycur>b4_y and ycur<=b4_y+16 and b4_x /= 0 and b4_y /= 0) then
				draw <= '1';
				if (sprite_count4 < 240) then
					if (star_bullet(sprite_count4) /= x"0F0") then
						rgb<= star_bullet(sprite_count4); 
						c_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						c_type <= "10";
					end if;
					
					if (sprite_count4 = 239) then
						sprite_count4 <= 0;
					else
						sprite_count4 <= sprite_count4 + 1;
					end if;
					
				end if;				
				
			elsif(xcur>b5_x and xcur<=b5_x+15 and ycur>b5_y and ycur<=b5_y+16  and b5_x /= 0 and b5_y /= 0) then
				draw <= '1';
				if (sprite_count5 < 240) then
					if (star_bullet(sprite_count5) /= x"0F0") then
						rgb<= star_bullet(sprite_count5); 
						c_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						c_type <= "10";
					end if;	
					
					if (sprite_count5 = 239) then
						sprite_count5 <= 0;
					else
						sprite_count5 <= sprite_count5 + 1;
					end if;
					
				end if;	
				
			elsif(xcur>b6_x and xcur<=b6_x+15 and ycur>b6_y and ycur<=b6_y+16 and b6_x /= 0 and b6_y /= 0) then
				draw <= '1';
				if (sprite_count6 < 240) then
					if (star_bullet(sprite_count6) /= x"0F0") then
						rgb<= star_bullet(sprite_count6); 
						c_type <=  "01";						-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					else
						c_type <= "10";
					end if;
					
					if (sprite_count6 = 239) then
						sprite_count6 <= 0;
					else
						sprite_count6 <= sprite_count6 + 1;
					end if;
					
				end if;					
			else
				draw <= '0';
			end if;
			
			if(b1_del = '1') then
				b1_x <= 0;
				b1_y <= 0;
				sprite_count1 <= 0;
			end if;
			if(b2_del = '1') then
				b2_x <= 0;
				b2_y <= 0;
				sprite_count2 <= 0;
			end if;
			if(b3_del = '1') then
				b3_x <= 0;
				b3_y <= 0;
				sprite_count3 <= 0;
			end if;
			if(b4_del = '1') then
				b4_x <= 0;
				b4_y <= 0;
				sprite_count4 <= 0;
			end if;
			if(b5_del = '1') then
				b5_x <= 0;
				b5_y <= 0;
				sprite_count5 <= 0;
			end if;
			if(b6_del = '1') then
				b6_x <= 0;
				b6_y <= 0;
				sprite_count6 <= 0;
			end if;
				
			
			
		end if;
	end process;
	
	firetimer: process(clk)
	variable timecount: STD_LOGIC_VECTOR(27 downto 0):=X"0000000";
	begin
		if rising_edge(clk) then
			if (timecount < X"0c011ec") then
				fire_clock <= '0';
				timecount:=timecount+1;
				fire_led <= '0';
			elsif (timecount = X"0c011ec") then 
				fire_clock <= '1';
				fire_led <= '1';
			timecount:=timecount+1;
			elsif (timecount > X"0c011ec") then
				--fire_clock <= '1';
				fire_led <= '1';
				if (button = '1') then
					timecount :=X"0000000";
					fire_clock <= '0';
					fire_led <= '0';
				end if;
			end if;
		end if;
	end process;
	
end main;	
			