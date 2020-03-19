--------------------------------------------------------------------------------
-- Project Name: %name%
-- Title: %title%
-- Version: %version%
-- Date: %date%
-- Project Author: %author%
-- Description: %description%
--------------------------------------------------------------------------------
--
-- SBA Config
--
-- Constants for SBA system configuration and address map.
-- Based on SBA v1.2 guidelines
--
-- v1.9 2019/11/16
-- Added Char and Integer arrays types
--
-- SBA Author: Miguel A. Risco-Castillo
-- sba webpage: http://sba.accesus.com
--
--------------------------------------------------------------------------------
-- For License and Copyright example, you can use or modify at your convenience
-- the file SBAlicense.md for your project.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package %name%_SBAconfig is

-- System configuration
  Constant debug     : integer := 1;    -- '1' for Debug reports
  Constant Adr_width : integer := 16;   -- Width of address bus
  Constant Dat_width : integer := 16;   -- Width of data bus
  Constant Stb_width : integer := 8;    -- number of strobe signals (chip select)
  Constant sysfreq   : integer := 50e6; -- Main system clock frequency

-- Address Map
%addressmap%

--Strobe Lines
%stblines%

-- System Type definitions
  Subtype ADDR_type is std_logic_vector(Adr_width-1 downto 0); -- Address Bus type
  Subtype DATA_type is std_logic_vector(Dat_width-1 downto 0); -- Data Bus type
  type    ADAT_type is array(0 to Stb_width-1) of DATA_type;   -- Array of Data Bus
  type    AChr_type is array (natural range <>) of character;  -- Array of Chars
  type    AInt_type is array (natural range <>) of integer;    -- Array of Integers

end %name%_SBAconfig;
