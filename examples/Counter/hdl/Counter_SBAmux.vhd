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
-- SBA Mux
--
-- SBA Address Decoder and Data Mux
-- Based on SBA v1.2 guidelines
--
-- v1.1 2019/06/15
--
-- SBA Author: Miguel A. Risco-Castillo
-- sba webpage: http://sba.accesus.com
--
--------------------------------------------------------------------------------
-- For License and copyright information refer to the file:
-- https://github.com/mriscoc/SBA/blob/master/SBAlicense.md
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Counter_SBAconfig.all;

entity Counter_SBAMux  is
port(
  STB_I : in std_logic;                                -- Address Enabler
  -- ADDRESS decoder --------
  ADR_I : in ADDR_type;                                -- Address input Bus
  STB_O : out std_logic_vector(Stb_width-1 downto 0);  -- Strobe Chips selector
  -- DATA mux ---------------
  ADAT_I: in ADAT_type;                                -- Array of data buses
  DAT_O : out DATA_type                                -- Data out bus
);
end Counter_SBAMux;

architecture Counter_SBAmux_Arch of Counter_SBAMux is

Signal STBi : std_logic_vector(STB_O'range);

function stb(val:natural) return std_logic_vector is
variable ret : unsigned(Stb_width-1 downto 0);
begin
  ret:=(0 => '1', others=>'0');
  return std_logic_vector((ret sll (val)));
end;

begin

ADDRProc:process (ADR_I)
Variable ADRi : integer;
begin
  ADRi := to_integer(unsigned(ADR_I));
  case ADRi is
  ------------------------------------------------------------------------------
     When D7S_S               => STBi <= stb(STB_D7SDEX);
     When D7S_DP              => STBi <= stb(STB_D7SDEX);
     When GPIO                => STBi <= stb(STB_GPIO);
     When OTHERS              => STBi <= (others =>'0');
  ------------------------------------------------------------------------------
  end case;
end process ADDRProc;

DATAProc:process (ADR_I,ADAT_I)
Variable ADRi : integer;
begin
  ADRi := to_integer(unsigned(ADR_I));
  case ADRi is
  ------------------------------------------------------------------------------
     When GPIO                => DAT_O <= ADAT_I(STB_GPIO);
     When OTHERS              => DAT_O <= (others =>'X');
  ------------------------------------------------------------------------------
  end case;
end process DATAProc;

  STB_O <= STBi When STB_I='1' else (others=>'0');

end Counter_SBAmux_Arch;

