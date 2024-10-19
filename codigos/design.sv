module factorial(
  input  logic clk, rst,
  input  logic start,
  input  logic [7:0] n,
  output logic [15:0] out,
  output logic ready, done, error
);
  typedef enum {IDLE, OP, ERROR, DONE} state_type;
  state_type state_reg, state_next;

  logic [15:0] a_reg, a_next;
  logic [7:0]  b_reg, b_next;
  logic [31:0] product;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      state_reg <= IDLE;
      a_reg     <= 1;
      b_reg     <= 0;
    end else begin
      state_reg <= state_next;
      a_reg     <= a_next;
      b_reg     <= b_next;
    end
  end

  always_comb begin
    state_next = state_reg;
    a_next     = a_reg;
    b_next     = b_reg;
    ready      = 0;
    done       = 0;
    error      = 0;
    product    = 0;

    case (state_reg)
      IDLE: begin
        ready  = 1;
        a_next = 1;
        b_next = n;
        if (start) begin
          state_next = OP;
        end
      end

      OP: begin
        if (b_next > 0) begin
          product = a_reg * b_reg;
          a_next  = product[15:0];
          b_next  = b_reg - 1;
          if (product > a_next) begin
            state_next = ERROR;
          end
        end else begin
          state_next = DONE;
        end
      end

      ERROR: begin
        done  = 1;
        error = 1;
        state_next = IDLE;
      end

      DONE: begin
        done = 1;
        state_next = IDLE;
      end

      default: begin
        state_next = IDLE;
      end
    endcase
  end

  assign out = a_reg;
endmodule
