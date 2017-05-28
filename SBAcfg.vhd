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
-- Based on SBA v1.1 guidelines
--
-- v1.6 2017/05/28
--
-- SBA Author: Miguel A. Risco-Castillo
-- sba webpage: http://sba.accesus.com
--
--------------------------------------------------------------------------------
-- Copyright example, you can use or modify at your convenience for your project.
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
  Subtype ADDR_type is std_logic_vector(Adr_width-1 downto 0);
  Subtype DATA_type is std_logic_vector(Dat_width-1 downto 0);

end %name%_SBAconfig;
