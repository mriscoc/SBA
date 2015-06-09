--------------------------------------------------------------------------------
--
-- Project Name: %name%
-- Title: %title%
--
-- Version: %version% %date%
-- Description: 
-- %description%
--
-- Author: %author%
--
--------------------------------------------------------------------------------
--
-- SBA Config
--
-- Constants for system configuration and address map.
-- Based on SBA v1.1 guidelines
--
-- v1.5 20150507
--
-- Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- webpage: http://mrisco.accesus.com
--
-- Notes:
--
-- v1.5 20150507
-- revert and return the type definitions from SBA_Typedef to SBA_Config
--
-- v1.4 20141210
-- Move type definitions to SBA_Typedef
-- Removed MaxStep
--
-- v1.3 20120613
-- Added the type definitions
--
-- v1.2 20120612
-- Included constants for STB lines
--
-- v1.1 20110411
-- Include constants for address map
--
-- v1.0 20101009
-- First version
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package %name%_SBAconfig is

-- System configuration
  constant debug     : integer := 1;    -- '1' for Debug reports
  constant Adr_width : integer := 3;    -- Width of address bus
  constant Dat_width : integer := 16;   -- Width of data bus
  constant Stb_width : integer := 3;    -- number of strobe signals (chip select)
  constant sysfrec   : integer := 50e6; -- Main system clock frequency

-- Address Map
--constant IPCORE1  : integer := 0;
--constant IPCORE2  : integer := 1;

--Strobe Lines
--constant STB_IPCORE1  : integer := 0;
--constant STB_IPCORE2  : integer := 1;

-- System Type definitions
  subtype ADDR_type is std_logic_vector(Adr_width-1 downto 0);
  subtype DATA_type is std_logic_vector(Dat_width-1 downto 0);

end %name%_SBAconfig;
