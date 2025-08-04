@echo off
REM Run simulation using GHDL and GTKWave
REM (c) Miguel Risco-Castillo
REM v1.0 2025-08-03

if [%1]==[] goto help

echo Analyzing VHDL files...
ghdl --remove
if exist work-*.cf del work-*.cf
ghdl -a --work=work %1_SBAcfg.vhd
ghdl -a --work=work .\lib\*.vhd
ghdl -a --work=work *.vhd
ghdl -a --work=work .\tb\tb.vhd
if %ERRORLEVEL% NEQ 0 goto error

echo Elaborating testbench...
ghdl -e --work=work testbench
if %ERRORLEVEL% NEQ 0 goto error

echo Running simulation...
ghdl -r testbench --vcd=.\tb\tb.vcd --stop-time=5us

echo Opening GTKWave with saved configuration...
gtkwave .\tb\tb.vcd .\tb\tb.gtkw
goto exit

:error
echo There are some errors in your vhdl files.
REM exit %ERRORLEVEL%
goto exit

:help
echo Usage:
echo run_sim [proyect_name]

:exit