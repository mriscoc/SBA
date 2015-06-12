--------------------------------------------------------------------------------
--
-- Project Name: %name%
-- Title: %title%
-- Version: %version%
-- Date: %date%
-- Author: %author%
-- Description: %description%
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
use work.%name%_SBAconfig.all;

entity %name%_Top is
port (
%interface%);
end %name%_Top;

--------------------------------------------------------------------------------

architecture %name%_structural of %name%_Top is
     
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
%ipcoressignals%
--------------------------------------------------------------------------------

begin

  %name%_SysCon: entity work.SysCon
  port Map(
    CLK_I => CLKe,
    CLK_O => CLKi,
    RST_I => RSTe,
    RST_O => RSTi
  );

  %name%_Master: entity work.%name%_SBAcontroller
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

  %name%_SBAdecoder: entity work.%name%_SBAdecoder
  port Map(
    STB_I => STBEi,
    ADR_I => ADRi,
    STB_O => STBi
  );

%ipcores%

-- External Signals Assignments
-------------------------------
 RSTe  <= RST_I;
 CLKe  <= CLK_I;

-- Internal Signals Assignments
-------------------------------
 ACKi  <= '1';                  -- If None Slave IPCore use ACK then ACKi must be '1'
 INTi  <= '0';                  -- No interrupts support;

end %name%_structural;

--------------------------------------------------------------------------------
