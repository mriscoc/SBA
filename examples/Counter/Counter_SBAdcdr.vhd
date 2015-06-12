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
use work.Counter_SBAconfig.all;

entity Counter_SBAdecoder  is
port(
   STB_I: in std_logic;                                     -- Address Enabler
   ADR_I: in ADDR_type;                                     -- Address input Bus
   STB_O: out std_logic_vector(Stb_width-1 downto 0)        -- Strobe Chips selector 
);
end Counter_SBAdecoder;

architecture Counter_SBAdecoder_Arch of Counter_SBAdecoder is

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
     When D7S_S               => STBi <= stb(STB_D7SNX2);
     When D7S_DP              => STBi <= stb(STB_D7SNX2);
     When GPIO                => STBi <= stb(STB_GPIO);
     When OTHERS              => STBi <= (others =>'0');
  end case;

end process;

  STB_O <= STBi When STB_I='1' else (others=>'0');

end Counter_SBAdecoder_Arch;

