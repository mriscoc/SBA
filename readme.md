SBA
===
**Simple Bus Architecture**  

![](image.png)

+ [SBA System Creator](http://sba.accesus.com/software-tools/sba-creator)
+ [IP Cores Library](http://sbalibrary.accesus.com)
+ [Controller Programs](http://sbaprograms.accesus.com)
+ [Controller Snippets](http://sbasnippets.accesus.com)

SBA Base IP Cores
=================

SBA v1.2 compliant

Author: Miguel A. Risco Castillo  
sba web page: <http://sba.accesus.com>

This repository have the main and basic set of templates to implement a SBA System.  

--------------------------------------------------------------------------------

Top (Top.vhd)
-------------
This is the main file and it is at the top of the hierarchical structure  

 Release Notes:  

v1.8 2019/06/15  
* Update license information  
 

SBA Config (SBAcfg.vhd)
-----------------------

 Package with constants for SBA system configuration and address map.  
 Based on SBA v1.2 guidelines

 Release Notes:

v1.9 2019/11/16
* Added Char and Integer arrays types 

v1.8 2019/06/15
* Update license information

v1.7 2018/03/18  
* SBAv1.2 compliant

v1.6 2017/05/28  
* Change sysfrec to sysfreq

v1.5 20150507
* revert and return the type definitions from SBA_Typedef to SBA_Config

v1.4 20141210
* Move type definitions to SBA_Typedef
* Removed MaxStep

v1.3 20120613
* Added the type definitions

v1.2 20120612
* Included constants for STB lines

v1.1 20110411
* Include constants for address map

v1.0 20101009
* First version

--------------------------------------------------------------------------------

SBA Controller (SBActrlr.vhd)
-----------------------------

 SBA Master System Controller v1.51
 Based on Master Controller for SBA v1.1 Guidelines  

 Release Notes:

v1.70 2019/06/15
* Update license information
* Added support for multisubroutines

v1.60 2017/05/24  
* Added interrupt support

v1.53 20170510
* Added SBAWrite with integer data argument

v1.52 20151016
* Cosmetics changes
* Alias added
* Update version number
* Template formatting

v1.51 20150509
* Address always will be of type integer, then the functions to support
  read and write of unsigned address were removed.
* Rename some signal to follow SBA1.1 design guides:
  signals in uppercase, ending with lowercase i for internal signals.
* Remove the range limitations of integer variables (the synthesis
  optimization phase will truncate integers according to the necessary bits.
* Added Signatures '-- SBA:' for Easy editing in SBA System Creator

v1.50 20141211
* change some more variables to signals
* remove cal variable
* make compatible with pre SBA v1.1
* Add SBAjump function (jump to some step)

v1.47 20110331
* Move step, ret and address variables to signals to improve performance and area. Restore ACK_I functionality

v1.46 20101015
* Implement SBAwait for freeze Bus values;
* Restore STB_O functionality

v1.45 20101015

v1.0.1 20100730

v0.6.5 20080603
* Initial release.

```vhdl
entity %name%_SBAcontroller  is
port(
   RST_I : in std_logic;                     -- active high reset
   CLK_I : in std_logic;                     -- main clock
   DAT_I : in std_logic_vector;              -- Data input Bus
   DAT_O : out std_logic_vector;             -- Data output Bus
   ADR_O : out std_logic_vector;             -- Address output Bus
   STB_O : out std_logic;                    -- Strobe enabler
   WE_O  : out std_logic;                    -- Write / Read
   ACK_I : in  std_logic;                    -- Strobe Acknowledge
   INT_I : in  std_logic                     -- Interrupt request
);
end %name%_SBAcontroller;
```

--------------------------------------------------------------------------------

SBA Mux (SBAmux.vhd)
--------------------

Decode the address map to generate the strobe signals.
Generate the data multiplexers.

Release Notes:

v1.1 2019/06/15
* Update license information

v1.0 2018/03/18
* First version

```vhdl
entity %name%_SBAMux  is
port(
  STB_I : in std_logic;                                -- Address Enabler
  -- ADDRESS decoder --------
  ADR_I : in ADDR_type;                                -- Address input Bus
  STB_O : out std_logic_vector(Stb_width-1 downto 0);  -- Strobe Chips selector
  -- DATA mux ---------------
  ADAT_I: in ADAT_type;                                -- Array of data buses
  DAT_O : out DATA_type                                -- Data out bus
);
end %name%_SBAMux;
```

--------------------------------------------------------------------------------

SBA Package (SBApkg.vhd)
------------------------

Package with general functions definitions for SBA v1.1  

Release Notes

v5.5 2019/08/04  
* Implemented MAXIMUM and MINIMUM functions for unsigned and signed values 

v5.4 2019/06/15  
* Update license information  

v5.3 2017/01/03
* revert v5.2, removing functions for signals  

v5.1 20151129   
* minor correction: add integer range disambiguation to udiv function to avoid GHDL warning, release notes reposition in source file.  

v5.0 20150528   
* added unsigned and integer division

v4.9 20121107   
* added Trailing function

v4.8 20120824   
* added random n bits vector and integer number generator functions.

v4.7 20120613   
* removed the stb function and type definitions

v4.6 20111125
* minor change on function hex (resize of result)

v4.5 20110616
* minor change on function stb

v4.4 20110411
* added inc and dec procedures for integers

v4.3 20101118
* added Greatest common divisor function

v4.2 20101019
* change stb() function for Xilinx ISE compatibility

v4.1 20101019
* add internal Data Type to unsigned

v4.0 20101009
* Transfer config values to SBA_config package
* Added multiple conversion functions

v3.5 20100917

v3.0 20100812

v2.3 20091111

v2.2 20091024

v2.0 20091021

v1.2 20081101

```vhdl
package SBApackage is

  function udiv(a:unsigned;b:unsigned) return unsigned;
  function sdiv(a:signed;b:signed) return signed;
  function trailing(slv:std_logic_vector;len:positive;value:std_logic) return std_logic_vector;
  function rndv(n:natural) return std_logic_vector;
  function rndi(n:integer) return integer;
  function chr2uns(chr: character) return unsigned;
  function chr2int(chr: character) return integer;
  function chr(uns: unsigned) return character;
  function chr(int: integer) return character;
  function hex2uns(hex: unsigned) return unsigned;
  function hex(uns: unsigned) return unsigned;
  function hex(int: integer) return integer;
  function hex(int: integer) return character;
  function int2str(int: integer) return string;
  function gcd(dat1,dat2:integer) return integer;  -- Greatest common divisor
  procedure clr(signal val: inout std_logic_vector);
  procedure clr(variable val:inout unsigned);
  procedure inc(signal val:inout std_logic_vector);
  procedure inc(variable val:inout unsigned);
  procedure inc(variable val:inout integer);
  procedure dec(signal val:inout std_logic_vector);
  procedure dec(variable val:inout unsigned);
  procedure dec(variable val:inout integer);
  function MAXIMUM(a:unsigned;b:unsigned) return unsigned;
  function MINIMUM(a:unsigned;b:unsigned) return unsigned;
  function MAXIMUM(a:signed;b:signed) return signed;
  function MINIMUM(a:signed;b:signed) return signed;

end SBApackage; 
```
--------------------------------------------------------------------------------

SBA SysCon (Syscon.vhd)
-----------------------

Allows to generate a clean system reset

Release Notes:

v1.1 2019/06/15
* Update license information
* Remove PLL support

v0.2 2015-06-03
* Merge version with and without PLL
* Choose the PLL version using generic
* Remove SBA_config and SBA_package dependency

v0.1 2011-04-10
* First version

```vhdl
entity  SysCon  is
generic(PLL:boolean:=false);
port(
   CLK_I: in  std_logic;          -- External Clock input
   CLK_O: out std_logic;          -- System Clock output 
   RST_I: in  std_logic;          -- Asynchronous Reset Input
   RST_O: out std_logic           -- Synchronous Reset Output
);
end SysCon;
```
--------------------------------------------------------------------------------

SBA Data Interface (DataIntf.vhd) `Deprecated`
----------------------------------------------

Virtual 3-state Data Output Bus interface. 
Use to connect SBA Slave blocks to SBA controller input data bus. 
Allow to the synthesizer to inferring a bus multiplexer

Release Notes
 
v1.2 2019/06/15
* Update license information

version 1.1 2013/04/12

version 1.0 2009/10/01

```vhdl
entity  DataIntf  is
port(
   STB_I: in  std_logic;           -- Strobe input Chip selector
   DAT_I: in  std_logic_vector;    -- Data Bus from slave       
   DAT_O: out std_logic_vector     -- output Data Bus to master
);
end DataIntf;
```
--------------------------------------------------------------------------------

SBA Decoder (SBAdcdr.vhd) `Deprecated`
--------------------------------------

Decode the address map to generate the strobe signals.  

Release Notes:

v3.4 2019/06/15
* Update license information

v1.0 20150525
* First version

```vhdl
entity %name%_SBAdecoder  is
port(
   STB_I: in std_logic;                                     -- Address Enabler
   ADR_I: in ADDR_type;                                     -- Address input Bus
   STB_O: out std_logic_vector(Stb_width-1 downto 0)        -- Strobe Chips selector 
);
end %name%_SBAdecoder;
```
