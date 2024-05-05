module des(input switch, input timer, input start, input stop, output reg LCD_RS, output reg LCD_E, output reg[7:4] DATA, output redled, output blueled);

wire clk;

	qlal4s3b_cell_macro u_qlal4s3b_cell_macro (
	.Sys_Clk0 (clk)
);

reg clk1 = 0;
reg [26:0] x=0;
integer i = 1;
integer c = 3;
integer sec = 0;
reg [5:0] min;
reg [4:0] hr_24;
reg [3:0] hr_12;
integer o;
reg [25:0] count=0;
reg [3:0] Datas [1:77];
reg [3:0] b = 0;
integer sect;
integer seco;
integer mint;
integer mino;
integer hrt;
integer hro;
reg led1;
reg led2;
integer k = 0;
integer w = 0;
reg [5:0] st;
reg [5:0] mt;
reg [5:0] ht;
reg [5:0] st_i;
reg [5:0] mt_i;
reg [5:0] ht_i;
integer htt;
integer hto;
integer mtt;
integer mto;
integer stt;
integer sto;

always @(posedge clk) begin

	x = x + 1;

	if(x > 6500000) begin
		clk1 = !clk1; //Clock with period 1sec
		x = 0;
	end

end
always @(posedge clk1) begin

if (k == 0) begin
	min = 59; //Initialising Clock time
	hr_24 = 23;
	hr_12 = (hr_24 <= 12) ? hr_24 :  (hr_24 - 12);
	k = k + 1;
end

else begin

	if (sec < 59) begin
		sec = sec + 1;
	end
	
	else begin
		sec = 0;
	end

	if (sec == 0 & min < 59) begin
		min = min + 1;
	end

	else if (sec > 0) begin
		min = min;
	end

	else begin
		min = 0;
	end

	if (sec == 0 & min == 0 & hr_24 <= 23) begin
		hr_24 = hr_24 + 1;
	end

	else begin
		hr_24 = hr_24;
	end

	if (hr_24 > 23) begin
		hr_24 = 0;
	end

	if (sec == 0 & min == 0 & hr_24 <= 12) begin
		hr_12 = hr_12 + 1;
	end

	else begin
		hr_12 = hr_12;
	end

	if (hr_12 > 12) begin
		hr_12 = 1;
	end

end

	seco = sec % 10;
	sect = (sec - seco) / 10;
	
	mino = min % 10;
	mint = (min - mino) / 10;

	if (switch == 1) begin
	
		hro = hr_12 % 10;
		hrt = (hr_12 - hro) / 10;
		led2 = (hr_24 <= 12) ? 0 : 1; // Blue led blinks when PM
	end

	else begin

		hro = hr_24 % 10;
		hrt = (hr_24 - hro) / 10;
		led2 = 0;
	end
end


always @(posedge clk1) begin

	if (w == 0) begin
		ht_i = 0; //Initialising Timer
		mt_i = 0;
		st_i = 30;
		mt = mt_i;
		ht = ht_i;
		st = st_i;
		w = w + 1;
	end

	else if (start == 1 & w != 2) begin

		if (stop != 1 & st >= 0) begin
			if (st > 0)
				st = st - 1;
			else
				st = 59;
		end


		if (stop != 1 & st == 59 & mt >= 0) begin
			if (mt > 0)
				mt = mt - 1;
			else
				mt = 59;
		end

		if (stop != 1 & st == 59 & mt == 59 & ht > 0) begin
			ht = ht - 1;
		end

		if (st == 0 & mt == 0 & ht == 0) begin
			if (stop != 1)
				led1 = 1;
			else
				led1 = 0;
			w = 2;
		end

		if (stop == 1) begin
			st = st_i;
			mt = mt_i;
			ht = ht_i;
		end
	end

	else begin
		led1 = 0;
	end
	
	if (st == 0 & mt == 0 & ht == 0) begin
		if (stop != 1) begin
			led1 = 1;  //Red led blinks when timer hits zero
		end
		else begin
			st = st_i;
			mt = mt_i;
			ht = ht_i;
			w = 0;
		end
	end

	sto = st % 10;
	stt = (st - sto) / 10;

	mto = mt % 10;
	mtt = (mt - mto) / 10;
	
	hto = ht % 10;
	htt = (ht - hto) / 10;
	

end

assign redled = led1;
assign blueled = led2;

always @(posedge clk) begin

	Datas[1]   =  4'h3;   	//-- initializing controller--
	Datas[2]   =  4'h3;   
	Datas[3]   =  4'h3;   	//-- set to 4-bit input mode --
	Datas[4]   =  4'h2;   	
	Datas[5]   =  4'h2;   	//--2 line, 5x7 matrix  --
	Datas[6]   =  4'h8;   	
	Datas[7]   =  4'h0;   	//--turn cursor off (0x0E to enable) --
	Datas[8]   =  4'hC;   	
	Datas[9]   =  4'h0;   	//-- cursor direction = right --
	Datas[10]  =  4'h6;   	
	Datas[11]  =  4'h0;   	//--  start with clear display  --
	Datas[12]  =  4'h1;
	Datas[13]  =  4'h8;     //starting from line 1
	Datas[14]  =  4'h0;
	Datas[15]  =  1'b1;

	if (timer == 1) begin
		Datas[16]  =  4'h2;
		Datas[17]  =  4'h0;   
		Datas[18]  =  4'h2;
		Datas[19]  =  4'h0;
		Datas[20]  =  4'h2;       
		Datas[21]  =  4'h0;
		Datas[22]  =  4'h2;
		Datas[23]  =  4'h0;
		Datas[24]  =  4'h2;
		Datas[25]  =  4'h0;
		Datas[26]  =  4'h2;
		Datas[27]  =  4'h3;
		Datas[28]  =  4'h5;
		Datas[29]  =  4'h4;
		Datas[30]  =  4'h4;
		Datas[31]  =  4'h9;
		Datas[32]  =  4'h4;
		Datas[33]  =  4'hD;
		Datas[34]  =  4'h4;
		Datas[35]  =  4'h5;
		Datas[36]  =  4'h5;
		Datas[37]  =  4'h2;
		Datas[38]  =  4'h2;
		Datas[39]  =  4'h0;
		Datas[40]  =  4'h2;
		Datas[41]  =  4'h0;
		Datas[42]  =  4'h2;
		Datas[43]  =  4'h0;
	end

	else begin

		Datas[16]  =  4'h2;
		Datas[17]  =  4'h0;   
		Datas[18]  =  4'h2;
		Datas[19]  =  4'h0;
		Datas[20]  =  c;       
		Datas[21]  =  hrt;
		Datas[22]  =  c;
		Datas[23]  =  hro;
		Datas[24]  =  4'h2;
		Datas[25]  =  4'h0;
		Datas[26]  =  4'h3;
		Datas[27]  =  4'hA;
		Datas[28]  =  4'h2;
		Datas[29]  =  4'h0;
		Datas[30]  =  c;
		Datas[31]  =  mint;
		Datas[32]  =  c;
		Datas[33]  =  mino;
		Datas[34]  =  4'h2;
		Datas[35]  =  4'h0;
		Datas[36]  =  4'h3;
		Datas[37]  =  4'hA;
		Datas[38]  =  4'h2;
		Datas[39]  =  4'h0;
		Datas[40]  =  c;
		Datas[41]  =  sect;
		Datas[42]  =  c;
		Datas[43]  =  seco;
	end

	Datas[44]  =  4'hC; //next line	
	Datas[45]  =  4'h0;

	if (switch == 1 & timer !=1) begin

		Datas[46]  =  4'h4;
		Datas[47]  =  4'h3;
		Datas[48]  =  4'h4;
		Datas[49]  =  4'hC;
		Datas[50]  =  4'h4;
		Datas[51]  =  4'hF;
		Datas[52]  =  4'h4;
		Datas[53]  =  4'h3;
		Datas[54]  =  4'h4;
		Datas[55]  =  4'hB;
		Datas[56]  =  4'h2;
		Datas[57]  =  4'h0;
		Datas[58]  =  c;
		Datas[59]  =  1;
		Datas[60]  =  c;
		Datas[61]  =  2;
		Datas[62]  =  4'h6;
		Datas[63]  =  4'h8;
		Datas[64]  =  4'h2;
		Datas[65]  =  4'h0;

		if (hr_24 > 12) begin
			Datas[66]  =  4'h5;
			Datas[67]  =  4'h0;
		end
		else begin
			Datas[66]  =  4'h4;
			Datas[67]  =  4'h1;
		end

		Datas[68]  =  4'h4;
		Datas[69]  =  4'hD;
		Datas[70]  =  4'h2;
		Datas[71]  =  4'h0;
		Datas[72]  =  4'h4;
		Datas[73]  =  4'h9;
		Datas[74]  =  4'h5;
		Datas[75]  =  4'h3;
		Datas[76]  =  4'h5;
		Datas[77]  =  4'h4;
	end

	else if (timer == 1) begin

		Datas[46]  =  4'h2;
		Datas[47]  =  4'h0;   
		Datas[48]  =  4'h2;
		Datas[49]  =  4'h0;
		Datas[50]  =  c;       
		Datas[51]  =  htt;
		Datas[52]  =  c;
		Datas[53]  =  hto;
		Datas[54]  =  4'h2;
		Datas[55]  =  4'h0;
		Datas[56]  =  4'h3;
		Datas[57]  =  4'hA;
		Datas[58]  =  4'h2;
		Datas[59]  =  4'h0;
		Datas[60]  =  c;
		Datas[61]  =  mtt;
		Datas[62]  =  c;
		Datas[63]  =  mto;
		Datas[64]  =  4'h2;
		Datas[65]  =  4'h0;
		Datas[66]  =  4'h3;
		Datas[67]  =  4'hA;
		Datas[68]  =  4'h2;
		Datas[69]  =  4'h0;
		Datas[70]  =  c;
		Datas[71]  =  stt;
		Datas[72]  =  c;
		Datas[73]  =  sto;
		Datas[74]  =  4'h2;
		Datas[75]  =  4'h0;
		Datas[76]  =  4'h2;
		Datas[77]  =  4'h0;
	end

	else begin

		Datas[46]  =  4'h2;
		Datas[47]  =  4'h0;
		Datas[48]  =  4'h4;
		Datas[49]  =  4'h3;
		Datas[50]  =  4'h4;
		Datas[51]  =  4'hC;
		Datas[52]  =  4'h4;
		Datas[53]  =  4'hF;
		Datas[54]  =  4'h4;
		Datas[55]  =  4'h3;
		Datas[56]  =  4'h4;
		Datas[57]  =  4'hB;
		Datas[58]  =  4'h2;
		Datas[59]  =  4'h0;
		Datas[60]  =  c;
		Datas[61]  =  2;
		Datas[62]  =  c;
		Datas[63]  =  4;
		Datas[64]  =  4'h6;
		Datas[65]  =  4'h8;
		Datas[66]  =  4'h7;
		Datas[67]  =  4'h2;
		Datas[68]  =  4'h2;
		Datas[69]  =  4'h0;
		Datas[70]  =  4'h4;
		Datas[71]  =  4'h9;
		Datas[72]  =  4'h5;
		Datas[73]  =  4'h3;
		Datas[74]  =  4'h5;
		Datas[75]  =  4'h4;
		Datas[76]  =  4'h2;
		Datas[77]  =  4'h0;
	end
end

always @(posedge clk) begin

if (i <= 14)begin

	LCD_RS <= 1'b0;
	DATA = Datas[i];
	LCD_E <= 1'b1;

	if (count == 800) begin //waiting 40us
   		LCD_E <= 1'b0;
   		count <= 0;
   		i <= i + 1;
   		end
	else
   		count <= count + 1;

end
if (i==15) begin
	if (count==60000) begin //waiting 3ms
     		count <= 0;
     		i <= i + 1;
     		end
	else
     		count <= count + 1;
end
if (i > 15 & i <= 43) begin

	LCD_RS <= 1'b1;
	DATA = Datas[i];
        LCD_E <= 1'b1;

	if (count == 800) begin //waiting 40us
	    LCD_E <= 1'b0;
	    count <= 0;
            i <= i + 1;
    	    end
        else
		count <= count + 1;       
end

if (i >= 44 & i <= 45) begin
	LCD_RS <= 1'b0;
	DATA = Datas[i];
	LCD_E <= 1'b1;

	if (count == 800)begin //waiting 40us
   		LCD_E <= 1'b0;
   		count <= 0;
   		i <= i + 1;
   	end

	else
   		count <= count + 1;

end

if (i > 45 & i <= 77) begin 
	LCD_RS <= 1'b1;
	DATA = Datas[i];
        LCD_E <= 1'b1;

	if (count == 800)begin //waiting 40us
	    LCD_E <= 1'b0;
	    count <= 0;
            i <= i + 1;
    	    end
        else
		count <= count + 1;       
end

if (i > 77) begin
	i <= 13;
end
	
end
endmodule
