-- /SBA: Program Details =======================================================
-- Project Name: Counter
-- Title: SBA Seven segments 4 digits up counter demo
-- Version: 0.1.1
-- Date: 2025/08/03
-- Project Author: Miguel Risco-Castillo
-- Description: Demo implementation of a simple upcounter with 4 digits, 7 segments 
-- display and a pulsating LED for the Terasic DE boards. The system 
-- clock is assumed to be 50MHz.
-- /SBA: End Program Details ---------------------------------------------------

-- /SBA: User Registers and Constants ==========================================

variable count : unsigned(15 downto 0); -- Counter register

   constant ms         : positive:= positive(real(sysfreq)/real(1000)+0.499)-1;
   variable DlyReg_1ms : natural range 0 to ms;  -- Constant Delay of 1ms
   variable Dly_ms     : natural;                -- Delay register in ms

-- /SBA: End User Registers and Constants --------------------------------------

-- /SBA: User Program ==========================================================

=> SBAjump(Init);            -- Reset Vector (001)
=> SBAjump(INT);             -- Interrupt Vector (002)

------------------------------ ROUTINES ----------------------------------------
-- /L:Delay_ms
=> DlyReg_1ms:=ms;
=> if DlyReg_1ms/=0 then
     dec(DlyReg_1ms);
     SBAjump(Delay_ms+1);
   end if;
=> if Dly_ms/=0 then
     dec(Dly_ms);
     SBAjump(Delay_ms);
   else
     SBARet;
   end if;

------------------------------ INTERRUPT ---------------------------------------
-- /L:INT
=>                          -- Start your interrupt routine here
=> SBAreti;
------------------------------ MAIN PROGRAM ------------------------------------

-- /L:Init
=> count := x"0000"         -- Initial counter value
-- /L:Mainloop
=> SBAwrite(D7S_S, count);  -- Show count in the display
=> SBAwrite(GPIO, count);   -- Show count in the leds
=> Dly_ms := 1000;          -- Wait for 1000ms
   SBAcall(Delay_ms);       -- Call delay routine
=> inc(count);              -- Increment counter register
   SBAjump(Mainloop);       -- Jump to Mainloop

-- /SBA: End User Program ------------------------------------------------------

