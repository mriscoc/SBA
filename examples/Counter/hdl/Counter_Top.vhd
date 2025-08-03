--------------------------------------------------------------------------------
-- Project Name: Counter
-- Title: SBA Seven segments 4 digits up counter demo
-- Version: 0.1.1
-- Date: 2025/08/03
-- Project Author: Miguel Risco-Castillo
-- Description: Demo implementation of a simple upcounter with 4 digits, 7 segments 
-- display and a pulsating LED for the Terasic DE boards. The system 
-- clock is assumed to be 50MHz.
--------------------------------------------------------------------------------
-- Template version: 1.3
-- Template date: 2019/06/15
--------------------------------------------------------------------------------
-- For License and Copyright example, you can use or modify at your convenience
-- the file SBAlicense.md for your project.
--------------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use work.Counter_SBAconfig.all;

entity Counter_Top is
port (
  CLK_I     : in  std_logic;
  RST_I     : in  std_logic;
  HEX0      : out std_logic_vector(7 downto 0);
  HEX1      : out std_logic_vector(7 downto 0);
  HEX2      : out std_logic_vector(7 downto 0);
  HEX3      : out std_logic_vector(7 downto 0);
  SW        : in  std_logic_vector(7 downto 0);
  LEDR      : out std_logic_vector(9 downto 0)
);
end Counter_Top;

--------------------------------------------------------------------------------

architecture Counter_structural of Counter_Top is
     
-- SBA internal signals
  Signal RSTi  : Std_Logic;
  Signal CLKi  : Std_Logic;
  Signal ADRi  : ADDR_type;
  Signal DATOi : DATA_type;
  Signal DATIi : DATA_type;
  Signal ADATi : ADAT_type;
  Signal STBEi : std_logic;
  Signal STBi  : std_logic_vector(Stb_width-1 downto 0);
  Signal WEi   : Std_Logic;
  Signal ACKi  : Std_Logic;
  Signal INTi  : Std_Logic;

-- Auxiliary external to internal signals
  Signal CLKe  : std_logic;
  Signal RSTe  : std_logic;

-- Auxiliary IPCores signals
  Signal CLKDi      : std_logic;

--------------------------------------------------------------------------------

begin

  Counter_SysCon: entity work.SysCon
  port Map(
    CLK_I => CLKe,
    CLK_O => CLKi,
    RST_I => RSTe,
    RST_O => RSTi
  );

  Counter_Master: entity work.Counter_SBAcontroller
  port Map(
    RST_I => RSTi, 
    CLK_I => CLKi,  
    DAT_I => DATIi,  
    DAT_O => DATOi,  
    ADR_O => ADRi,
    STB_O => STBEi,
    WE_O  => WEi,
    ACK_I => ACKi,
    INT_I => INTi  
  );

  Counter_mux: entity work.Counter_SBAmux
  port Map(
    STB_I => STBEi,             -- Address Enabler
    -- ADDRESS decoder --------
    ADR_I => ADRi,              -- Address input Bus
    STB_O => STBi,              -- Strobe Chips selector
    -- DATA mux ---------------
    ADAT_I=> ADATi,             -- Array of data buses
    DAT_O => DATIi              -- Data out bus
  );

  CLKDIV: entity work.CLKDIV
  generic map(
    infreq  => sysfreq,
    outfreq => 1,
    debug   => debug
  )
  port map(
    -------------
    RST_I => RSTi,
    CLK_I => CLKi,
    -------------
    CLK_O => CLKDi
  );

  D7SDEX: entity work.D7SDEX
  port map(
    -------------
    RST_I => RSTi,
    CLK_I => CLKi,
    STB_I => STBi(STB_D7SDEX),
    ADR_I => ADRi,
    WE_I  => WEi,
    DAT_I => DATOi,
    -------------
    HEX0  => HEX0,
    HEX1  => HEX1,
    HEX2  => HEX2,
    HEX3  => HEX3
  );

  GPIO: entity work.GPIO
  generic map(
    SIZE    => 8
  )
  port map(
    -------------
    RST_I => RSTi,
    CLK_I => CLKi,
    STB_I => STBi(STB_GPIO),
    WE_I  => WEi,
    DAT_I => DATOi,
    DAT_O => ADATi(STB_GPIO),
    -------------
    P_I   => SW,
    P_O   => LEDR(8 downto 1)
  );



-- External Signals Assignments
-------------------------------
 RSTe  <= not RST_I;            -- SBA reset is active high, negate if it is necessary
 CLKe  <= CLK_I;
 LEDR(0) <= CLKDi;

-- Internal Signals Assignments
-------------------------------
 ACKi  <= '1';                  -- If None Slave IPCore use ACK then ACKi must be '1'
 INTi  <= '0';                  -- No interrupts support;

end Counter_structural;

--------------------------------------------------------------------------------
