//-----------------------------typedefs------------------------------
typedef enum bit [1:0] {UP_1, UP_2, DOWN_1, DOWN_2} mode_e;
typedef enum bit [1:0] {none=2'b00, loser=2'b01, winner=2'b10} who_e;
parameter WIDTH = 2;
//---------------------------------------------------------------------

module game(
  //------------inputs----------------------
  input rst,
  input [1:0] CTRL,
  input [WIDTH-1:0] val,
  input INIT,
  input clk,
  //------------outputs--------------------
  output wire LOSER,
  output wire WINNER,
  output wire GAMEOVER,
  output who_e WHO,
  output bit [WIDTH-1:0] count);
  
  //-------intermeditate vars--------------
  bit [3:0] winner_score, loser_score;
  typedef enum{init, round, gameover} st;
  st state, next;
  
  //---------------counter----------------------
  always @(posedge clk or posedge rst) begin
    if (rst) count <= 0;
    else if (INIT) count <= val;
    else begin
      case (CTRL)
        UP_1: count <= count + 1;
        UP_2: count <= count + 2;
        DOWN_1: count <= count - 1;
        DOWN_2: count <= count - 2;
      endcase
    end
  end
  
  //------------control------------------------
  assign LOSER = !|count;
  assign WINNER = &count;
  assign GAMEOVER = state == gameover;
  
  always @(posedge clk or posedge rst) begin
    if (rst) state <= init;
    else state <= next;
  end
  
  always @(posedge LOSER) loser_score++;
  always @(posedge WINNER) winner_score++;
  
  always @(state or count) begin
    case (state)
      init: begin
        winner_score <= 0;
        loser_score <= 0;
        WHO <= none;
        next <= round;
        count <= 0;
      end
      round: begin
        next <= round;
        //if (LOSER) loser_score++;
        //else if (WINNER) winner_score++;
        if (loser_score == 15 || winner_score == 15) state <= gameover;
      end
      gameover: begin
        if (loser_score == 15) WHO <= loser;
        else WHO <= winner;
        next <= init;
      end
    endcase
  end
endmodule
