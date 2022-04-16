
module stq_adata(
  clk,
  rst,
  wrt0_en,wrt0_WQ,wrt0_adata,
  wrt1_en,wrt1_WQ,wrt1_adata,
  upd0_WQ,upd0_adata,
  upd1_WQ,upd1_adata);
  input clk;
  input rst;
  input wrt0_en;
  input [5:0] wrt0_WQ;
  input [4:0] wrt0_adata;
  input wrt1_en;
  input [5:0] wrt1_WQ;
  input [4:0] wrt1_adata;
  input [5:0] upd0_WQ;
  output [4:0] upd0_adata;
  input [5:0] upd1_WQ;
  output [4:0] upd1_adata;
  
  reg [4:0] BGN[63:0];
  
  assign upd0_adata=BGN[upd0_WQ];
  assign upd1_adata=BGN[upd1_WQ];
  
  always @(posedge clk) begin
      if (wrt1_en) BGN[wrt1_WQ]<=wrt1_adata;
      if (wrt0_en) BGN[wrt0_WQ]<=wrt0_adata;
  end
endmodule
