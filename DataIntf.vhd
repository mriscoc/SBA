--------------------------------------------------------------------------------
-- SBA DataIntf
--
-- Virtual 3-state Data Output Bus interface
-- Used to connect SBA Slave blocks to SBA controller input data bus
-- Allow to the synthesizer to inferring a bus multiplexer
--
-- version 1.2 2019/06/15
-- SBA v1.1 compliant
--
-- SBA Author: Miguel A. Risco Castillo
-- sba webpage: http://sba.accesus.com
--
--------------------------------------------------------------------------------
-- For License and copyright information refer to the file:
-- https://github.com/mriscoc/SBA/blob/master/SBAlicense.md
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
