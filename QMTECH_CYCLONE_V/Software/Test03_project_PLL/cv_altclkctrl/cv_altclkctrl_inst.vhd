	component cv_altclkctrl is
		port (
			inclk  : in  std_logic := 'X'; -- inclk
			outclk : out std_logic         -- outclk
		);
	end component cv_altclkctrl;

	u0 : component cv_altclkctrl
		port map (
			inclk  => CONNECTED_TO_inclk,  --  altclkctrl_input.inclk
			outclk => CONNECTED_TO_outclk  -- altclkctrl_output.outclk
		);

