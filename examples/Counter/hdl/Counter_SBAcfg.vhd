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
--
-- SBA Config
--
-- Constants for SBA system configuration and address map.
-- Based on SBA v1.2 guidelines
--
-- v1.8 2019/06/15
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

package Counter_SBAconfig is

-- System configuration
  Constant debug     : integer := 1;    -- '1' for Debug reports
  Constant Adr_width : integer := 16;   -- Width of address bus
  Constant Dat_width : integer := 16;   -- Width of data bus
  Constant Stb_width : integer := 8;    -- number of strobe signals (chip select)
  Constant sysfreq   : integer := 50e6; -- Main system clock frequency

-- Address Map
  Constant D7S_S      : integer := 0;
  Constant D7S_DP     : integer := 1;
  Constant GPIO       : integer := 2;


--Strobe Lines
  Constant STB_D7SDEX : integer := 0;
  Constant STB_GPIO   : integer := 1;


-- System Type definitions
  Subtype ADDR_type is std_logic_vector(Adr_width-1 downto 0); -- Address Bus type
  Subtype DATA_type is std_logic_vector(Dat_width-1 downto 0); -- Data Bus type
  type    ADAT_type is array(0 to Stb_width-1) of DATA_type;   -- Array of Data Bus

end Counter_SBAconfig;
