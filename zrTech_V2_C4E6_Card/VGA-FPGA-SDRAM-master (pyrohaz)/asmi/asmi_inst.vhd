	component asmi is
		port (
			noe_in              : in  std_logic := 'X'; -- noe
			dclk_in             : in  std_logic := 'X'; -- dclkin
			ncso_in             : in  std_logic := 'X'; -- scein
			asdo_in             : in  std_logic := 'X'; -- sdoin
			asmi_access_granted : in  std_logic := 'X'; -- asmi_access_granted
			data0_out           : out std_logic;        -- data0out
			asmi_access_request : out std_logic         -- asmi_access_request
		);
	end component asmi;

	u0 : component asmi
		port map (
			noe_in              => CONNECTED_TO_noe_in,              --              noe_in.noe
			dclk_in             => CONNECTED_TO_dclk_in,             --             dclk_in.dclkin
			ncso_in             => CONNECTED_TO_ncso_in,             --             ncso_in.scein
			asdo_in             => CONNECTED_TO_asdo_in,             --             asdo_in.sdoin
			asmi_access_granted => CONNECTED_TO_asmi_access_granted, -- asmi_access_granted.asmi_access_granted
			data0_out           => CONNECTED_TO_data0_out,           --           data0_out.data0out
			asmi_access_request => CONNECTED_TO_asmi_access_request  -- asmi_access_request.asmi_access_request
		);

