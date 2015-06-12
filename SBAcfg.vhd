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
-- SBA Config
--
-- Constants for SBA system configuration and address map.
-- Based on SBA v1.1 guidelines
--
-- v1.5 20150507
--
-- Author: Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- webpage: http://mrisco.accesus.com
-- sba webpage: http://sba.accesus.com
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
-- Copyright:
--
-- This code, modifications, derivate work or based upon, can not be used or
-- distributed without the complete credits on this header.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please include the appropriate
-- credit of Author.
--
-- The code may not be included into ip collections and similar compilations
-- which are sold. If you want to distribute this code for money then contact me
-- first and ask for my permission.
--
-- These copyright notices in the source code may not be removed or modified.
-- If you modify and/or distribute the code to any third party then you must not
-- veil the original author. It must always be clearly identifiable.
--
-- Although it is not required it would be a nice move to recognize my work by
-- adding a citation to the application's and/or research.
--
-- FOR COMMERCIAL PURPOSES REQUEST THE APPROPRIATE LICENSE FROM THE AUTHOR.
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
  Constant sysfrec   : integer := 50e6; -- Main system clock frequency

-- Address Map
%addressmap%

--Strobe Lines
%stblines%

-- System Type definitions
  Subtype ADDR_type is std_logic_vector(Adr_width-1 downto 0);
  Subtype DATA_type is std_logic_vector(Dat_width-1 downto 0);

end %name%_SBAconfig;
