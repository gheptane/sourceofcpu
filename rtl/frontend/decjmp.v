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
`include "../operations.sv"
`include "../memop.sv"


module jump_decoder(
  clk,
  rst,
  mode64,
  instr,
  magic,
  class_,
  isAvx,
  constant,
  
  pushCallStack,
  popCallStack,
  isJump,
  jumpType,
  jumpIndir,
  isIPRel
  );
  
  parameter [0:0] thread;
  localparam INSTR_WIDTH=80;
  localparam INSTRQ_WIDTH=`instrQ_width;
  localparam EXTRACONST_WIDTH=`extraconst_width;
  localparam OPERATION_WIDTH=`operation_width;
  localparam REG_WIDTH=6;
  localparam IP_WIDTH=48;
  localparam REG_BP=5;
  localparam REG_SP=4;
  localparam PORT_LOAD=3'd1;
  localparam PORT_STORE=3'd2;
  localparam PORT_SHIFT=3'd3;
  localparam PORT_ALU=3'd4;
  localparam PORT_MUL=3'd5;
  
  input clk;
  input rst;
  input mode64;
  
  input [INSTR_WIDTH-1:0] instr;
  input [3:0] magic;
  input [11:0] class_;
  input isAvx;
  
  output reg [63:0] constant;
  
  output reg pushCallStack;
  output reg popCallStack;
  output isJump;
  output reg [4:0] jumpType;
  output jumpIndir;
  
  output reg isIPRel;
  
  wire [7:0] opcode_main;

  wire isBasicCmpTest;
  wire isCmpTestExtra;   
  

  wire isBasicCJump;
  wire isInvCJumpLong;
  wire isSelfTestCJump;
  wire isLongCondJump;
  wire isUncondJump;
  
  wire isIndirJump;
  wire isCall;
  wire isRet;
  
  wire isJalR;
 
  wire isShlAddMulLike; 
  wire isBasicSysInstr;
  
  reg error;
  
  reg keep2instr;
  
  wire [31:0] constantDef;


  reg isBigConst;

  wire subIsCJ;
  
  
  assign jumpIndir=class_[`iclass_indir];
  assign isJump=class_[`iclass_jump] || class_[`iclass_indir];

  assign opcode_main=instr[7:0];
  
  assign constantDef=(magic[1:0]==2'b11) ? {instr[47:17],1'b0} : 32'bz;
  assign constantDef=(magic[1:0]==2'b01) ? {{17{instr[31]}},instr[31:18],1'b0} : 32'bz;
  assign constantDef=(~magic[0]) ? {27'b0,instr[7],instr[15:12]} : 32'bz;
  
  
  assign isBasicCmpTest=(opcode_main[7:1]==7'd23 || opcode_main[7:2]==6'd12 ||
    opcode_main[7:1]==7'd26)&magic[0];


  assign isBasicCJump=(opcode_main[7:4]==4'b1010)&magic[0];
  assign isSelfTestCJump=(opcode_main==8'd178 || opcode_main==8'd179)&magic[0];
  assign isLongCondJump=(opcode_main==8'd180)&magic[0];
  assign isUncondJump=(opcode_main==8'd181)&magic[0];
  assign isIndirJump=(opcode_main==8'd182 && instr[15:13]==3'd0)&magic[0];
  assign isCall=(opcode_main==8'd182 && (instr[15:13]==3'd1 || instr[15:13]==3'd2))&magic[0];
  assign isRet=(opcode_main==8'd182 && instr[15:13]==3'd3)&magic[0];
  assign subIsCJ=(opcode_main[5:2]==4'b1100)&~magic[0];
  assign isShlAddMulLike=(opcode_main==8'd210 || opcode_main==8'd211) && magic[1:0]==2'b01;

 // assign isCmpTestExtra=(opcode_main==198 && magic[1:0]==2'b01 && instr[31:29]==3'd1)&magic[0];
  
  
  assign isBasicSysInstr=(opcode_main==8'hff)&magic[0];
  
  always @*
  begin
      constant[31:0]=constantDef;
      constant[63:32]={32{constant[31]}};
      isBigConst=magic[2:0]==3'b111;
      isIPRel=1'b0;
      error=(|magic[3:2])&(&magic[1:0]); 
      jumpType=5'b10000;
      pushCallStack=1'b0;
      popCallStack=1'b0;
      if (subIsCJ) begin
          constant={{55{instr[15]}},instr[15:8],1'b0};
          jumpType={1'b0,instr[7:6],instr[1:0]};
          if ({instr[7:6],instr[1:0]}==4'hf) jumpType=5'h10; //uc jump intead of nP 
      end else if (isBasicCJump) begin
          jumpType={1'b0,(magic[1:0]==2'b01) ? instr[18] : instr[32],opcode_main[3:1]};  
          if (magic[1:0]==2'b01) constant={{50{instr[31]}},instr[31:19],1'b0};    
          else if (magic[2:0]==3'b011) constant={{48{instr[47]}},instr[47:33],1'b0};
          else if (magic[3:0]==4'b0111) begin error=0; constant={{32{instr[63]}},instr[63:33],1'b0}; end
      end else if (isLongCondJump) begin
          jumpType={1'b0,instr[11:8]};
          constant[0]=1'b0;
          if (magic[1:0]==2'b01) begin
              constant={{43{instr[31]}},instr[31:12],1'b0};
          end 
      end else if (isSelfTestCJump) begin
          //warning: if magic is 0 then error
          constant[0]=1'b0;
          jumpType={1'b0,instr[11:8]};
          
      end else if (isUncondJump) begin
          jumpType=5'b10000;
          constant[0]=1'b0;
          if (magic[1:0]==2'b01) begin
              constant={{39{instr[31]}},instr[31:8],1'b0};
          end 
      end else if (isIndirJump) begin
          jumpType=5'b10001;
      end else if (isCall) begin
          isIPRel=1'b1;
          pushCallStack=1'b1;
          if (magic[1:0]==2'b01) constant={{47{instr[31]}},instr[31:16],1'b0};
          jumpType=5'b10000;
      end else if (isRet) begin
          popCallStack=1'b1;
          jumpType=5'b10001;
      end else if (isShlAddMulLike&&instr[28]) begin 
          jumpType={1'b0,4'h0};
	  constant={{43{instr[27]}},instr[27:8],1'b0};
      end else if (isBasicSysInstr) begin
//          if (instr[15:8]==8'hff && ~magic[0]) halt=1'b1;
          if (instr[15:13]==3'b0) begin
        //  if (magic[0]) error=1;
              jumpType=5'b11001;
              constant={48'b0,thread,instr[30:16]};
          end else if (instr[15:13]==3'd2) begin
              jumpType=5'b10001;
              constant={48'b0,thread,instr[30:16]};
          end
      end
      

  end


endmodule

