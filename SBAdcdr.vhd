--------------------------------------------------------------------------------
--
-- Project Name: %name%
-- Title: %title%
-- Version: %version%
-- Date: %date%
-- Author: %author%
-- Description: %description%
--------------------------------------------------------------------------------
--
-- SBA Address Decoder
-- based in SBA_decoder v3.4
--
-- (c) 2008-2015 Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- sba web page: http://sba.accesus.com
--
-- Release Notes:
--
-- v1.0 20150525
-- First version
--
-- This code, modifications, derivate work or based upon, can not be used or
-- distributed without the complete credits on this header.
--
-- if you use this code for your research please include the appropriate credit
-- of Author.
--
-- For commercial purposes request the appropriate license from the author.
--
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
%dcdr%     When OTHERS              => STBi <= (others =>'0');
  end case;

end process;

  STB_O <= STBi When STB_I='1' else (others=>'0');

end %name%_SBAdecoder_Arch;

