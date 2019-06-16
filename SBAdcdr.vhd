--------------------------------------------------------------------------------
-- Project Name: %name%
-- Title: %title%
-- Version: %version%
-- Date: %date%
-- Project Author: %author%
-- Description: %description%
--------------------------------------------------------------------------------
--
-- SBA Address Decoder  DEPRECATED
-- Decode the address map to generate the strobe signals.
-- Based in SBA_decoder v3.4
-- SBA v1.1 compliant
--
-- SBA Author: Miguel A. Risco-Castillo
-- sba webpage: http://sba.accesus.com
--
--------------------------------------------------------------------------------
-- For License and copyright information refer to the file SBAlicense.md
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.%name%_SBAconfig.all;

entity %name%_SBAdecoder  is
port(
   STB_I: in std_logic;                                     -- Address Enabler
   ADR_I: in ADDR_type;                                     -- Address input Bus
   STB_O: out std_logic_vector(Stb_width-1 downto 0)        -- Strobe Chips selector 
);
end %name%_SBAdecoder;

architecture %name%_SBAdecoder_Arch of %name%_SBAdecoder is

Signal STBi : std_logic_vector(STB_O'range);

begin

ADDRProc:process (ADR_I)

  Variable ADRi : integer;

  function stb(val:natural) return std_logic_vector is
  variable ret : unsigned(Stb_width-1 downto 0);
  begin
    ret:=(0 => '1', others=>'0');
    return std_logic_vector((ret sll (val)));
  end;

begin
  ADRi := to_integer(unsigned(ADR_I));
  case ADRi is
  ------------------------------------------------------------
%dcdr%     When OTHERS              => STBi <= (others =>'0');
  ------------------------------------------------------------
  end case;

end process;

  STB_O <= STBi When STB_I='1' else (others=>'0');

end %name%_SBAdecoder_Arch;

