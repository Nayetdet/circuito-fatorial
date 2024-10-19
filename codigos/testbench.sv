module tb_factorial;
  logic clk, rst;
  logic start;
  logic [7:0] n;
  logic [15:0] out;
  logic ready, done, error;

  localparam N = 12;
  logic [23:0] testvectors [N-1:0];
  logic [15:0] expected_out;

  factorial dut(clk, rst, start, n, out, ready, done, error);
  always #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_factorial);

    clk = 1; start = 0; n = 0; expected_out = 0;
    rst = 1; @(posedge clk); rst = 0;

    $readmemb("testvectors.txt", testvectors, N-1, 0);
    foreach (testvectors[i]) begin
      {n, expected_out} = testvectors[i];
      start = 1; @(posedge clk); start = 0;
      
      wait(done);
      assert(out === expected_out);
        else $error(
          "Erro no %do caso: out=%b expected_out=%b",
          i+1, out, expected_out
        );
      @(posedge clk);
    end

    $finish;
  end
endmodule
