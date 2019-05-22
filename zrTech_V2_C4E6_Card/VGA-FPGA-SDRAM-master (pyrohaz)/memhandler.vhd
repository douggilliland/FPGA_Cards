library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memhandler is
    port(
        clk, nrst:      in std_logic;
        
        en, wr:         out std_logic;
        di:             in std_logic_vector(127 downto 0);
        addr:           out std_logic_vector(20 downto 0);
        do:             out std_logic_vector(127 downto 0);
        bsy:            in std_logic;
        
        pixels:         out std_logic_vector(127 downto 0);
        pixreq:         in std_logic;
        vsync:          in std_logic;
        
        rseg:           out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of memhandler is
    type states is (SIDLE, SREAD, SREADW, SINITW, SINITWW);
    signal st: states;
    signal bsyo, pxo, pxo1: std_logic;
    signal acnt: unsigned(20 downto 0);
    signal dcnt: unsigned(15 downto 0);
    signal dreq: std_logic;
begin
    process(clk, nrst)
    begin
        if(nrst = '0') then
            bsyo <= '1';
            pxo <= '0';
            pxo1 <= '0';
            st <= SINITW;
            acnt <= (others => '0');
            dcnt <= (others => '0');
            en <= '0';
            wr <= '0';
            do <= (others => '0');
            addr <= (others => '0');
            rseg <= x"1D1E";
            dreq <= '1';
        elsif(rising_edge(clk)) then
            bsyo <= bsy;
            pxo1 <= pixreq;
            pxo <= pxo1;
            
            if(pxo = '0' and pxo1 = '1') then
                dreq <= '1';
            end if;
            
            case st is
            when SINITW =>
                rseg <= x"1D1E";
                if(bsy = '0' and bsyo = '0') then
                    en <= '1';
                    wr <= '1';
                    addr <= std_logic_vector(acnt);
                    do <= std_logic_vector(dcnt&dcnt&dcnt&dcnt&dcnt&dcnt&dcnt&dcnt);
                elsif(bsy = '1' and bsyo = '0') then
                    en <= '0';
                    st <= SINITWW;
                end if;
            
            when SINITWW =>
                if(bsy = '0' and bsyo = '0') then
                    if(acnt = 640*480/8) then
                        st <= SIDLE;
                        acnt <= (others => '0');
                    else
                        acnt <= acnt + 1;
                        dcnt <= dcnt + 1;
                        st <= SINITW;
                    end if;
                end if;
                
            when SIDLE =>
                if(dreq = '1') then
                    dreq <= '0';
                    st <= SREAD;
                elsif(vsync = '0') then
                    acnt <= (others => '0');
                end if;
                
            when SREAD =>
                if(bsy = '0' and bsyo = '0') then
                    en <= '1';
                    wr <= '0';
                    addr <= std_logic_vector(acnt);
                elsif(bsy = '1' and bsyo = '0') then
                    en <= '0';
                    st <= SREADW;
                    acnt <= acnt + 1;
                end if;
                
            when SREADW =>
                if(bsy = '0' and bsyo = '0') then
                    pixels <= di;
                    rseg <= di(15 downto 0);
                    st <= SIDLE;
                end if;
            end case;
        end if;
    end process;
end rtl;