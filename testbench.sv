module tb;
  bit rst, clk, LOSER, WINNER, GAMEOVER, INIT;
  bit [3:0] winner_score, loser_score;
  who_e WHO;
  bit [1:0] CTRL;
  bit [WIDTH-1:0] val, count;
  //-------------inistantiating module-----------------------------------
  game gm(rst, CTRL, val, INIT, clk, LOSER, WINNER, GAMEOVER, winner_score, loser_score, WHO, count);
  
  //clk
  always begin
    #1 clk = ~clk;
  end
  
  initial begin
    rst = 1;
    #4 rst = 0;
    #1 INIT = 1; val = 3;
    #2 INIT = 0;
    #232 CTRL = UP_2;
    #124 CTRL = DOWN_1;
    #230 CTRL = DOWN_2;
    
  end
  initial begin
    $dumpfile("uvm.vcd");
    $dumpvars;
    #900 $finish;
  end

endmodule
