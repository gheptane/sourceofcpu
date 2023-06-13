/*
Copyright 2022 Goran Dakov

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


`include "../struct.sv"
`include "../fpoperations.sv"
`include "../csrss_no.sv"

module fun_fpuL(
  clk,
  rst,
  fpcsr,
  u1_A,u1_B,u1_Bx,u1_Bxo,u1_en,u1_op,
  u1_fufwd_A,u1_fuufwd_A,u1_fufwd_B,u1_fuufwd_B,
  u1_ret,u1_ret_en,
  u3_A,u3_B,u3_Bx,u3_Bxo,u3_en,u3_op,
  u3_fufwd_A,u3_fuufwd_A,u3_fufwd_B,u3_fuufwd_B,
  u3_ret,u3_ret_en,
  u5_A,u5_B,u5_Bx,u5_Bxo,u5_en,u5_op,
  u5_fufwd_A,u5_fuufwd_A,u5_fufwd_B,u5_fuufwd_B,
  u5_ret,u5_ret_en,
  FUF0,FUF1,FUF2,
  FUF3,FUF4,FUF5,
  FUF6,FUF7,FUF8,
  FUF9,
  FUF0N,FUF1M,FUF2N,FUF3M,FUF4N,FUF5N,
  FUF6N,FUF7M,FUF8N,FUF9M,
  ALTDATA0,ALTDATA1,
  ALT_INP,
  FUS_alu0,FUS_alu1,
  FUS_alu2,FUS_alu3,
  FUS_alu4,FUS_alu5,
  ex_alu0,ex_alu1,
  ex_alu2,ex_alu3,
  ex_alu4,ex_alu5,
  fxFADD0_raise_s,
  fxFCADD1_raise_s,
  fxFADD2_raise_s,
  fxFCADD3_raise_s,
  fxFADD4_raise_s,
  fxFCADD5_raise_s,
  FOOSH0_in,  FOOSH0_out,
  FOOSH1_in,  FOOSH1_out,
  FOOSH2_in,  FOOSH2_out,
  XI_dataS,
  fxFRT_alten_reg3,
  daltX,
  FUCVT1,
  outA,outB
  );
  localparam [0:0] H=1'b0;
  localparam SIMD_WIDTH=68; //half width
  input clk;
  input rst;
  input [31:0] fpcsr;
  input [16+67:0] u1_A;
  input [16+67:0] u1_B;
  input [67:0] u1_Bx;
  output [67:0] u1_Bxo;
  input [3:0] u1_en;
  input [12:0] u1_op;
  input [3:0] u1_fufwd_A;
  input [3:0] u1_fuufwd_A;
  input [3:0] u1_fufwd_B;
  input [3:0] u1_fuufwd_B;
  output [13:0] u1_ret;
  output u1_ret_en;

  input [16+67:0] u3_A;
  input [16+67:0] u3_B;
  input [67:0] u3_Bx;
  output [67:0] u3_Bxo;
  input [3:0] u3_en;
  input [12:0] u3_op;
  input [3:0] u3_fufwd_A;
  input [3:0] u3_fuufwd_A;
  input [3:0] u3_fufwd_B;
  input [3:0] u3_fuufwd_B;
  output [13:0] u3_ret;
  output u3_ret_en;
  
  input [16+67:0] u5_A;
  input [16+67:0] u5_B;
  input [67:0] u5_Bx;
  output [67:0] u5_Bxo;
  input [3:0] u5_en;
  input [12:0] u5_op;
  input [3:0] u5_fufwd_A;
  input [3:0] u5_fuufwd_A;
  input [3:0] u5_fufwd_B;
  input [3:0] u5_fuufwd_B;
  output [13:0] u5_ret;
  output u5_ret_en;
  
  input [16+67:0] FUF0N;
  input [16+67:0] FUF1M;
  input [16+67:0] FUF2N;
  input [16+67:0] FUF3M;
  inout [16+67:0] FUF4N;
  inout [16+67:0] FUF5N;

  input [16+67:0] FUF0;
  input [16+67:0] FUF1;
  input [16+67:0] FUF2;
  input [16+67:0] FUF3;
  inout [16+67:0] FUF4;
  inout [16+67:0] FUF5;
  inout [16+67:0] FUF6;
  inout [16+67:0] FUF7;
  inout [16+67:0] FUF8;
  inout [16+67:0] FUF9;
  input [1:0] ALT_INP;
  input [16+67:0] ALTDATA0;
  input [16+67:0] ALTDATA1;
  
  inout [16+67:0] FUF6N;
  inout [16+67:0] FUF7M;
  inout [16+67:0] FUF8N;
  inout [16+67:0] FUF9M;

  input [5:0] FUS_alu0;
  input [5:0] FUS_alu1;
  input [5:0] FUS_alu2;
  input [5:0] FUS_alu3;
  input [5:0] FUS_alu4;
  input [5:0] FUS_alu5;
  input [2:0] ex_alu0;
  input [2:0] ex_alu1;
  input [2:0] ex_alu2;
  input [2:0] ex_alu3;
  input [2:0] ex_alu4;
  input [2:0] ex_alu5;
  input [10:0] fxFADD0_raise_s;
  input [10:0] fxFCADD1_raise_s;
  input [10:0] fxFADD2_raise_s;
  input [10:0] fxFCADD3_raise_s;
  input [10:0] fxFADD4_raise_s;
  input [10:0] fxFCADD5_raise_s;
  input [5:0]  FOOSH0_in;
  output [5:0] FOOSH0_out;
  input [5:0]  FOOSH1_in;
  output [5:0] FOOSH1_out;
  input [5:0]  FOOSH2_in;
  output [5:0] FOOSH2_out;
  input [67:0] XI_dataS;
  input fxFRT_alten_reg3;
  output daltX;
  output [63:0] FUCVT1;
  output [16+67:0] outA;
  output [16+67:0] outB;

  wire [15+68:0] XI_dataD;
  reg [3:0] u5_en_reg;
  reg [12:0] u5_op_reg;
  reg [3:0] u5_en_reg2;
  reg [12:0] u5_op_reg2;

  fun_fpu #(0,0) fpu0_mod(
  clk,
  rst,
  fpcsr,
  u1_A,u1_B,u1_Bx,u1_Bxo,u1_en,u1_op,
  u1_fufwd_A,u1_fuufwd_A,u1_fufwd_B,u1_fuufwd_B,
  u1_ret,u1_ret_en,
  FUF0,FUF1,FUF2,
  FUF3,FUF4,FUF5,
  FUF6,FUF7,FUF8,
  FUF9,
  FUF0N,FUF1M,FUF2N,FUF3M,FUF4N,FUF5N,
  FUF6N,FUF7M,FUF8N,FUF9M,
  84'b0,84'b0,
  2'b0,
  FUS_alu0,FUS_alu1,
  ex_alu0,ex_alu1,
  fxFADD0_raise_s,
  fxFCADD1_raise_s,
  FOOSH0_in,
  FOOSH0_out,,,
  );

  fun_fpu #(1,0) fpu1_mod(
  clk,
  rst,
  fpcsr,
  u3_A,u3_B,u3_Bx,u3_Bxo,u3_en,u3_op,
  u3_fufwd_A,u3_fuufwd_A,u3_fufwd_B,u3_fuufwd_B,
  u3_ret,u3_ret_en,
  FUF0,FUF1,FUF2,
  FUF3,FUF4,FUF5,
  FUF6,FUF7,FUF8,
  FUF9,
  FUF0N,FUF1M,FUF2N,FUF3M,FUF4N,FUF5N,
  FUF6N,FUF7M,FUF8N,FUF9M,
  84'b0,84'b0,
  2'b0,
  FUS_alu2,FUS_alu3,
  ex_alu2,ex_alu3,
  fxFADD2_raise_s,
  fxFCADD3_raise_s,
  FOOSH1_in,
  FOOSH1_out,,,
  );

  fun_fpu #(2,0) fpu2_mod(
  clk,
  rst,
  fpcsr,
  u5_A,u5_B,u5_Bx,u5_Bxo,u5_en,u5_op,
  u5_fufwd_A,u5_fuufwd_A,u5_fufwd_B,u5_fuufwd_B,
  u5_ret,u5_ret_en,
  FUF0,FUF1,FUF2,
  FUF3,FUF4,FUF5,
  FUF6,FUF7,FUF8,
  FUF9,
  FUF0N,FUF1M,FUF2N,FUF3M,FUF4N,FUF5N,
  FUF6N,FUF7M,FUF8N,FUF9M,
  ALTDATA0,ALTDATA1,
  ALT_INP,
  FUS_alu4,FUS_alu5,
  ex_alu4,ex_alu5,
  fxFADD4_raise_s,
  fxFCADD5_raise_s,
  FOOSH2_in,
  FOOSH2_out,
  XI_dataD,
  outA,outB
  );
 
  cvt_FP_I_mod fp2i_mod(
  .clk(clk),
  .rst(rst),
  .en(u5_en_reg[3] && u5_en_reg[0] && u5_op_reg[11] 
  && (u5_op_reg[7:0]==`fop_cvtD ||
    u5_op_reg[7:0]==`fop_cvtE || u5_op_reg[7:0]==`fop_cvtS ||
    u5_op_reg[7:0]==`fop_cvt32S || u5_op_reg[7:0]==`fop_cvt32D ||
    u5_op_reg[7:0]==`fop_tblD)),
  .clkEn(~fxFRT_alten_reg3),
  .A((u5_op_reg2[7:0]!=`fop_cvtD && u5_op_reg2[7:0]!=`fop_cvt32D &&
    u5_op_reg2[7:0]!=`fop_cvtE) ? {16'b0,XI_dataS[65:0]} : {XI_dataD[15+68:68],XI_dataD[65:0]}),
  .isDBL(u5_op_reg[7:0]==`fop_cvtD || u5_op_reg[7:0]==`fop_cvt32D),
  .isEXT(u5_op_reg[7:0]==`fop_cvtE),
  .isSNG(u5_op_reg[7:0]!=`fop_cvtD && u5_op_reg[7:0]!=`fop_cvt32D &&
    u5_op_reg[7:0]!=`fop_cvtE),
  .verbatim(u5_op_reg[7:0]==`fop_tblD),
  .is32b(u5_op_reg[7:0]==`fop_cvt32S || u5_op_reg[7:0]==`fop_cvt32D),
  .res(FUCVT1),
  .alt(daltX)
  );

  always @(posedge clk) begin
      u5_en_reg<=u5_en;
      u5_op_reg<=u5_op;
  end
  always @(negedge clk) begin
      u5_en_reg2<=u5_en_reg;
      u5_op_reg2<=u5_op_reg;
  end
endmodule