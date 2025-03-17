// No license needed

module shiftreg_wrap #(
  parameter  int unsigned Depth = 32'd4,
  parameter  int unsigned DataWidth = 32,
  localparam type         dtype = logic [DataWidth-1:0]
)(
  input  logic clk_i,
  input  logic rst_ni,

  input  logic valid_i,
  input  dtype data_i,

  output logic valid_o,
  output dtype data_o
);

  shift_reg_gated #(
    .Depth (Depth),
    .dtype (dtype)
  ) i_shift_register (
    .clk_i,
    .rst_ni,
    .valid_i,
    .data_i,
    .valid_o,
    .data_o
  );

endmodule // shiftreg_wrap
