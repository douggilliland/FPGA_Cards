library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdramctrl is
    generic(
        CLK_FREQ: integer
    );
    port(
        clk, nrst:      in std_logic;
        
        en, wr:         in std_logic;
        di:             in std_logic_vector(127 downto 0);
        addr:           in std_logic_vector(20 downto 0);
        do:             out std_logic_vector(127 downto 0);
        bsy:            out std_logic;
        
        sclk, scke:     out std_logic;
        scs, swe:       out std_logic;
        scas, sras:     out std_logic;
        saddr:          out std_logic_vector(12 downto 0);
        sdata:          inout std_logic_vector(15 downto 0);
        sba:            out std_logic_vector(1 downto 0);
        sdqm:           out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of sdramctrl is
    type states is (
        INITW, INITPC, INITMR, 
        SELFREFRESH, SELFREFRESHW, 
        IDLE, 
        ACTIVATEA,
        PRECHARGE, 
        SREADA, SREADB1, SREADB2, SREADB3, SREADB4, SREADB5, SREADB6, SREADB7, SREADB8,
        SWRITEA, SWRITEB1, SWRITEB2, SWRITEB3, SWRITEB4, SWRITEB5, SWRITEB6, SWRITEB7, SWRITEB8,
        DELAY);
    
    --Cycles per refresh command (7us)
    constant REFRESH_DELAY: unsigned(9 downto 0) := to_unsigned(700, 10);
    
    --Init delay cycles (201us)
    constant INIT_DELAYMAX: unsigned(15 downto 0) := to_unsigned(20100, 16);
    --constant INIT_DELAYMAX: unsigned(15 downto 0) := to_unsigned(201, 16);
    
    signal nst, st, pst: states;
    
    --Refresh counters
    signal rfdlyc: unsigned(9 downto 0);
    signal refreq: std_logic;
    
    signal waddr: std_logic_vector(23 downto 0);
    
    signal dlyc: unsigned(15 downto 0);
    signal idata, odata: std_logic_vector(127 downto 0);
    signal iwr: std_logic;
    
begin
    sclk <= clk;
    
    do <= odata;

    process(clk, nrst)
    begin
        if(nrst = '0') then
            scke <= '0';
            scs <= '1';
            swe <= '1';
            scas <= '1';
            sras <= '1';
            saddr <= (others => '0');
            sdata <= (others => 'Z');
            sba <= "00";
            sdqm <= "00";
            dlyc <= INIT_DELAYMAX;
            rfdlyc <= (others => '1');
            bsy <= '1';
            st <= INITW;
            
        elsif(rising_edge(clk)) then
            --Refresh counter
            if(rfdlyc = 0) then
                refreq <= '1';
            else
                rfdlyc <= rfdlyc - 1;
                refreq <= '0';
            end if;
            
            case st is
            when INITW =>
                bsy <= '1';
                scke <= '1';
                sdqm <= "11";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                if(dlyc = 0) then
                    st <= INITPC;
                else
                    dlyc <= dlyc - 1;
                end if;
                
            when INITPC =>
                scke <= '1';
                saddr(10) <= '1';
                scs <= '0';
                sras <= '0';
                scas <= '1';
                swe <= '0';
                
                --Precharge delay
                dlyc <= to_unsigned(2, 16);
                st <= DELAY;
                nst <= INITMR;
                
            when INITMR =>
                sras <= '0';
                scas <= '0';
                scs <= '0';
                swe <= '0';
                
                --Burst length 8
                saddr(2 downto 0) <= "011";
                --Sequential addressing mode
                saddr(3) <= '0';
                --CAS latency of 3
                saddr(6 downto 4) <= "011";
                --Reserved
                saddr(8 downto 7) <= "00";
                --Burst read and burst write
                saddr(9) <= '0';
                --Reserved
                saddr(12 downto 10) <= "000";
                sba <= "00";
                st <= DELAY;
                nst <= SELFREFRESH;
                dlyc <= to_unsigned(2, 16);
                    
            when SELFREFRESH =>
                sras <= '0';
                scas <= '0';
                scs <= '0';
                swe <= '1';
                scke <= '0';
                st <= SELFREFRESHW;
                nst <= IDLE;
                dlyc <= to_unsigned(8+1, 16);
                
            when SELFREFRESHW =>
                if(dlyc = 0) then
                    st <= nst;
                    rfdlyc <= REFRESH_DELAY;
                    refreq <= '0';
                else
                    dlyc <= dlyc - 1;
                end if;
                
            when IDLE =>
                scke <= '1';
                sdqm <= "11";
                sras <= '1';
                scas <= '1';
                scs <= '0';
                swe <= '1';
                bsy <= '0';
                sdata <= (others => 'Z');
                
                --All user state machines should wait for busy rising edge (to latch command)
                if(refreq = '1') then
                    st <= SELFREFRESH;
                elsif(en = '1') then
                    bsy <= '1';
                    waddr <= addr&"000";
                    idata <= di;
                    
                    st <= ACTIVATEA;
                    iwr <= wr;
                end if;
                
            when ACTIVATEA =>
                scke <= '1';
                sras <= '0';
                scas <= '1';
                scs <= '0';
                swe <= '1';
                
                sba <= waddr(23 downto 22);
                saddr <= waddr(21 downto 9);
                
                st <= DELAY;
                if(iwr = '0') then
                    nst <= SREADA;
                else
                    nst <= SWRITEA;
                end if;
                
                dlyc <= to_unsigned(1, 16);
                
            when SREADA =>
                scke <= '1';
                sras <= '1';
                scas <= '0';
                scs <= '0';
                swe <= '1';
                
                sdata <= (others => 'Z');
                saddr(12 downto 9) <= "0000";
                saddr(8 downto 0) <= waddr(8 downto 0);
                st <= DELAY;
                nst <= SREADB1;
                --CAS2
                --dlyc <= to_unsigned(1, 16);
                
                --CAS3
                dlyc <= to_unsigned(2, 16);
            

            when SREADB1 =>
                --NOP
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= (others => 'Z');
                saddr(10) <= '0';
                odata(127 downto 112) <= sdata;
                
                st <= SREADB2;
                
            when SREADB2 =>
                --NOP
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= (others => 'Z');
                saddr(10) <= '0';
                odata(111 downto 96) <= sdata;
                
                st <= SREADB3;
                
            when SREADB3 =>
                --NOP
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= (others => 'Z');
                saddr(10) <= '0';
                odata(95 downto 80) <= sdata;
                
                st <= SREADB4;
                
            when SREADB4 =>
                --NOP
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= (others => 'Z');
                saddr(10) <= '0';
                odata(79 downto 64) <= sdata;
                
                st <= SREADB5;
                
            when SREADB5 =>
                --NOP
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= (others => 'Z');
                saddr(10) <= '0';
                odata(63 downto 48) <= sdata;
                
                st <= SREADB6;
                
            when SREADB6 =>
                --NOP
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= (others => 'Z');
                saddr(10) <= '0';
                odata(47 downto 32) <= sdata;
                
                st <= SREADB7;
                
            when SREADB7 =>
                --NOP
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= (others => 'Z');
                saddr(10) <= '0';
                odata(31 downto 16) <= sdata;
                
                st <= SREADB8;
            
            when SREADB8 =>
                --Precharge bank and grab data
                scke <= '1';
                sras <= '0';
                scas <= '1';
                scs <= '0';
                swe <= '0';
                
                sdata <= (others => 'Z');
                saddr(10) <= '0';
                odata(15 downto 0) <= sdata;
                
                st <= DELAY;
                dlyc <= to_unsigned(2, 16);
                nst <= IDLE;                
                
            when SWRITEA =>
                scke <= '1';
                sras <= '1';
                scas <= '0';
                scs <= '0';
                swe <= '0';
                sdqm <= "00";
                
                sdata <= idata(127 downto 112);
                --sdata <= idata(31 downto 16);
                
                saddr(12 downto 9) <= "0000";
                saddr(8 downto 0) <= waddr(8 downto 0);
                st <= SWRITEB1;
                
            when SWRITEB1 =>
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= idata(111 downto 96);
                
                saddr(12 downto 9) <= "0000";
                saddr(8 downto 0) <= waddr(8 downto 0);
                st <= SWRITEB2;
                
            when SWRITEB2 =>
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= idata(95 downto 80);
                
                saddr(12 downto 9) <= "0000";
                saddr(8 downto 0) <= waddr(8 downto 0);
                st <= SWRITEB3;
                
            when SWRITEB3 =>
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= idata(79 downto 64);
                
                saddr(12 downto 9) <= "0000";
                saddr(8 downto 0) <= waddr(8 downto 0);
                st <= SWRITEB4;
                
            when SWRITEB4 =>
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= idata(63 downto 48);
                
                saddr(12 downto 9) <= "0000";
                saddr(8 downto 0) <= waddr(8 downto 0);
                st <= SWRITEB5;
                
            when SWRITEB5 =>
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= idata(47 downto 32);
                
                saddr(12 downto 9) <= "0000";
                saddr(8 downto 0) <= waddr(8 downto 0);
                st <= SWRITEB6;
                
            when SWRITEB6 =>
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= idata(31 downto 16);
                
                saddr(12 downto 9) <= "0000";
                saddr(8 downto 0) <= waddr(8 downto 0);
                st <= SWRITEB7;
                
            when SWRITEB7 =>
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                
                sdata <= idata(15 downto 0);
                
                saddr(12 downto 9) <= "0000";
                saddr(8 downto 0) <= waddr(8 downto 0);
                st <= SWRITEB8;
                
            when SWRITEB8 =>
                --Precharge banks
                scke <= '1';
                sras <= '0';
                scas <= '1';
                scs <= '0';
                swe <= '0';
                
                saddr(10) <= '0';
                
                st <= DELAY;
                dlyc <= to_unsigned(2, 16);
                nst <= IDLE;     
                
            when DELAY =>
                --Do NOP
                scke <= '1';
                sdqm <= "00";
                scs <= '0';
                sras <= '1';
                scas <= '1';
                swe <= '1';
                --sdata <= (others => 'Z');
                
                if(dlyc = 0) then
                    st <= nst;
                else
                    dlyc <= dlyc - 1;
                end if;
                
            when others => null;
            end case;
            
            
        end if;
    end process;
end rtl;