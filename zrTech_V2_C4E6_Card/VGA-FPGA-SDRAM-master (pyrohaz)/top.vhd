library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity top is
    port(
        clk, nrsti:     in std_logic;
        
        sclk, scke:     out std_logic;
        scs, swe:       out std_logic;
        scas, sras:     out std_logic;
        saddr:          out std_logic_vector(12 downto 0);
        sdata:          inout std_logic_vector(15 downto 0);
        sba:            out std_logic_vector(1 downto 0);
        sdqm:           out std_logic_vector(1 downto 0);
        
        seg7en:		    out std_logic_vector(3 downto 0);
		seg7c:		    out std_logic_vector(6 downto 0);
        
        hsync, vsync:   out std_logic;
        rgb:            out std_logic_vector(15 downto 0);
        pxr, bsyp:      out std_logic
    );
end entity;

architecture rtl of top is
    component seg7 is
	port(
		clk, nrst:  in std_logic;
    
        rseg1:      in std_logic_vector(15 downto 0);
		seg7en:		out std_logic_vector(3 downto 0);
		seg7c:		out std_logic_vector(6 downto 0)
	);
    end component;
    
    component rsthandler is
    port(
        clk, nrsti: in std_logic;
        nrsto:      out std_logic
    );
    end component;
    
    component sdramctrl is
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
    end component;
    
    component memhandler is
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
    end component;
    
    component pll IS
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC 
	);
    END component;
    
    component vpll IS
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC
	);
    END component;
    
    component vga is
    port(
        clk, nrst:      in std_logic;
        rgb:            out std_logic_vector(15 downto 0);
        hsync, vsync:   out std_logic;
        
        pixels:         in std_logic_vector(127 downto 0);
        pixreq:         out std_logic
    );
    end component;
    
    signal pclk, vclk: std_logic;
    signal nrst: std_logic;
    signal en, wr, bsy: std_logic;
    signal do, di, pixels: std_logic_vector(127 downto 0);
    signal addr: std_logic_vector(20 downto 0);
    signal rseg: std_logic_vector(15 downto 0);
    
    signal pixreq: std_logic;
    signal vso: std_logic;
begin
    vsync <= vso;
    pxr <= pixreq;
    bsyp <= bsy;

    ipll: pll
    port map(
        inclk0 => clk,
        c0 => pclk
    );
    
    ivpll: vpll
    port map(
        inclk0 => clk,
        c0 => vclk
    );
    
    irsth: rsthandler
    port map(
        clk => clk,
        nrsti => nrsti,
        nrsto => nrst
    );

    isdramctrl: sdramctrl
    generic map(
        CLK_FREQ => 100_000_000
    )
    port map(
        clk => pclk,
        nrst => nrst,
        
        en => en,
        wr => wr,
        di => di,
        addr => addr,
        do => do,
        bsy => bsy,
        
        sclk => sclk,
        scke => scke,
        scs => scs,
        swe => swe,
        scas => scas,
        sras => sras,
        saddr => saddr,
        sdata => sdata,
        sba => sba,
        sdqm => sdqm
    );
    
    imh: memhandler
    port map(
        clk => pclk,
        nrst => nrst,
        
        en => en,
        wr => wr,
        di => do,
        addr => addr,
        do => di,
        bsy => bsy,
        
        pixels => pixels,
        pixreq => pixreq,
        vsync => vso,
        
        rseg => rseg
    );
    
    iseg: seg7
    port map(
        clk => clk,
        nrst => nrst,
        rseg1 => rseg,
        seg7en => seg7en,
        seg7c => seg7c
    );
    
    ivga: vga
    port map(
        clk => vclk,
        nrst => nrst,
        
        rgb => rgb,
        hsync => hsync,
        vsync => vso,
        
        pixels => pixels,
        pixreq => pixreq
    );
end rtl;