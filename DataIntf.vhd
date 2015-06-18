--------------------------------------------------------------------------------
-- SBA DataIntf
--
-- Virtual 3-state Data Output Bus interface
-- Used to connect SBA Slave blocks to SBA controller input data bus
-- Allow to the synthesizer to inferring a bus multiplexer
--
-- version 1.1 20130412
--
-- Author: Miguel A. Risco Castillo
-- webpage: http://mrisco.accesus.com
-- sba webpage: http://sba.accesus.com
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

entity  DataIntf  is
port(
   STB_I: in  std_logic;           -- Strobe input Chip selector
   DAT_I: in  std_logic_vector;    -- Data Bus from slave       
   DAT_O: out std_logic_vector     -- output Data Bus to master
);
end DataIntf;

architecture DataIntf_Arch of DataIntf is
begin
  DAT_O <= DAT_I when STB_I='1' else (DAT_O'Range=>'Z');
end DataIntf_Arch;