--------------------------------------------------------------------------------
--
-- SBA Address Decoder
-- for BeCoS Demo - SBA Implementation
-- based in SBA_decoder v3.4
--
-- Version: 1.0 20150528
--
-- Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web: http://sba.accesus.com
--
-- Release Notes:
--
-- v1.0 First version 
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
use work.BeCoS_sba_config.all;

entity  BeCoS_SBA_decoder  is
port(
   STB_I: in std_logic;                                     -- Address Enabler
   ADR_I: in ADDR_type;                                     -- Address input Bus
   STB_O: out std_logic_vector(Stb_width-1 downto 0)        -- Strobe Chips selector 
);
end BeCoS_SBA_decoder;

architecture BeCoS_SBA_decoder_Arch of BeCoS_SBA_decoder is

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
     When RAM0 to RAM0+255        => STBi <= stb(STB_RAM0);  -- RAM0, (x000 - x0FF)
     When RAM1 to RAM1+255        => STBi <= stb(STB_RAM1);  -- RAM1, (x100 - x1FF)
     When OTHERS                  => STBi <= (others =>'0');
  end case;

end process;

  STB_O <= STBi When STB_I='1' else (others=>'0');

end BeCoS_SBA_decoder_Arch;

