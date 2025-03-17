// No license needed

module testbench;

  localparam TCP = 1.0ns; // clock period, 1 GHz clock
  localparam TA  = 0.2ns; // application time
  localparam TT  = 0.8ns; // test time

  logic clk, rst_n, start;

  // Performs one entire clock cycle.
  task cycle;
    clk <= #(TCP/2) 0;
    clk <= #TCP 1;
    #TCP;
  endtask

  initial begin
    clk <= 1'b0;
    rst_n <= 1'b0;
    start <= 1'b0;

    for (int i = 0; i < 20; i++) cycle();

    rst_n <= #TA 1'b1;

    for (int i = 0; i < 10; i++) cycle();

    rst_n <= #TA 1'b0;

    for (int i = 0; i < 10; i++) cycle();

    rst_n <= #TA 1'b1;

    start <= 1'b1;

    while(1) cycle();

  end

  localparam int unsigned ShiftRegDepth = 4;
  localparam int unsigned DataWidth = 32;

  logic valid_in, valid_out;
  logic [DataWidth-1:0] generated_data, consumed_data;

  shiftreg_wrap #(
    .Depth (ShiftRegDepth),
    .DataWidth (DataWidth)
  ) i_dut (
    .clk_i (clk),
    .rst_ni (rst_n),
    .valid_i (valid_in),
    .data_i (generated_data),
    .valid_o (valid_out),
    .data_o (consumed_data)
  );

  logic [ShiftRegDepth-1:0][DataWidth-1:0] random;
  initial begin
    valid_in = '0;
    random = '0;
    generated_data = '0;
    @(posedge start);

    for (int i = 0; i < ShiftRegDepth; i++) begin
      random[i] = $random;
      $display("%d - Random value generated: %x", i, random[i]);
      @(posedge clk);
    end

    valid_in = '1;
    for (int i = 0; i < ShiftRegDepth; i++) begin
      generated_data = random[i];
      @(posedge clk);
    end

    @(posedge valid_out);

    for (int i = 0; i < ShiftRegDepth; i++) begin
      if (consumed_data != random[i]) begin
        $display("ERROR - Received output %x differs from %x at index %d", consumed_data, random[i], i);
        $fatal;
      end
      @(posedge clk);
    end

    $display("Success!");
    $finish;
  end

endmodule // testbench
