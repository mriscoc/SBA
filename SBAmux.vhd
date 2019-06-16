--------------------------------------------------------------------------------
-- Project Name: %name%
-- Title: %title%
-- Version: %version%
-- Date: %date%
-- Project Author: %author%
-- Description: %description%
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
use work.%name%_SBAconfig.all;

entity %name%_SBAMux  is
port(
  STB_I : in std_logic;                                -- Address Enabler
  -- ADDRESS decoder --------
  ADR_I : in ADDR_type;                                -- Address input Bus
  STB_O : out std_logic_vector(Stb_width-1 downto 0);  -- Strobe Chips selector
  -- DATA mux ---------------
  ADAT_I: in ADAT_type;                                -- Array of data buses
  DAT_O : out DATA_type                                -- Data out bus
);
end %name%_SBAMux;

architecture %name%_SBAmux_Arch of %name%_SBAMux is

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
%dcdr%     When OTHERS              => STBi <= (others =>'0');
  ------------------------------------------------------------------------------
  end case;
end process ADDRProc;

DATAProc:process (ADR_I,ADAT_I)
Variable ADRi : integer;
begin
  ADRi := to_integer(unsigned(ADR_I));
  case ADRi is
  ------------------------------------------------------------------------------
%mux%     When OTHERS              => DAT_O <= (others =>'X');
  ------------------------------------------------------------------------------
  end case;
end process DATAProc;

  STB_O <= STBi When STB_I='1' else (others=>'0');

end %name%_SBAmux_Arch;

