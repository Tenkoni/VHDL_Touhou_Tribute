-- ****************************************************
--                    Proyecto Final   
-- ****************************************************
-- Integrantes:
--   Garrido Lopez Luis Enrique
--   Miramonte Sarabia Luis Enrique
--   Ortiz Figueroa Maria Fernanda
-- ****************************************************

-- ****************************************************
--        Modulo para dibujar el logo del juego
-- ****************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package logo is
	procedure background_logo(		
		-- xcur y ycur son los valores actuales del cursor, 
		-- es decir, las coordenadas del pixel que se está dibujando, 
		-- xpos y ypos son las coordenadas desde donde se empieza a dibujar
		signal xcur, ycur: in integer; 
		-- Los colores que tendrá el objeto dibujado, colores por pixel, 
		-- se pusieron en 12 bits, lo que nos da 4096 colores RRRRGGGGBBBB
		signal rgb: out std_logic_vector(11 downto 0); 
		-- Bandera que marca si se dibujara o no
		signal draw: out std_logic;
		-- Variables para mover el rectagulo
		signal y1_rec,y2_rec: in integer
	); 
end logo;

package body logo is 
	procedure background_logo(
		-- Se declaran las variables auxiliares para manejar 
		-- los respectivos parametros del procedimiento
		signal xcur, ycur: in integer;
		signal rgb: out std_logic_vector(11 downto 0);
		signal draw: out std_logic;
		signal y1_rec,y2_rec: in integer) is
		
		-- Variable auxiliar para saber posición del dibujo el pixel
		variable pos_dx: integer := 0;
		variable pos_dy: integer := 0;
		
		-- Se declara una matriz que nos ayudará 
		-- a implementar un mapa de bits
		type logo is array (26 downto 0) of std_logic_vector (108 downto 0);
		
		-- Esta constante tiene como proposito ser la referencia
		-- de un mapa de bits para dibujar un logo
		constant llf : logo := (
			"1111111111000000000000000000001111111111000000000000000000011111111111111111111111110000000000000000000000000",
			"1111111111000000000000000000001111111111000000000000000000011111111111111111111111110000000000111111000000000",
			"1111111111000000000000000000001111111111000000000000000000011111111111111111111111110000000011000000110000000",
			"1111111111000000000000000000001111111111000000000000000000011111111111111111111111110000000100000000001000000",
			"1111111111000000000000000000001111111111000000000000000000011111111100000000000000000000001000100001000100000",
			"1111111111000000000000000000001111111111000000000000000000011111111100000000000000000000010001010010100010000",
			"1111111111000000000000000000001111111111000000000000000000011111111100000000000000000000010000000000000010000",
			"1111111111000000000000000000001111111111000000000000000000011111111100000000000000000000010000111111000010000",
			"1111111111000000000000000000001111111111000000000000000000011111111111111111000000000000001000011110000100000",
			"1111111111000000000000000000001111111111000000000000000000011111111111111111000000000000000100001100001000000",
			"1111111111000000000000000000001111111111000000000000000000011111111111111111000000000000000011000000110000000",
			"1111111111000000000000000000001111111111000000000000000000011111111111111111000000000000000000111111000000000",
			"1111111111000000000000000000001111111111000000000000000000011111111100000000000000000000000000000000000000000",
			"1111111111111111111111111000001111111111111111111111111000011111111100000000000000000000111001110001100001110",
			"1111111111111111111111111000001111111111111111111111111000011111111100000000000000000000001010001000100010001",
			"1111111111111111111111111000001111111111111111111111111000011111111100000000000000000000010010001000100011111",
			"1111111111111111111111111000001111111111111111111111111000011111111100000000000000000000100010001000100010001",
			"1111111111111111111111111000001111111111111111111111111000011111111100000000000000000000111001110001110001110",
			"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
			"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
			"1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
			"0000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
			"0000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
			"0000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
			"0000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
			"0000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
			"0000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111" );
		
		-- Se declara una matriz que nos ayudará 
		-- a implementar un mapa de bits
		type mapa_fantasma is array (13 downto 0) of std_logic_vector (13 downto 0);
		
		-- Esta constante tiene como proposito ser la referencia
		-- de un mapa de bits para dibujar el cuerpo de un fantasma
		constant dibujo_f1 : mapa_fantasma := ( "00000111100000",
											             "00011111111000",
											             "00111111111100",
											             "01001111001110",
											             "00000110000110",
											             "00000110000110",
											             "10000110000111",
											             "11001111001111",
											             "11111111111111",
															 "11111111111111",
															 "11111111111111",
															 "11111111111111",
															 "11011100111011",
											             "10001100110001");
		
		-- Esta constante tiene como proposito ser la referencia
		-- de un mapa de bits para dibujar la parte blanca del ojo
		-- del fantasma
		constant dibujo_f2 : mapa_fantasma := ( "00000000000000",
											             "00000000000000",
											             "00000000000000",
											             "00110000110000",
											             "01111001111000",
											             "00011000011000",
											             "00011000011000",
											             "00110000110000",
											             "00000000000000",
															 "00000000000000",
															 "00000000000000",
															 "00000000000000",
															 "00000000000000",
											             "00000000000000");
															 
		-- Esta constante tiene como proposito ser la referencia
		-- de un mapa de bits para dibujar el puntito del ojo del
		-- fantasma
		constant dibujo_f3 : mapa_fantasma := ( "00000000000000",
											             "00000000000000",
											             "00000000000000",
											             "00000000000000",
											             "00000000000000",
											             "01100001100000",
											             "01100001100000",
											             "00000000000000",
											             "00000000000000",
															 "00000000000000",
															 "00000000000000",
															 "00000000000000",
															 "00000000000000",
											             "00000000000000");
											  
		
	begin 
		-- Se dibuja el logo del juego
		if(xcur>160+285 and xcur<=160+394 and ycur>226+45 and ycur<=253+45) then 
			-- Las siguientes instrucciones se encargan
			-- de ubicar un pixel de un dibujo
			pos_dx := ((160+394)-xcur);
			pos_dy := ((253+45)-ycur);
			
			if (llf(pos_dy)(pos_dx)) = '1' then
				rgb <= x"08f";
				draw <= '1';
			else
				draw <= '0';
			end if;
		-- La siguientes lineas se encargan de dibujar los diferentes
		-- pacman en movimiento para presentar el logo del juego
		elsif(xcur>50+160 and xcur<=64+160 and ycur>y1_rec+5 and ycur<=y2_rec+5) then			
			-- Las siguientes instrucciones se encargan
			-- de ubicar un pixel de un dibujo
			pos_dx := ((64+160) - xcur);
			pos_dy := ((y2_rec+5) - ycur);
			
			-- En caso de dibujar un dibujo (fantasma)
			if(dibujo_f1(pos_dy)(pos_dx) = '1') then
				-- Cuerpo del fantasma color rojo
				rgb <= x"f00";
				draw <= '1';
			elsif(dibujo_f2(pos_dy)(pos_dx) = '1') then
				-- Ojo del fantasma color blanco
				rgb <= x"fff";
				draw <= '1';
			elsif(dibujo_f3(pos_dy)(pos_dx) = '1') then
				-- Puntito del ojo del fantasma color azul
				rgb <= x"03f";
				draw <= '1';
			else
				-- En caso de no coincidir con nigun patron
				-- se conserva el color del fondo en general
				draw <= '0';
			end if;
		elsif(xcur>114+160 and xcur<=128+160 and ycur>y1_rec+8 and ycur<=y2_rec+8) then			
			-- Las siguientes instrucciones se encargan
			-- de ubicar un pixel de un dibujo
			pos_dx := ((128+160) - xcur);
			pos_dy := ((y2_rec+8) - ycur);
			
			-- En caso de dibujar un dibujo (fantasma)
			if(dibujo_f1(pos_dy)(pos_dx) = '1') then
				-- Cuerpo del fantasma color naranja
				rgb <= x"f80";
				draw <= '1';
			elsif(dibujo_f2(pos_dy)(pos_dx) = '1') then
				-- Ojo del fantasma color blanco
				rgb <= x"fff";
				draw <= '1';
			elsif(dibujo_f3(pos_dy)(pos_dx) = '1') then
				-- Puntito del ojo del fantasma color azul
				rgb <= x"03f";
				draw <= '1';
			else
				-- En caso de no coincidir con nigun patron
				-- se conserva el color del fondo en general
				draw <= '0';
			end if;
		elsif(xcur>178+160 and xcur<=192+160 and ycur>y1_rec+11 and ycur<=y2_rec+11) then			
			-- Las siguientes instrucciones se encargan
			-- de ubicar un pixel de un dibujo
			pos_dx := ((192+160) - xcur);
			pos_dy := ((y2_rec+11) - ycur);
			
			-- En caso de dibujar un dibujo (fantasma)
			if(dibujo_f1(pos_dy)(pos_dx) = '1') then
				-- Cuerpo del fantasma color amarrillo
				rgb <= x"ff0";
				draw <= '1';
			elsif(dibujo_f2(pos_dy)(pos_dx) = '1') then
				-- Ojo del fantasma color blanco
				rgb <= x"fff";
				draw <= '1';
			elsif(dibujo_f3(pos_dy)(pos_dx) = '1') then
				-- Puntito del ojo del fantasma color azul
				rgb <= x"03f";
				draw <= '1';
			else
				-- En caso de no coincidir con nigun patron
				-- se conserva el color del fondo en general
				draw <= '0';
			end if;
		elsif(xcur>242+160 and xcur<=256+160 and ycur>y1_rec+5 and ycur<=y2_rec+5) then			
			-- Las siguientes instrucciones se encargan
			-- de ubicar un pixel de un dibujo
			pos_dx := ((256+160) - xcur);
			pos_dy := ((y2_rec+5) - ycur);
			
			-- En caso de dibujar un dibujo (fantasma)
			if(dibujo_f1(pos_dy)(pos_dx) = '1') then
				-- Cuerpo del fantasma color verde
				rgb <= x"4f0";
				draw <= '1';
			elsif(dibujo_f2(pos_dy)(pos_dx) = '1') then
				-- Ojo del fantasma color blanco
				rgb <= x"fff";
				draw <= '1';
			elsif(dibujo_f3(pos_dy)(pos_dx) = '1') then
				-- Puntito del ojo del fantasma color azul
				rgb <= x"03f";
				draw <= '1';
			else
				-- En caso de no coincidir con nigun patron
				-- se conserva el color del fondo en general
				draw <= '0';
			end if;
		elsif(xcur>616+160 and xcur<=630+160 and ycur>y1_rec+8 and ycur<=y2_rec+8) then			
			-- Las siguientes instrucciones se encargan
			-- de ubicar un pixel de un dibujo
			pos_dx := ((630+160) - xcur);
			pos_dy := ((y2_rec+8) - ycur);
			
			-- En caso de dibujar un dibujo (fantasma)
			if(dibujo_f1(pos_dy)(pos_dx) = '1') then
				-- Cuerpo del fantasma color verde
				rgb <= x"4f0";
				draw <= '1';
			elsif(dibujo_f2(pos_dy)(pos_dx) = '1') then
				-- Ojo del fantasma color blanco
				rgb <= x"fff";
				draw <= '1';
			elsif(dibujo_f3(pos_dy)(pos_dx) = '1') then
				-- Puntito del ojo del fantasma color azul
				rgb <= x"03f";
				draw <= '1';
			else
				-- En caso de no coincidir con nigun patron
				-- se conserva el color del fondo en general
				draw <= '0';
			end if;
		elsif(xcur>550+160 and xcur<=564+160 and ycur>y1_rec+11 and ycur<=y2_rec+11) then			
			-- Las siguientes instrucciones se encargan
			-- de ubicar un pixel de un dibujo
			pos_dx := ((564+160) - xcur);
			pos_dy := ((y2_rec+11) - ycur);
			
			-- En caso de dibujar un dibujo (fantasma)
			if(dibujo_f1(pos_dy)(pos_dx) = '1') then
				-- Cuerpo del fantasma color amarillo
				rgb <= x"ff0";
				draw <= '1';
			elsif(dibujo_f2(pos_dy)(pos_dx) = '1') then
				-- Ojo del fantasma color blanco
				rgb <= x"fff";
				draw <= '1';
			elsif(dibujo_f3(pos_dy)(pos_dx) = '1') then
				-- Puntito del ojo del fantasma color azul
				rgb <= x"03f";
				draw <= '1';
			else
				-- En caso de no coincidir con nigun patron
				-- se conserva el color del fondo en general
				draw <= '0';
			end if;
		elsif(xcur>486+160 and xcur<=500+160 and ycur>y1_rec+5 and ycur<=y2_rec+5) then			
			-- Las siguientes instrucciones se encargan
			-- de ubicar un pixel de un dibujo
			pos_dx := ((500+160) - xcur);
			pos_dy := ((y2_rec+5) - ycur);
			
			-- En caso de dibujar un dibujo (fantasma)
			if(dibujo_f1(pos_dy)(pos_dx) = '1') then
				-- Cuerpo del fantasma color naranja
				rgb <= x"f80";
				draw <= '1';
			elsif(dibujo_f2(pos_dy)(pos_dx) = '1') then
				-- Ojo del fantasma color blanco
				rgb <= x"fff";
				draw <= '1';
			elsif(dibujo_f3(pos_dy)(pos_dx) = '1') then
				-- Puntito del ojo del fantasma color azul
				rgb <= x"03f";
				draw <= '1';
			else
				-- En caso de no coincidir con nigun patron
				-- se conserva el color del fondo en general
				draw <= '0';
			end if;
		elsif(xcur>422+160 and xcur<=436+160 and ycur>y1_rec+8 and ycur<=y2_rec+8) then			
			-- Las siguientes instrucciones se encargan
			-- de ubicar un pixel de un dibujo
			pos_dx := ((436+160) - xcur);
			pos_dy := ((y2_rec+8) - ycur);
			
			-- En caso de dibujar un dibujo (fantasma)
			if(dibujo_f1(pos_dy)(pos_dx) = '1') then
				-- Cuerpo del fantasma color rojo
				rgb <= x"f00";
				draw <= '1';
			elsif(dibujo_f2(pos_dy)(pos_dx) = '1') then
				-- Ojo del fantasma color blanco
				rgb <= x"fff";
				draw <= '1';
			elsif(dibujo_f3(pos_dy)(pos_dx) = '1') then
				-- Puntito del ojo del fantasma color azul
				rgb <= x"03f";
				draw <= '1';
			else
				-- En caso de no coincidir con nigun patron
				-- se conserva el color del fondo en general
				draw <= '0';
			end if;
		else
			draw <= '0';
		end if;
	end background_logo;
end logo;