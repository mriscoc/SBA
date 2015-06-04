# **SBA Base IP Cores**
- - - 
![](image.png)   

Author: Miguel A. Risco Castillo  
email: mrisco@accesus.com  
sba web page: http://sba.accesus.com  

This folder have the main and basic set of files to implement a SBA System.  

**SBA Config**  
Main configuration file  

**SBA Controller**  
Master SBA core, organize all data flux.  

**SBA Decoder**
Decode the address map to generate the strobe signals.  

**SBA Package**  
Package with useful functions.  

**SBA SysCon**  

Allows to generate a clean system reset

**SBA DataIntf**  

Virtual 3-state Data Output Bus interface. 
Use to connect SBA Slave blocks to SBA controller input data bus. 
Allow to the synthesizer to inferring a bus multiplexer


