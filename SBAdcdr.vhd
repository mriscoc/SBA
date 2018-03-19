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
-- Copyright of the component SBA Address decoder:
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

