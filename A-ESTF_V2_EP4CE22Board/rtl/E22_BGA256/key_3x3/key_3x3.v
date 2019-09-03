//���о΢����
//�绰 15815519071 QQ 906606596
//Email 906606596@qq.com
//3X3���󰴼�,����ܻ���ʾ���º�ͬ����ֵ��˵�����ɹ���
//3X3 matrix button, digital tube will display different values after the press. Description successful detection.
module key_3x3(
  input            i_clk,
  input            i_rst_n,
  output     [2:0] U2_128_A,        //�����138��ַ 138 digital tube address
  output     U2_138_select,         //�����138ѡ�� Digital tube 138 options
  output     U3_138_select,        //����138ѡ�� dot array 138 selection
  input      [2:0] row,                 // ������� �� Matrix keyboard  row
  output reg [2:0] col,                 // ������� �� Matrix keyboard  column
  output reg [7:0] keyboard_val         // �������ʾ  Digital tube display
  
);
assign  U7_128_A = 0;       //ѡ��һλ����ܹ��� Choose a digital tube
assign  U2_138_select = 1 ; //ʹ������ܹ��� Enable digital work
assign  U3_138_select = 0 ; //��ֹ������ don.t let  Dot matrix work
//++++++++++++++++++++++++++++++++++++++
// ��Ƶ���� ��ʼ
//++++++++++++++++++++++++++++++++++++++
reg [19:0] cnt;                         // ������

always @ (posedge i_clk, negedge i_rst_n)
  if (!i_rst_n)
    cnt <= 0;
  else
    cnt <= cnt + 1'b1;

wire key_clk = cnt[19];                // (2^20/50M = 21)ms 
//--------------------------------------
// ��Ƶ���� ����
//--------------------------------------


//++++++++++++++++++++++++++++++++++++++
// ״̬������ ��ʼ
//++++++++++++++++++++++++++++++++++++++
// ״̬�����٣����������
parameter NO_KEY_PRESSED = 6'b000_001;  // û�а�������  
parameter SCAN_COL0      = 6'b000_010;  // ɨ���0�� 
parameter SCAN_COL1      = 6'b000_100;  // ɨ���1�� 
parameter SCAN_COL2      = 6'b001_000;  // ɨ���2�� 

parameter KEY_PRESSED    = 6'b010_000;  // �а�������

reg [5:0] current_state, next_state;    // ��̬����̬

always @ (posedge key_clk, negedge i_rst_n)
  if (!i_rst_n)
    current_state <= NO_KEY_PRESSED;
  else
    current_state <= next_state;

// ��������ת��״̬
always @ *
  case (current_state)
    NO_KEY_PRESSED :                    // û�а�������
        if (row != 3'h7)
          next_state = SCAN_COL0;
        else
          next_state = NO_KEY_PRESSED;
    SCAN_COL0 :                         // ɨ���0�� 
        if (row != 3'h7)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL1;
    SCAN_COL1 :                         // ɨ���1�� 
        if (row != 3'h7)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL2;    
    SCAN_COL2 :                         // ɨ���2��
        if (row != 3'h7)
          next_state = KEY_PRESSED;
        else
          next_state = NO_KEY_PRESSED;

    KEY_PRESSED :                       // �а�������
        if (row != 3'h7)
          next_state = KEY_PRESSED;
        else
          next_state = NO_KEY_PRESSED;                      
  endcase

reg       key_pressed_flag;             // ���̰��±�־
reg [2:0] col_val, row_val;             // ��ֵ����ֵ

// ���ݴ�̬������Ӧ�Ĵ�����ֵ
always @ (posedge key_clk, negedge i_rst_n)
  if (!i_rst_n)
  begin
    col              <= 4'h0;
    key_pressed_flag <=    0;
  end
  else
    case (next_state)
      NO_KEY_PRESSED :                  // û�а�������
      begin
        col              <= 3'h0;
        key_pressed_flag <=    0;       // ����̰��±�־
      end
      SCAN_COL0 :                       // ɨ���0��
        col <= 3'b110;
      SCAN_COL1 :                       // ɨ���1��
        col <= 3'b101;
      SCAN_COL2 :                       // ɨ���2��
        col <= 3'b011;

      KEY_PRESSED :                     // �а�������
      begin
        col_val          <= col;        // ������ֵ
        row_val          <= row;        // ������ֵ
        key_pressed_flag <= 1;          // �ü��̰��±�־  
      end
    endcase
//--------------------------------------
// ״̬������ ����
//--------------------------------------


//++++++++++++++++++++++++++++++++++++++
// ɨ������ֵ���� ��ʼ
//++++++++++++++++++++++++++++++++++++++
always @ (posedge key_clk, negedge i_rst_n)
  if (!i_rst_n)
    keyboard_val <= 3'h0;
  else
    if (key_pressed_flag)
      case ({row_val, col_val})
 
        6'b110_101 : keyboard_val <= 8'b1010_0100; //2
        6'b011_101 : keyboard_val <= 8'b1000_0000; //8
        6'b101_101 : keyboard_val <= 8'b1001_0010; //5
		  
        6'b101_011 : keyboard_val <= 8'b1000_0010;// 6
        6'b110_011 : keyboard_val <= 8'b1011_0000;// 3
        6'b011_011 : keyboard_val <= 8'b1001_0000;// 9
        
        6'b110_110 : keyboard_val <= 8'b1111_1001; //1
		  6'b101_110 : keyboard_val <= 8'b1001_1001;// 4
		  6'b011_110 : keyboard_val <= 8'b1111_1000; //7


      
      endcase
//--------------------------------------
//  ɨ������ֵ���� ����
//--------------------------------------
      
endmodule
