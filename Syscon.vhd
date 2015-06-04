----------------------------------------------------------------
-- SBA SysCon
-- System CLK & Reset Generator
--
-- Version: 0.2
-- Date: 2015-06-03
-- Author: Miguel A. Risco-Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
-- sba webpage: http://sba.accesus.com
--
-- This code, modifications, derivate
-- work or based upon, can not be used
-- or distributed without the
-- complete credits on this header and
-- the consent of the author.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please
-- include the appropriate credit of Author.
--
-- For commercial purposes request the appropriate
-- license from the author.
--
--
-- Notes:
--
-- v0.2 2015-06-03
-- Merge version with and without PLL
-- Choose the PLL version using generic
-- Remove SBA_config and SBA_package, not in use
--
-- v0.1 2011-04-10
-- First version
--
----------------------------------------------------------------

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
