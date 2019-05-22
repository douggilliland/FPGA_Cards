library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rsthandler is
    port(
        clk, nrsti: in std_logic;
        nrsto:      out std_logic
    );
end entity;

architecture rtl of rsthandler is
    signal cnt: unsigned(19 downto 0);
begin
    nrsto <= '1' when cnt = x"FFFFF" else '0';
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(nrsti = '0') then
                cnt <= (others => '0');
            elsif(cnt /= x"FFFFF") then
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
end rtl;