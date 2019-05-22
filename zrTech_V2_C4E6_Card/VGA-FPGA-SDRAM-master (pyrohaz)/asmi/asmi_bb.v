
module asmi (
	noe_in,
	dclk_in,
	ncso_in,
	asdo_in,
	asmi_access_granted,
	data0_out,
	asmi_access_request);	

	input		noe_in;
	input		dclk_in;
	input		ncso_in;
	input		asdo_in;
	input		asmi_access_granted;
	output		data0_out;
	output		asmi_access_request;
endmodule
