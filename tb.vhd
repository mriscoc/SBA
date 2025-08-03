--------------------------------------------------------------------------------
-- Title: Testbench for %name%_Top
-- Version: 0.1.0
-- Date: 2025/08/02
-- Description: Testbench for %name%_Top entity with 10 MHz clock simulation
--------------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.%name%_SBAconfig.all;

entity testbench is
end testbench;

architecture behavioral of testbench is

    -- Clock period for 10 MHz (100 ns)
    constant CLK_PERIOD : time := 100 ns;

    -- Testbench signals
    signal clk_i_tb   : std_logic := '0';
    signal rst_i_tb   : std_logic := '1';  -- Start with reset active

    -- Clock counter for reset timing
    signal clk_count  : integer := 0;

begin

    -- Unit Under Test (UUT)
    uut: entity work.%name%_Top
    port map (
        CLK_I => clk_i_tb,
        RST_I => rst_i_tb
    );

    -- Clock generation process (10 MHz)
    clk_process: process
    begin
        clk_i_tb <= '0';
        wait for CLK_PERIOD/2;
        clk_i_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Clock counter process
    clk_counter: process(clk_i_tb)
    begin
        if rising_edge(clk_i_tb) then
            clk_count <= clk_count + 1;
        end if;
    end process;

    -- Reset control process
    reset_process: process
    begin
        -- Keep reset active for 3 clock cycles
        rst_i_tb <= '1';
        wait until rising_edge(clk_i_tb);
        wait until rising_edge(clk_i_tb);
        wait until rising_edge(clk_i_tb);

        -- Release reset
        rst_i_tb <= '0';
        wait;
    end process;

    -- Stimulus process
    stim_process: process
    begin

        -- Wait for reset to be released
        wait until rst_i_tb = '0';

        -- Wait for a few more clock cycles to observe behavior
        for i in 0 to 10 loop
            wait until rising_edge(clk_i_tb);
        end loop;


        -- End simulation
        wait for 2 us;

        report "Simulation completed successfully" severity note;
        wait;
    end process;

end behavioral;
