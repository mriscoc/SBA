# SBA
**Simple Bus Architecture**  
![](image.png) 

+ [IP Cores Library](https://github.com/mriscoc/SBA-Library)
+ [Controller Snippets](https://github.com/mriscoc/SBA-Snippets)
+ [Controller Programs](https://github.com/mriscoc/SBA-Programs)  


# **SBA Base IP Cores**

Author: Miguel A. Risco Castillo  
email: mrisco@accesus.com  
sba web page: http://sba.accesus.com  

This folder have the main and basic set of files to implement a SBA System.  

**SBA Config**  

 Constants for SBA system configuration and address map.  
 Based on SBA v1.1 guidelines  

 Release Notes:

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


**SBA Controller**  

 SBA Master System Controller v1.51
 Based on Master Controller for SBA v1.1 Guidelines  

 Release Notes:

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

 1.0.1 20100730

 v0.6.5 20080603
 * Initial release.


**SBA Decoder**
Decode the address map to generate the strobe signals.  

 Release Notes:

 v1.0 20150525
 * First version

**SBA Package**  

General functions definitions for SBA v1.1  


 Release Notes

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


**SBA SysCon**  

Allows to generate a clean system reset

 Release Notes:

 v0.2 2015-06-03
 * Merge version with and without PLL
 * Choose the PLL version using generic
 * Remove SBA_config and SBA_package dependency, not in use

 v0.1 2011-04-10
 * First version

**SBA DataIntf**  

Virtual 3-state Data Output Bus interface. 
Use to connect SBA Slave blocks to SBA controller input data bus. 
Allow to the synthesizer to inferring a bus multiplexer

 Release Notes
 
 version 1.1 20130412

 version 1.0 20091001
