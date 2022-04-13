//-----------------------------typedefs------------------------------
typedef enum bit [1:0] {UP_1, UP_2, DOWN_1, DOWN_2} mode_e; //counter mode
typedef enum bit [1:0] {none=2'b00, loser=2'b01, winner=2'b10} who_e;
parameter WIDTH = 3; //counter width
//---------------------------------------------------------------------

module counter(
  //---------------inputs-------------------------
  input clk,
  input rst,
  input [1:0] CTRL,
  input INIT,
  input [WIDTH-1:0] init_val,
  //----------------------outputs--------------------
  output bit [WIDTH-1:0] count);
  
  always @(posedge clk or posedge rst) begin
    if (rst) count <= 0;
    else if (INIT) count <= init_val;
    else begin
      case (CTRL)
        UP_1: count <= count + 1;
        UP_2: count <= count + 2;
        DOWN_1: count <= count - 1;
        DOWN_2: count <= count -2;
        endcase
    end
  end
endmodule

module score_counter(
  //--------------inputs-------------------
  input signal, //LOSER or WINNER
  input rst,
  //--------------outputs-----------------
  output bit [3:0] score);
  
  always @(posedge signal or posedge rst) begin
    if (rst) score <= 0;
    else if (signal) score <= score + 1;
  end
endmodule

module game(
  //------------inputs----------------------
  input rst,
  input [1:0] CTRL,
  input [WIDTH-1:0] init_val,
  input INIT,
  input clk,
  //------------outputs--------------------
  output wire LOSER,
  output wire WINNER,
  output wire GAMEOVER,
  output bit[3:0] winner_score,
  output bit[3:0] loser_score,
  output who_e WHO,
  output bit [WIDTH-1:0] count);
  
  //----------------intermeditate vars-----------------------
  wire counter_reset;
  typedef enum{init=1, round} st;
  st state, next;
  
  //----------------instantiating modules------------------------
  counter cntr(clk, counter_reset, CTRL, INIT, init_val, count);
  score_counter win_score(WINNER, counter_reset, winner_score);
  score_counter lose_score(LOSER, counter_reset, loser_score);
  
  //-----------------control---------------------------------
  assign counter_reset = rst | (state==init & ~INIT); //set counter_reset if original rst is high or you're in initial state and INIT is low
  assign LOSER = ~|count & ~rst;
  assign WINNER = &count;
  assign GAMEOVER = (&loser_score | &winner_score);
  
  always @(posedge clk) begin
    if (rst) state <= init;
    else state <= next;
  end
  
  //@gameover decide the winner then reset the game
  always @(posedge GAMEOVER) begin
    WHO <= &loser_score ? loser : winner;
    next <= init;
  end
  
  always @(state) begin
    case (state)
      init: begin
        WHO <= none;
        next <= round;
      end
      round: next <= round;
      default next <= init;
    endcase
  end
endmodule
