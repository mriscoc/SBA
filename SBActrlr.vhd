-- /SBA: Controller ============================================================
--
-- /SBA: Program Details =======================================================
-- Project Name: %name%
-- Title: %title%
-- Version: %version%
-- Date: %date%
-- Project Author: %author%
-- Description: %description%
-- /SBA: End Program Details ---------------------------------------------------
--
-- SBA Master System Controller v1.73 2025/10/24
-- Based on Master Controller for SBA v1.2 Guidelines
--
-- SBA Author: Miguel A. Risco-Castillo
-- SBA web page: http://sba.accesus.com
--
--------------------------------------------------------------------------------
-- For License and copyright information refer to the file:
-- https://github.com/mriscoc/SBA/blob/master/SBAlicense.md
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.%name%_SBAconfig.all;
use work.SBApackage.all;

entity %name%_SBAcontroller  is
port(
   RST_I : in std_logic;                     -- active high reset
   CLK_I : in std_logic;                     -- main clock
   DAT_I : in std_logic_vector;              -- Data input Bus
   DAT_O : out std_logic_vector;             -- Data output Bus
   ADR_O : out std_logic_vector;             -- Address output Bus
   STB_O : out std_logic;                    -- Strobe enabler
   WE_O  : out std_logic;                    -- Write / Read
   ACK_I : in  std_logic;                    -- Strobe Acknowledge
   INT_I : in  std_logic                     -- Interrupt request
);
end %name%_SBAcontroller;

architecture %name%_SBAcontroller_Arch of %name%_SBAcontroller is

  subtype STP_type is integer range 0 to 63;
  type STPS_type is array (0 to 7) of STP_type; -- 8 levels of subrutine support
  subtype ADR_type is integer range 0 to (2**ADR_O'length-1);

  signal D_Oi : unsigned(DAT_O'range);       -- Internal Data Out signal (unsigned)
  signal A_Oi : ADR_type;                    -- Internal Address signal (integer)
  signal S_Oi : std_logic;                   -- strobe (Address valid)   
  signal W_Oi : std_logic;                   -- Write enable ('0' read enable)
  signal STPi : STP_type;                    -- STeP counter
  signal NSTPi: STP_type;                    -- Step counter + 1 (Next STep)
  signal IFi  : std_logic;                   -- Interrupt Flag
  signal IEi  : std_logic;                   -- Interrupt Enable

-- /SBA: User Signals and Type definitions =====================================

-- /SBA: End User Signals and Type definitions ---------------------------------

begin

  Main : process (CLK_I, RST_I)

-- General variables
  variable jmp  : STP_type;                  -- Jump step register
  variable dati : unsigned(DAT_I'range);     -- Input Internal Data Bus
  alias    dato is D_Oi;                     -- Output Data Bus alias

-- Multiroutine support
  variable STPS  : STPS_type;                -- Step Stack
  variable STPS_P : natural range STPS'range;-- Step Stack pointer

-- Interrup support variables
  variable reti : STP_type;                  -- Return from Interrupt
  variable rfif : std_logic;                 -- Return from Interrupt flag
  variable tmpdati : unsigned(DAT_I'range);  -- Temporal dati
  variable tiei : std_logic;                 -- Temporal Interrupt Enable

-- /SBA: Procedures ============================================================

  -- Prepare bus for reading from DAT_I in the next step
  procedure SBAread(addr:in integer) is
  begin
    if (debug=1) then
      Report "SBAread: Address=" &  integer'image(addr);
    end if;

    A_Oi <= addr;
    W_Oi <= '0';
  end;

  -- Write values to bus
  procedure SBAwrite(addr:in integer; data: in unsigned) is
  begin
    if (debug=1) then
      Report "SBAwrite: Address=" &  integer'image(addr) & " Data=" &  integer'image(to_integer(data));
    end if;

    A_Oi <= addr;
    S_Oi <= '1';
    W_Oi <= '1';
    D_Oi <= resize(data,D_Oi'length);
  end;

  -- write integers
  procedure SBAwrite(addr:in integer; data: in integer) is
  begin
    SBAwrite(addr,to_unsigned(data,D_Oi'length));
  end;		   

  -- Do not make any changes to the bus and re-enable the strobe signal, use only after a valid read/write.
  procedure SBAwait is
  begin
    S_Oi<=W_Oi;  -- Strobe signal only in Write operations
  end;

  -- Jump to arbitrary step
  procedure SBAjump(stp:in integer) is
  begin
	 jmp:=stp;
  end;

  -- Jump to rutine and storage return step in ret variable
  procedure SBAcall(stp:in integer) is
  begin
	 jmp:=stp;
     STPS(STPS_P):=NSTPi;
     dec(STPS_P);
  end;

  -- Return from subrutine
  procedure SBAret is
  begin
    inc(STPS_P);
    jmp:=STPS(STPS_P);
  end;

  -- Return from interrupt
  procedure SBAreti is
  begin
    jmp:=reti;
    IEi<=tiei;
    rfif:='1';
  end;

  -- Interrupt enable disable
  procedure SBAinte(enable:boolean) is
  begin
    if enable then IEi<='1'; else IEi<='0'; end if;
  end;

-- /SBA: End Procedures --------------------------------------------------------

-- /SBA: User Procedures and Functions =========================================

-- /SBA: End User Procedures and Functions -------------------------------------
  
-- /SBA: User Registers and Constants ==========================================

-- /SBA: End User Registers and Constants --------------------------------------

-- /SBA: Label constants =======================================================
  constant INT: integer := 003;
  constant Init: integer := 004;
  constant Mainloop: integer := 006;
-- /SBA: End Label constants ---------------------------------------------------

begin

  if rising_edge(CLK_I) then
  
    if (debug=1) then
      Report "Step: " &  integer'image(STPi);
    end if;
	 
	jmp := 0;			      -- Default jmp value
    S_Oi<='0';                -- Default S_Oi value

	if STPi=2 then            -- Save DAT_I to restore after interrupt
      tmpdati:=unsigned(DAT_I);
    end if;

    if rfif='0' then
      dati:= unsigned(DAT_I); -- Get and capture value from data bus
    else
      dati:= tmpdati;         -- restore data bus after interrupt
      rfif:= '0';
    end if;

    if (RST_I='1') then
      STPi<= 1;               -- First step is 1 (cal and jmp valid only if >0)
      A_Oi<= 0;               -- Default Address Value
      W_Oi<='1';              -- Default W_Oi value on reset

    -- Multisubroutine support
      STPS_P:=STPS'high;      -- Default Step Stack pointer value

    -- Interrupt Support
      IEi <='0';              -- Default Interrupt disable
      reti:= 0;
      rfif:='0';

    elsif (ACK_I='1') or (S_Oi='0') then
      case STPi is

-- /SBA: User Program ==========================================================
                
        When 001=> SBAjump(Init);            -- Reset Vector (001)
        When 002=> SBAjump(INT);             -- Interrupt Vector (002)

------------------------------ ROUTINES ----------------------------------------

------------------------------ INTERRUPT ---------------------------------------
-- /L:INT
        When 003=>                           -- Start your interrupt routine here
        When 004=> SBAreti;
------------------------------ MAIN PROGRAM ------------------------------------
                
-- /L:Init
        When 005=>                           -- Start your program here
-- /L:Mainloop
        When 006=> SBAjump(Mainloop);
                
-- /SBA: End User Program ------------------------------------------------------

        When others=> jmp:=1; 
      end case;

      if IFi='1' then
        if jmp/=0 then reti:=jmp; else reti:=NSTPi; end if;
        tiei := IEi;
        IEi <= '0';
        STPi <= 2;      -- Always jump to Step 002 (Interrupt vector) (TODO: Could be INT?)
      else
        if jmp/=0 then STPi<=jmp; else STPi<=NSTPi; end if;
      end if;

    end if;
  end if;
end process;

IntProcess : process(RST_I,INT_I,IEi)
begin
  if RST_I='1' then
    IFi<='0';
  elsif (INT_I='1') and (IEi='1') then
    IFi<='1';
  else
    IFi<='0';
  end if;
end process IntProcess;

-- /SBA: User Statements =======================================================

-- /SBA: End User Statements ---------------------------------------------------

NSTPi <= STPi + 1;      -- Step plus one (Next STeP)
STB_O <= S_Oi;
WE_O  <= W_Oi;
ADR_O <= std_logic_vector(to_unsigned(A_Oi,ADR_O'length));
DAT_O <= std_logic_vector(D_Oi);

end %name%_SBAController_Arch;

