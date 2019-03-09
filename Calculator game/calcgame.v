module slowClock(clk,clk_1Hz);
input clk;
output clk_1Hz;

reg clk_1Hz = 1'b0;
reg [27:0] counter;

always@(posedge clk)
        begin
            counter <= counter + 1;
            if ( counter == 100_000_000)
                begin
                    counter <= 0;
                    clk_1Hz <= ~clk_1Hz;
                end
        end
endmodule

module calcgame(lvlsel,a,res,clk,bi,q1,q2,s,score,light);
output [7:0]q1;
reg[1:0]level;
reg [7:0]q1;
output [7:0]q2;
reg [7:0]q2;
output[7:0]s;
reg [7:0]s;
input [6:0] bi;
input [2:0] lvlsel;
output[6:0] score;
reg [6:0]score;
output [2:0] light;
reg [2:0]light;
reg [3:0]b;
reg [4:0]timer;
reg [3:0]ans;
output [6:0] a;
reg [6:0] a;
input res;
input clk;
reg flag;
slowClock clock_generator(clk, clk_1Hz);

always@(bi) begin
if (bi == 7'b1000000) a<=7'b1000000;	
if (bi == 7'b0100000) a<=7'b1111001;
if (bi == 7'b0010000) a<=7'b0100100;
if (bi == 7'b0001000) a<=7'b0110000;
if (bi == 7'b0000100) a<=7'b0011001;
if (bi == 7'b0000010) a<=7'b0010010;
if (bi == 7'b0000001) a<=7'b0000010;
if (bi == 7'b0000000) a<=7'b1111111;
end

always@(lvlsel) begin
if (lvlsel == 3'b100) level<=2'b01;
if (lvlsel == 3'b010) level<=2'b10;
if (lvlsel == 3'b001) level<=2'b11;
end


always@(level)begin
flag <= 1;
if(level==2'b01) begin 
   //timer <=5'd30;
	q1 <= 8'b10110000;
	q2 <= 8'b10100100;
	s <= 8'b11110111;
	ans = 4'd1;
    end	
if(level ==2'b10)
 begin 
     //timer <=5'd25;
	  q1 <= 8'b10100100;
	  q2 <= 8'b10110000;
	  s <= 8'b01111111;
	  ans <= 4'd6;
	  end 
if(level==2'b11)
begin
     //timer <=5'd20;
	  q1 <= 8'b10000000;
	  q2 <= 8'b10011001;
	  s <= 8'b10111011;
	  ans <= 4'd4;
 end
 
 end				



 
always@(posedge clk_1Hz or negedge res) begin
	if (~res) begin
		b =bi[0]*6+bi[1]*5+bi[2]*4+bi[3]*3+bi[4]*2+bi[5]*1+bi[6]*0;
			if (ans == b) begin
				light <= 3'b010;
				b=0;
				if (level == 2'b01) score<= 7'b1111001;
				if (level == 2'b10) score<= 7'b0100100;
				if (level == 2'b11) score<= 7'b0110000;
				
			end
			else begin
			light <= 3'b100;
				    b=0;
			end
	end
	else      begin
	 if (flag == 1) begin
		if (level == 2'b01) timer<=5'd30;
		if (level == 2'b10) timer<=5'd25;
		if (level == 2'b11) timer<=5'd20;
		flag <= 0;
	end
	 timer<= timer-1;
	 if(timer == 0) begin
	   light<= 3'b001;
		b=0;
		score<= 7'b1000000;
		end
	          end
	end 
	
	endmodule													