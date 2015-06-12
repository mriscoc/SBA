--------------------------------------------------------------------------------
--
-- Project Name: Counter
-- Title: SBA Seven segments 4 digits up counter demo
-- Version: 0.1.1
-- Date: 2015/06/12
-- Author: Miguel A. Risco-Castillo
-- Description: This a demo of the implementation of a simple up counter in the 
-- 4 digits 7 segments display of the Nexys2 board.
-- 
--------------------------------------------------------------------------------
-- Copyright:
--
-- This code, modifications, derivate work or based upon, can not be used or
-- distributed without the complete credits on this header.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please include the appropriate
-- credit of Author.
--
-- The code may not be included into ip collections and similar compilations
-- which are sold. If you want to distribute this code for money then contact me
-- first and ask for my permission.
--
-- These copyright notices in the source code may not be removed or modified.
-- If you modify and/or distribute the code to any third party then you must not
-- veil the original author. It must always be clearly identifiable.
--
-- Although it is not required it would be a nice move to recognize my work by
-- adding a citation to the application's and/or research.
--
-- FOR COMMERCIAL PURPOSES REQUEST THE APPROPRIATE LICENSE FROM THE AUTHOR.
--------------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use work.Counter_SBAconfig.all;

entity Counter_Top is
port (
  CLK_I     : in  std_logic;
  RST_I     : in  std_logic;
  LEDS      : out std_logic_vector(7 downto 0);
  DIG       : out std_logic_vector(3 downto 0);
  SEG       : in  std_logic_vector(7 downto 0)
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
  Signal STBi  : std_logic_vector(Stb_width-1 downto 0);
  Signal WEi   : Std_Logic;
  Signal ACKi  : Std_Logic;
  Signal INTi  : Std_Logic;

-- Auxiliary external to internal signals
  Signal CLKe  : std_logic;
  Signal RSTe  : std_logic;
  Signal STBEi : std_logic;

-- Auxiliary IPCores signals
  Signal CLKDi      : std_logic;
  Signal DAT_GPIO   : DATA_type;

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

  Counter_SBAdecoder: entity work.Counter_SBAdecoder
  port Map(
    STB_I => STBEi,
    ADR_I => ADRi,
    STB_O => STBi
  );

  CLKDIV: entity work.CLKDIV
  generic map(
    infrec  => sysfrec,
    outfrec => 1000
  )
  port map(
    -------------
    RST_I => RSTi,
    CLK_I => CLKi,
    -------------
    CLK_O   => CLKDi
  );

  D7SNX2: entity work.D7SNX2
  port map(
    -------------
    RST_I => RSTi,
    CLK_I => CLKi,
    STB_I => STBi(STB_D7SNX2),
    ADR_I => ADRi,
    WE_I  => WEi,
    DAT_I => DATOi,
    -------------
    DIG     => DIG,
    SEG     => SEG
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
    DAT_O => DAT_GPIO,
    -------------
    P_I     => x"FF",
    P_O     => LEDS
  );

  GPIODataIntf: entity work.DataIntf
  port map(
    STB_I => STBi(STB_GPIO),
    DAT_I => DAT_GPIO,
    DAT_O => DATIi
  );



-- External Signals Assignments
-------------------------------
 RSTe  <= RST_I;
 CLKe  <= CLK_I;

-- Internal Signals Assignments
-------------------------------
 ACKi  <= '1';                  -- If None Slave IPCore use ACK then ACKi must be '1'
 INTi  <= '0';                  -- No interrupts support;

end Counter_structural;

--------------------------------------------------------------------------------
