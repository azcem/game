//testing up1
module tb0;
  bit rst, clk, LOSER, WINNER, GAMEOVER, INIT;
  who_e WHO;
  bit [1:0] CTRL;
  bit [WIDTH-1:0] val, count;
  always begin
    #1 clk = ~clk;
  end
  game gm(rst, CTRL, val, INIT, clk, LOSER, WINNER, GAMEOVER, WHO, count);
  
  initial begin
    $dumpfile("uvm.vcd");
    $dumpvars;
    #400 $finish;
  end
endmodule

//testing down1
module tb1;
  bit rst, clk, LOSER, WINNER, GAMEOVER, INIT;
  who_e WHO;
  bit [1:0] CTRL;
  bit [WIDTH-1:0] val, count;
  always begin
    #1 clk = ~clk;
  end
  
  initial begin
    CTRL <= DOWN_1;
  end
  
  game gm(rst, CTRL, val, INIT, clk, LOSER, WINNER, GAMEOVER, WHO, count);
  
  initial begin
    $dumpfile("uvm.vcd");
    $dumpvars;
    #400 $finish;
  end
endmodule

//testing reset/down1/up2/down2
module tb3;
  bit rst, clk, LOSER, WINNER, GAMEOVER, INIT;
  who_e WHO;
  bit [1:0] CTRL;
  bit [WIDTH-1:0] val, count;
  always begin
    #1 clk = ~clk;
  end
  
  initial begin
    CTRL <= UP_2;
    #4 CTRL <= DOWN_1;
    #10 rst <= 1;
    #12 rst <= 0; CTRL <= DOWN_2;
  end
  game gm(rst, CTRL, val, INIT, clk, LOSER, WINNER, GAMEOVER, WHO, count);
  
  initial begin
    $dumpfile("uvm.vcd");
    $dumpvars;
    #400 $finish;
  end
endmodule
