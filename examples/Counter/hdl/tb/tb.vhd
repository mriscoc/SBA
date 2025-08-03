--------------------------------------------------------------------------------
-- Title: Testbench for Counter_Top
-- Version: 0.1.0
-- Date: 2025/08/02
-- Description: Testbench for Counter_Top entity with 10 MHz clock simulation
--------------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.Counter_SBAconfig.all;

entity testbench is
end testbench;

architecture behavioral of testbench is

    -- Clock period for 10 MHz (100 ns)
    constant CLK_PERIOD : time := 100 ns;

    -- Testbench signals
    signal clk_i_tb   : std_logic := '0';
    signal rst_i_tb   : std_logic := '0';  -- Start with reset active (low)
    signal sw_tb      : std_logic_vector(7 downto 0) := (others => '0');
    signal hex0_tb    : std_logic_vector(7 downto 0);
    signal hex1_tb    : std_logic_vector(7 downto 0);
    signal hex2_tb    : std_logic_vector(7 downto 0);
    signal hex3_tb    : std_logic_vector(7 downto 0);
    signal ledr_tb    : std_logic_vector(9 downto 0);

    -- Clock counter for reset timing
    signal clk_count  : integer := 0;

begin

    -- Unit Under Test (UUT)
    uut: entity work.Counter_Top
    port map (
        CLK_I => clk_i_tb,
        RST_I => rst_i_tb,
        HEX0  => hex0_tb,
        HEX1  => hex1_tb,
        HEX2  => hex2_tb,
        HEX3  => hex3_tb,
        SW    => sw_tb,
        LEDR  => ledr_tb
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
        -- Keep reset active (low) for 3 clock cycles
        rst_i_tb <= '0';
        wait until rising_edge(clk_i_tb);
        wait until rising_edge(clk_i_tb);
        wait until rising_edge(clk_i_tb);

        -- Release reset (set to high)
        rst_i_tb <= '1';
        wait;
    end process;

    -- Stimulus process
    stim_process: process
    begin
        -- Keep SW at 0 as requested
        sw_tb <= (others => '0');

        -- Wait for reset to be released
        wait until rst_i_tb = '1';

        -- Wait for a few more clock cycles to observe behavior
        for i in 0 to 10 loop
            wait until rising_edge(clk_i_tb);
        end loop;

        -- Optional: Test with different SW values
        -- sw_tb <= "00000001";
        -- wait for 1 us;
        -- sw_tb <= "11111111";
        -- wait for 1 us;
        -- sw_tb <= (others => '0');

        -- End simulation
        wait for 2 us;

        report "Simulation completed successfully" severity note;
        wait;
    end process;

end behavioral;
