-- ****************************************************
--                    Proyecto Final   
-- ****************************************************
-- Integrantes:
--   Garrido Lopez Luis Enrique
--   Miramonte Sarabia Luis Enrique
--   Ortiz Figueroa Maria Fernanda
-- ****************************************************

-- ****************************************************
--        Modulo para controlar la sincronización
--           horizontal y vertical (escenarios)
-- ****************************************************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.start.all;
use work.logo.all;
use work.background.all;
use work.sprite.all;

entity sync is
	port(
		-- Reloj de 25 MHz
		clk: in std_logic;
		switch : in std_logic;
		-- Habilitación de sincronización horizontal o vertical
		hsync, vsync: out std_logic;
		-- Control del color para cada pixel
		r,g,b : out std_logic_vector(3 downto 0);
		-- MOvimientos en general Arriba, Derecha, Abajo e Izquierda
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
		e1_del, e2_del, e3_del, e4_del, e5_del, e6_del, e7_del, e8_del, e9_del: out std_logic := '0'
		
	);
end sync;

architecture main of sync is
	-- Variable auxiliar para el movimiento de los
	-- pacman en logo
	signal mov_auto: std_logic;
	signal cuenta_mov: integer range 0 to 185116 := 0;
	
	-- Variable auxiliar para mover los escenarios del juego
	signal numero_escenario: integer range 0 to 2 := 0;
	signal cuenta_escenario: integer range 0 to 125000000 := 0;
	signal cambio_escenario: std_logic;
	
	-- Variable auxiliar para manejar el color RBG
	signal rgb_f: std_logic_vector(11 downto 0);
	signal rgb_bp: std_logic_vector(11 downto 0);
	signal rgb_bs: std_logic_vector(11 downto 0);
	signal rgb_bl: std_logic_vector(11 downto 0);
	
	-- Variable auxiliar para dibujar en la pantalla
	signal draw_f: std_logic;
	signal draw_bs: std_logic;
	signal draw_bl: std_logic;
	
	-- Variables referencia para dibujar personaje en pantalla
	signal fig_x1: integer range 0 to 800 := 480;
	signal fig_y1: integer range 0 to 525 := 350;
	
	-- Variables generales para determinar las posiciones horizontal 
	-- y vertical en la pantalla
	signal hpos: integer range 0 to 800 := 0;
	signal vpos: integer range 0 to 525 := 0;
	
	-- Variable para indicar el movimiento de los botones
	constant despl: integer range 0 to 480:= 10;
	
	-- Variables para controloar el sprite usado (personaje)
	signal count_sprite: integer := 0;
	signal charac: std_logic_vector(1 downto 0);
	
	-- Variable para controlar la animación del sprite
	signal animationsignal: std_logic_vector(3 downto 0);
	
	-- Se declaran variables auxiliares para definir un cuadrado, 
	-- considerar que este se movera de arriba hacia abajo
	signal y1_rec: integer range 0 to 525 := 45;
	signal y2_rec: integer range 0 to 525:= 58;
	signal aux_mov: integer range 0 to 1 := 0;
	
	-- Se declaran variables auxiliares para tener un control
	-- de los niveles, las vidas y el score
	signal nivel: integer range 0 to 4 := 1;
	signal vida: integer range 0 to 3 := 3;
	signal vida_aux :integer := 6;
	signal sc_u,sc_d,sc_c,sc_m,sc_mm: integer range 0 to 9 := 0;
	signal asc_c,asc_m,asc_mm: std_logic;
	
	----disparos
	signal fireable: std_logic := '1';
	signal eisfee: STD_LOGIC_VECTOR(27 downto 0):=X"01201AE";
	signal defeat: std_logic := '0';	

	
begin
	-- Referencias para el centro de la pantalla
	-- Centro horizontal
	--  fig_x1 <=480; 
	-- Centro vertical
	--  fig_y1 <=285;
	
	-- Inicio de la pantalla
	-- Inicio horizontal
	-- fig_x1 <= 160;
	-- Inicio vertical
	-- fig_y1 <= 45;
	
	-- Divisor de frecuencia para desplazar los pacman del logo
	process(clk)
	begin
	hpos_o <= hpos;
	vpos_o <= vpos;
	fig_x1_o <= fig_x1;
	fig_y1_o <= fig_y1;	
		if rising_edge(clk) then
			if (cuenta_mov = 185115) then
				cuenta_mov <= 0;
				mov_auto <= '1';
			else
				cuenta_mov <= cuenta_mov + 1;
				mov_auto <= '0';
			end if;	
		end if;
	end process;
	
	-- Se verifica el tope del movimiento de los pacman del logo
	process(y1_rec)
	begin
		if(y1_rec = 45) then	
			aux_mov <= 0;
		elsif(y1_rec = 511) then
			aux_mov <= 1;
		end if;
	end process;
		
	-- Se verifica si el desplazamiento es arriba o abajo
	-- de los pacman del logo
	process(mov_auto)
	begin
		if(mov_auto='1') then
			if(aux_mov = 0) then
				y1_rec <= y1_rec + 1;
				y2_rec <= y2_rec + 1;
			else
				y1_rec <= y1_rec - 1;
				y2_rec <= y2_rec - 1;
			end if;
		end if;
	end process;
	
	process (vida_aux)
	begin
			if(vida_aux = 6) then
				vida <= 3;
			elsif(vida_aux = 4) then
				vida <= 2;
			elsif(vida_aux = 2) then
				vida <= 1;
			elsif(vida_aux = 0) then
				vida <= 0;
			end if;
	end process;
	
	
		-- Divisor de frecuencia para el escenario
	-- Se contabilizan los flancos de subida de la señal de reloj 
	-- para indicar un cambio cada 5 segundos aproximadamente
	process(clk)
	begin
		if rising_edge(clk) then
			if (cuenta_escenario = 124999999) then
				-- Provisional en lo que se crea la dinámica del juego
				if (numero_escenario < 2) then
					numero_escenario <= numero_escenario + 1;
				end if;
				cuenta_escenario <= 0;
			else
				cuenta_escenario <= cuenta_escenario + 1;
			end if;
			if(defeat = '1') then
				cuenta_escenario <= 0;
			end if;
		end if;
	end process;
	
	process(clk)
	begin
	if(rising_edge(clk))then
		if(((fig_x1 > e1_x and fig_x1 <= e1_x+37) or (fig_x1+25 > e1_x and fig_x1+25 <= e1_x+37)) and ((fig_y1 > e1_y and fig_y1 <= e1_y+27) or (fig_y1+47 > e1_y and fig_y1+47 <= e1_y+27)) and fig_x1 /= 0) then
				
				e1_del <= '1';
				
				if(vida > 0)then
					vida_aux <= vida_aux - 1;
					defeat <= '0';	
					
				else
					vida_aux <= 6;
					defeat <= '1';		
				end if;
	
		elsif(((fig_x1 > e2_x and fig_x1 <= e2_x+37) or (fig_x1+25 > e2_x and fig_x1+25 <= e2_x+37)) and ((fig_y1 > e2_y and fig_y1 <= e2_y+27) or (fig_y1+47 > e2_y and fig_y1+47 <= e2_y+37)) and fig_x1 /= 0) then
	
				e2_del <= '1';
				
				if(vida > 0)then
					vida_aux <= vida_aux - 1;
					defeat <= '0';	
					
				else 
					vida_aux <= 6;
					defeat <= '1';		
				end if;
				
		elsif(((fig_x1 > e3_x and fig_x1 <= e3_x+37) or (fig_x1+25 > e3_x and fig_x1+25 <= e3_x+37)) and ((fig_y1 > e3_y and fig_y1 <= e3_y+27) or (fig_y1+47 > e3_y and fig_y1+47 <= e3_y+37)) and fig_x1 /= 0) then
				
				e3_del <= '1';
				
				if(vida > 0)then
					vida_aux <= vida_aux - 1;
					defeat <= '0';	
					
				else 
					vida_aux <= 6;
					defeat <= '1';		
				end if;
				
		elsif(((fig_x1 > e4_x and fig_x1 <= e4_x+37) or (fig_x1+25 > e4_x and fig_x1+25 <= e4_x+37)) and ((fig_y1 > e4_y and fig_y1 <= e4_y+27) or (fig_y1+47 > e4_y and fig_y1+47 <= e4_y+37)) and fig_x1 /= 0) then
				
				e4_del <= '1';
				
				if(vida > 0)then
					vida_aux <= vida_aux - 1;
					defeat <= '0';	
					
				else 
					vida_aux <= 6;
					defeat <= '1';		
				end if;
				
		elsif(((fig_x1 > e5_x and fig_x1 <= e5_x+37) or (fig_x1+25 > e5_x and fig_x1+25 <= e5_x+37)) and ((fig_y1 > e5_y and fig_y1 <= e5_y+27) or (fig_y1+47 > e5_y and fig_y1+47 <= e5_y+37)) and fig_x1 /= 0) then
				
				e5_del <= '1';
				
				if(vida > 0)then
					vida_aux <= vida_aux - 1;
					defeat <= '0';	
					
				else 
					vida_aux <= 6;
					defeat <= '1';		
				end if;
				
		elsif(((fig_x1 > e6_x and fig_x1 <= e6_x+37) or (fig_x1+25 > e6_x and fig_x1+25 <= e6_x+37)) and ((fig_y1 > e6_y and fig_y1 <= e6_y+27) or (fig_y1+47 > e6_y and fig_y1+47 <= e6_y+37)) and fig_x1 /= 0) then
				
				e6_del <= '1';
				
				if(vida > 0)then
					vida_aux <= vida_aux - 1;
					defeat <= '0';	
					
				else 
					vida_aux <= 6;
					defeat <= '1';		
				end if;
				
		elsif(((fig_x1 > e7_x and fig_x1 <= e7_x+37) or (fig_x1+25 > e7_x and fig_x1+25 <= e7_x+37)) and ((fig_y1 > e7_y and fig_y1 <= e7_y+27) or (fig_y1+47 > e7_y and fig_y1+47 <= e7_y+37)) and fig_x1 /= 0) then
				
				e7_del <= '1';
				
				if(vida > 0)then
					vida_aux <= vida_aux - 1;
					defeat <= '0';	
					
				else 
					vida_aux <= 6;
					defeat <= '1';		
				end if;
				
		elsif(((fig_x1 > e8_x and fig_x1 <= e8_x+37) or (fig_x1+25 > e8_x and fig_x1+25 <= e8_x+37)) and ((fig_y1 > e8_y and fig_y1 <= e8_y+27) or (fig_y1+47 > e8_y and fig_y1+47 <= e8_y+37)) and fig_x1 /= 0) then
				
				e8_del <= '1';
				
				if(vida > 0)then
					vida_aux <= vida_aux - 1;
					defeat <= '0';	
					
				else 
					vida_aux <= 6;
					defeat <= '1';		
				end if;
				
		elsif(((fig_x1 > e9_x and fig_x1 <= e9_x+37) or (fig_x1+25 > e9_x and fig_x1+25 <= e9_x+37)) and ((fig_y1 > e9_y and fig_y1 <= e9_y+27) or (fig_y1+47 > e9_y and fig_y1+47 <= e9_y+37)) and fig_x1 /= 0) then
				
				e9_del <= '1';
				
				if(vida > 0)then
					vida_aux <= vida_aux - 1;
					defeat <= '0';	
					
				else 
					vida_aux <= 6;
					defeat <= '1';		
				end if;
		else
				e1_del <= '0';
				e2_del <= '0';
				e3_del <= '0';
				e4_del <= '0';
				e5_del <= '0';
				e6_del <= '0';
				e7_del <= '0';
				e8_del <= '0';
				e9_del <= '0';
				defeat <= '0';
		end if;
	end if;
end process;
	-- Proceso provicional para ver el aumento del score
	-- solo hay que cambiar cada cuanto hay que sumar
	process(b1_del, b2_del, b3_del, b4_del, b5_del, b6_del, defeat)
	begin
--		if (fireable = '1') then
--			shot_enable <= '1';
--		else
--			shot_enable <= '0';
--		end if;
		
		if (b1_del or b2_del or b3_del or b4_del or b5_del or b6_del) then
			if(sc_d = 9) then
				sc_d <= 0;
				asc_c <= '1'; 
			else
				sc_d <= sc_d + 1;
				asc_c <= '0'; 
			end if;
		end if;
			if (defeat) then
				sc_d <= 0;
				asc_c <= '0'; 
			end if;
	end process;
	
	process(asc_c)
	begin
		if (asc_c) then
			if(sc_c = 9) then
				sc_c <= 0;
				asc_m <= '1'; 
			else
				sc_c <= sc_c + 1;
				asc_m <= '0'; 
			end if;
		end if;
		if (defeat) then
				sc_c <= 0;
				asc_m <= '0'; 
			end if;
	end process;
	
	process(asc_m, defeat)
	begin
		if rising_edge(asc_m) then
			if(sc_m = 9) then
				sc_m <= 0;
				asc_mm <= '1'; 
			else
				sc_m <= sc_m + 1;
				asc_mm <= '0'; 
			end if;
		end if;
		if (defeat) then
				sc_m <= 0;
				asc_mm <= '0'; 
			end if;
	end process;
	
	process(asc_mm, defeat)
	begin
		if rising_edge(asc_mm) then
			if(sc_mm = 9) then
				sc_mm <= 0;
			else
				sc_mm <= sc_mm + 1; 
			end if;
		end if;
		if (defeat) then
				sc_mm <= 0;
			end if;
	end process;
	
	-- Proceso que se encarga de verificar a partir del score
	-- el nivel en el cual se encuentra provisional
	process(asc_c,defeat)
	begin
		if rising_edge(asc_c) then
			if (sc_c = 1) then
				eisfee <= X"01201AE";
				nivel <= 1;
			elsif (sc_c = 2) then
				eisfee <= x"00E014E";
				nivel <= 2;
			elsif (sc_c = 3) then
				eisfee <= x"00A00EE";
				nivel <= 3;
			elsif (sc_c = 4) then
				eisfee <= x"006008F";
				nivel <= 4;
			end if;
		end if;
		if (defeat) then
			eisfee <= X"01201AE";
			nivel <= 1;
			end if;
	end process;
	
	-- Diviso de frequencia para la animación
	process(clk)
	variable cuenta: STD_LOGIC_VECTOR(27 downto 0):=X"0000000";
	begin
		if rising_edge(clk) then
			-- Animación 1
			if (cuenta <= X"1805A3") then
				animationsignal <= x"0";
			-- Animación 2
			elsif (cuenta > x"1805A3" and cuenta <= x"300B46") then 
				animationsignal <= x"1";
			-- ANimación 3
			elsif (cuenta > x"300B46" and cuenta <= x"4810E9") then
				animationsignal <= x"2";
			-- Animación 4
			elsif (cuenta > x"4810E9" and cuenta <= x"60168C") then
				animationsignal <= x"3";
			-- Animación 5
			elsif (cuenta > x"60168C" and cuenta <= x"781C2F") then
				animationsignal <= x"4"; 
			-- Animación 6
			elsif (cuenta > x"781C2F" and cuenta <= x"9021D2") then
				animationsignal <= x"5";
			-- Animación 7
			elsif (cuenta > x"9021D2" and cuenta <= x"A82775") then
				animationsignal <= x"6";
			-- Animación 8
			elsif (cuenta > x"A82775" and cuenta <= x"C02D18") then 
				animationsignal <= x"7";
			-- Animación 9
			elsif (cuenta > X"C02D18") then 
				cuenta:=X"0000000";
			end if;
			cuenta:=cuenta+1;
		end if;
	end process;
	
	updatebullet: process(clk)
	variable timecount: STD_LOGIC_VECTOR(27 downto 0):=X"0000000";
	begin
		if rising_edge(clk) then
--			if (timecount <= X"c011ec") then
--				fireable <= '0';
--				timecount:=timecount+1;
--
--			elsif (timecount >= X"c011ec" and movement(4) = '1') then 
--				timecount :=X"0000000";
--				fireable <= '1';
--			end if;
			if (timecount <= X"1fb109") then
				bullet_signal <= '0';
			elsif (timecount > X"1fb109") then
				bullet_signal <= '1';
				timecount :=X"0000000";
			end if;
			timecount := timecount + 1;
		end if;
	end process;
	
	updatefairy: process(clk)
	variable timecount: STD_LOGIC_VECTOR(27 downto 0):=X"0000000";
	begin
		if rising_edge(clk) then
--			if (timecount <= X"c011ec") then
--				fireable <= '0';
--				timecount:=timecount+1;
--
--			elsif (timecount >= X"c011ec" and movement(4) = '1') then 
--				timecount :=X"0000000";
--				fireable <= '1';
--			end if;
			if (timecount <= eisfee) then
				fairy_signal <= '0';
			elsif (timecount > eisfee) then
				fairy_signal <= '1';
				timecount :=X"0000000";
			end if;
			timecount := timecount + 1;
		end if;
	end process;
--		firetimer: process(clk)
--	variable timecount: STD_LOGIC_VECTOR(27 downto 0):=X"0000000";
--	begin
--		if rising_edge(clk) then
--			if (timecount <= X"c011ec") then
--				fireable <= '0';
--				timecount:=timecount+1;
--
--			elsif (timecount > X"c011ec" and button_debounced = '1') then 
--				timecount :=X"0000000";
--				fireable <= '1';
--			else if (timecount > X"c011ec" and button_debounced = '1')
--			end if;
--		
----			if (timecount <= X"6008f6") then
----				bullet_signal <= '0';
----			elsif (timecount > X"6008f6") then
----				bullet_signal <= '1';
----				timecount :=X"0000000";
----			else 
----				timecount := timecount + 1;
----			end if;
--		end if;
--	end process;
	
	-- Se pasan los respectivos parametros a este
	-- procedimiento que se empleara en background
	background_play(hpos, vpos, rgb_bp, nivel, vida, sc_u, sc_d, sc_c, sc_m, sc_mm);
	-- Se pasan los respectivos parametros a este
	-- procedimiento que se empleara en start
	background_start(hpos, vpos, rgb_bs, draw_bs);
	-- Se pasan los respectivos parametros a este
	-- procedimiento que se empleara en logo
	background_logo(hpos, vpos, rgb_bl, draw_bl, y1_rec, y2_rec);
	-- Se pasan los respectivos parametros a este
	-- procedimiento que se empleara en sprite
	figure(hpos, vpos, fig_x1, fig_y1, rgb_f, draw_f, count_sprite, charac, animationsignal);
	
	-- Se encarga de mostrar el escenario respectivo
	process(clk)
	begin
		if rising_edge(clk) then
			-- Escenario START
			if (numero_escenario = 0) then
				-- Verificación de tiempo para cambio de escenario
				if(draw_bs = '1')then
					r<=rgb_bs(11 downto 8);
					g<=rgb_bs(7 downto 4);
					b<=rgb_bs(3 downto 0);
				else
					r<=x"0";
					g<=x"0";
					b<=x"0";
				end if;
			-- Escenario LOGO
			elsif (numero_escenario = 1) then
				if(draw_bl = '1')then
					r<=rgb_bl(11 downto 8);
					g<=rgb_bl(7 downto 4);
					b<=rgb_bl(3 downto 0);
				else
					r<=x"f";
					g<=x"f";
					b<=x"f";
				end if;
			-- Escenario BACKGROUND y SPRITE
			elsif (numero_escenario = 2) then
				-- El siguiente procedimiento controla el
				-- pixel que se está actualizando
				-- Fondo en general
				if (draw_f /= '0') then
					-- Sprite, según el mapa de bits
					-- [01 dibujo] [00 no dibujo] [10 transparencia] [11 reset]
					if(charac = "01")then
						r<=rgb_f(11 downto 8);
						g<=rgb_f(7 downto 4);
						b<=rgb_f(3 downto 0);
						count_sprite <= count_sprite + 1;
					elsif (charac = "11") then
						count_sprite <= 0;
					elsif (charac = "10")then 
						r<=rgb_bp(11 downto 8);
						g<=rgb_bp(7 downto 4);
						b<=rgb_bp(3 downto 0);
						count_sprite <= count_sprite + 1;
					end if;
				elsif(draw_bullet /= '0') then
					if (c_type = "01") then
						r<=rgb_bullet(11 downto 8);
						g<=rgb_bullet(7 downto 4);
						b<=rgb_bullet(3 downto 0);
					elsif (c_type = "10")then 
						r<=rgb_bp(11 downto 8);
						g<=rgb_bp(7 downto 4);
						b<=rgb_bp(3 downto 0);
					end if;
				elsif(draw_fairy /= '0') then
					if (e_type = "01") then
						r<=rgb_fairy(11 downto 8);
						g<=rgb_fairy(7 downto 4);
						b<=rgb_fairy(3 downto 0);
					elsif (e_type = "10")then 
						r<=rgb_bp(11 downto 8);
						g<=rgb_bp(7 downto 4);
						b<=rgb_bp(3 downto 0);
					end if;
				else
					r<=rgb_bp(11 downto 8);
					g<=rgb_bp(7 downto 4);
					b<=rgb_bp(3 downto 0);
				end if;	
			end if;
			
			-- Recorrido horizontal y vertical 640x480
			if (hpos < 800) then 
				hpos <= hpos + 1;
			else 
				hpos <= 0;
				if(vpos<525) then 
					vpos <= vpos + 1;
				else
					vpos <= 0;
					-- Control del movimiento
					-- Movimiento arriba
					if(movement(3)='1') then
						if(fig_y1 >= 45 + despl) then
							fig_y1 <= fig_y1 - despl;
						end if;
					end if;
					-- MOvimiento derecha
					if (movement(2)='1') then
						if(fig_x1<=700 - 25 - despl) then
							fig_x1 <= fig_x1 + despl;
						end if;
					end if;
					-- Movimiento abajo
					if (movement(1)= '1') then
						if(fig_y1<= 525 - 47 - despl) then
							fig_y1 <= fig_y1 + despl;
						end if;
					end if;
					-- Movimiento izquierda
					if (movement(0)= '1') then
						if(fig_x1>=160 + despl) then
							fig_x1 <= fig_x1 - despl;
						end if;
					end if;
				end if;
			end if;
					
			-- Señal de sincronización horizontal 
			if (hpos > 16 and hpos < 112) then
				-- Esto es porque el pulso de sync es bajo
				hsync <= '0'; 
			else
				hsync <= '1';
			end if;	
						
			-- Señal de sincronización vertical
			if (vpos > 10 and vpos < 12) then
				-- Esto es porque el pulso de sync es bajo
				vsync <= '0'; 
			else
				vsync <= '1';
			end if;	
						
			-- Cuando se este en fp
			-- hSync, bp y lf  ó vSync, bp y tb se deben 
			-- mantener las señales de los colores en 0
			if ((hpos > 0 and hpos < 160) or (vpos > 0 and vpos < 45)) then 
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '0');
			end if;
		end if;
	end process;
end main;