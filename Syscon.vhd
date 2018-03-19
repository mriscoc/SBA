----------------------------------------------------------------
-- SBA SysCon
-- System CLK & Reset Generator
--
-- Version: 0.2
-- Date: 2015-06-03
-- SBA v1.2 compliant

-- SBA Author: Miguel A. Risco-Castillo
-- sba webpage: http://sba.accesus.com
--
--------------------------------------------------------------------------------
-- Copyright:
--
-- This code, modifications, derivate work or based upon, can not be used or
-- distributed without the complete credits on this header.
--
-- The copyright notices in the source code may not be removed or modified.
-- If you modify and/or distribute the code to any third party then you must not
-- veil the original author. It must always be clearly identifiable.
--
-- Although it is not required it would be a nice move to recognize my work by
-- adding a citation to the application's and/or research. If you use this
-- component for your research please include the appropriate credit of Author.
--
-- FOR COMMERCIAL PURPOSES REQUEST THE APPROPRIATE LICENSE FROM THE AUTHOR.
--
-- For non commercial purposes this version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity  SysCon  is
generic(PLL:boolean:=false);
port(
   CLK_I: in  std_logic;          -- External Clock input
   CLK_O: out std_logic;          -- System Clock output 
   RST_I: in  std_logic;          -- Asynchronous Reset Input
   RST_O: out std_logic           -- Synchronous Reset Output
);
end SysCon;

architecture SysCon_arch of SysCon is

   component PLLCLK               -- Configure PLL accord to Base Main Clock frequency
   port(
     POWERDOWN, CLKA  : in  std_logic;
     LOCK,GLA : out std_logic
   );
   end component PLLCLK;

   Signal CLKi : std_logic;
   Signal RSTi : std_logic;

begin

IfPLL: If PLL Generate
Signal PLLLOCKi : std_logic;
begin

  PLL_CLK : PLLCLK                -- Configure PLL accord to Base Main Clock frequency
  Port Map( 
    POWERDOWN => '1',
    LOCK      => PLLLOCKi,
    CLKA      => CLK_I,
    GLA       => CLKi
  );

  process(RST_I, PLLLOCKi, CLKi)
  begin
    if RST_I='1' or PLLLOCKi='0' then
      RSTi<='1';
    elsif rising_edge(CLKi) then
      RSTi<='0';
    end if;
  end process;

end Generate IfPLL;


IfNoPLL: If not PLL Generate
begin

  process(RST_I, CLKi)
  begin
    if RST_I='1' then
      RSTi<='1';
    elsif rising_edge(CLKi) then
      RSTi<='0';
    end if;
  end process;

CLKi  <= CLK_I;                   -- Insert a divider if is needed

end Generate IfNoPLL;

  process(RSTi,CLKi)
  begin
    if RSTi='1' then
      RST_O<='1';
    elsif rising_edge(CLKi) then
      RST_O<='0';
    end if;
  end process; 

CLK_O <= CLKi;
  
end SysCon_arch;
