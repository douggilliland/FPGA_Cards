//���о΢����
//�绰 15815519071 QQ 906606596
//Email 906606596@qq.com
//���뿪�ص� 1 2 3 4 5 6 7 8��Ϊ����
//��ʵ����ò��뿪��������LED��

// dial switch 12345678 as input
// this experiment adopts dial switch to control the LED lights

module swith_led(
		switch,
		led
		);					    // ģ����led
		
input	[7:0] 	switch;		    //���뿪�� swith input
output	[7:0]	led;			//LED�������ʾ led output

assign led =	switch;			//�Ѳ��뿪�ص�������LED��������ʾ  swith to led

endmodule