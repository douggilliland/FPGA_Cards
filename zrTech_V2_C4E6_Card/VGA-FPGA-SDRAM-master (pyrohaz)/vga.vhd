library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
    port(
        clk, nrst:      in std_logic;
        rgb:            out std_logic_vector(15 downto 0);
        hsync, vsync:   out std_logic;
        
        pixels:         in std_logic_vector(127 downto 0);
        pixreq:         out std_logic
    );
end vga;

architecture rtl of vga is
    constant C_HVA: integer := 640;
    constant C_HFP: integer := 16;
    constant C_HSP: integer := 96;
    constant C_HBP: integer := 48;
    constant C_HLN: integer := C_HVA+C_HFP+C_HSP+C_HBP;
    
    constant C_VVA: integer := 480;
    constant C_VFP: integer := 10;
    constant C_VSP: integer := 2;
    constant C_VBP: integer := 33;
    constant C_VLN: integer := C_VVA+C_VFP+C_VSP+C_VBP;

    type pxarray is array (0 to 7) of std_logic_vector(15 downto 0);
    
    signal hcnt, vcnt: unsigned(10 downto 0);
    signal px: pxarray;
    signal hvis, vvis: std_logic;
begin
    px(0) <= pixels(127 downto 112);
    px(1) <= pixels(111 downto 96);
    px(2) <= pixels(95 downto 80);
    px(3) <= pixels(79 downto 64);
    px(4) <= pixels(63 downto 48);
    px(5) <= pixels(47 downto 32);
    px(6) <= pixels(31 downto 16);
    px(7) <= pixels(15 downto 0);
    
    hvis <= '1' when hcnt < C_HVA else '0';
    vvis <= '1' when vcnt < C_VVA else '0';
    
    --Draw pixels during visible
    rgb <= px(to_integer(hcnt(2 downto 0))) when (hvis = '1' and vvis = '1') else (others => '0');
    
    --Request pixel once every 8
    pixreq <= '1' when (hcnt(2 downto 0) = "110" and ((hvis = '1' and vvis = '1'))) else '0';

    hsync <= '1' when hcnt < C_HVA+C_HFP or hcnt > C_HVA+C_HFP+C_HSP else '0';
    vsync <= '1' when vcnt < C_VVA+C_VFP or vcnt > C_VVA+C_VFP+C_VSP else '0';
    
    process(nrst, clk)
    begin
        if(nrst = '0') then
            hcnt <= (others => '0');
            vcnt <= (others => '0');
        elsif(rising_edge(clk)) then        
            if(hcnt = C_HLN) then
                hcnt <= (others => '0');
                if(vcnt = C_VLN) then
                    vcnt <= (others => '0');
                else
                    vcnt <= vcnt + 1;
                end if;
            else
                hcnt <= hcnt + 1;
            end if;
        end if;
    end process;
end rtl;