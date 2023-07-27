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

//dcache1_ram read during write behaviour: write first
module dcache1_ram(
  clk,
  rst,
  read_nClkEn,
  read_addr,
  read_data,
  write_addr,
  write_data,
  write_wen,
  write_ben
  );
  `ifdef DCACHE_256K
  localparam ADDR_WIDTH=7;
  localparam ADDR_COUNT=128;
  `else
  localparam ADDR_WIDTH=6;
  localparam ADDR_COUNT=64;
  `endif
  localparam DATA_WIDTH=`dcache1_data_width;
  
  input clk;
  input rst;
  input read_nClkEn;
  input [ADDR_WIDTH-1:0] read_addr;
  output [DATA_WIDTH-1:0] read_data;
  input [ADDR_WIDTH-1:0] write_addr;
  input [DATA_WIDTH-1:0] write_data;
  input write_wen;
  input [3:0] write_ben;

  reg [DATA_WIDTH-1:0] ram [ADDR_COUNT-1:0];
  reg [ADDR_WIDTH-1:0] read_addr_reg;
  
  assign read_data=ram[read_addr_reg];

  always @(negedge clk)
    begin
      if (rst) read_addr_reg<={ADDR_WIDTH{1'b0}};
      else if (!read_nClkEn) read_addr_reg<=read_addr; 
      if (write_wen & write_ben[0]) ram[write_addr][8:0]<=write_data[8:0];
      if (write_wen & write_ben[1]) ram[write_addr][17:9]<=write_data[17:9];
      if (write_wen & write_ben[2]) ram[write_addr][26:18]<=write_data[26:18];
      if (write_wen & write_ben[3]) ram[write_addr][35:27]<=write_data[35:27];
    end

endmodule


module dcache1_bank(
  clk,
  rst,
  read_addrE0, read_hitE0, 
  read_addrO0, read_hitO0, 
  read_bankEn0,read_odd0,
  read_addrE1, read_hitE1, 
  read_addrO1, read_hitO1, 
  read_bankEn1,read_odd1,
  read_addrE2, read_hitE2, 
  read_addrO2, read_hitO2, 
  read_bankEn2,read_odd2,
  read_addrE3, read_hitE3, 
  read_addrO3, read_hitO3, 
  read_bankEn3,read_odd3,
  none_bankEn,
  bank_hit,
  read_data,
  read_data_in,
  read_err,
  read_err_in,
  write_addrE0, write_hitE0,
  write_addrO0, write_hitO0,
  write_bankEn0, 
  write_begin0,write_end0,
  write_bBen0,write_enBen0,
  write_addrE1, write_hitE1,
  write_addrO1, write_hitO1,
  write_bankEn1,
  write_begin1,write_end1,
  write_bBen1,write_enBen1,
  write_data,
  ins_hit,
  init
  );
  localparam ADDR_WIDTH=6;
  localparam DATA_WIDTH=`dcache1_data_width;
  parameter INDEX=0;
  parameter [0:0] TOP=0;
  input clk;
  input rst;
  input [ADDR_WIDTH-1:0] read_addrE0;
  input read_hitE0; //+1 cycle
  input [ADDR_WIDTH-1:0] read_addrO0;
  input read_hitO0; //+1 cycle
  input read_bankEn0;
  input read_odd0;
  input [ADDR_WIDTH-1:0] read_addrE1;
  input read_hitE1; //+1 cycle
  input [ADDR_WIDTH-1:0] read_addrO1;
  input read_hitO1; //+1 cycle
  input read_bankEn1;
  input read_odd1;
  input [ADDR_WIDTH-1:0] read_addrE2;
  input read_hitE2; //+1 cycle
  input [ADDR_WIDTH-1:0] read_addrO2;
  input read_hitO2; //+1 cycle
  input read_bankEn2;
  input read_odd2;
  input [ADDR_WIDTH-1:0] read_addrE3;
  input read_hitE3; //+1 cycle
  input [ADDR_WIDTH-1:0] read_addrO3;
  input read_hitO3; //+1 cycle
  input read_bankEn3;
  input read_odd3;
  input none_bankEn;
  output bank_hit;
  output [DATA_WIDTH-1:0] read_data;
  input [DATA_WIDTH-1:0] read_data_in;
  output read_err;
  input read_err_in;

  input [ADDR_WIDTH-1:0] write_addrE0;
  input write_hitE0; //+1 cycle
  input [ADDR_WIDTH-1:0] write_addrO0;
  input write_hitO0; //+1 cycle
  input write_bankEn0;
  input [4:0] write_begin0;
  input [4:0] write_end0;
  input [3:0] write_bBen0;
  input [3:0] write_enBen0;
  input [ADDR_WIDTH-1:0] write_addrE1;
  input write_hitE1; //+1 cycle
  input [ADDR_WIDTH-1:0] write_addrO1;
  input write_hitO1; //+1 cycle
  input write_bankEn1;
  input [4:0] write_begin1;
  input [4:0] write_end1;
  input [3:0] write_bBen1;
  input [3:0] write_enBen1;
  input [DATA_WIDTH-1:0] write_data;
  input ins_hit;
  input init;
  
  wire [1:0][ADDR_WIDTH-1:0] read_addr;
  wire [1:0][DATA_WIDTH-1:0] read_data_ram;
  wire enE,enO;
  wire onE,onO;
  wire [DATA_WIDTH-1:0] read_dataP;

  reg read_bankEn0_reg;
  reg read_bankEn1_reg;
  reg read_bankEn2_reg;
  reg read_bankEn3_reg;

  reg read_odd0_reg;
  reg read_odd1_reg;
  reg read_odd2_reg;
  reg read_odd3_reg;

  wire [ADDR_WIDTH-1:0] write_addrO;
  wire [ADDR_WIDTH-1:0] write_addrE;
  wire write_bankEn;
  wire [3:0] write_ben;
  wire [1:0] error;
  
  
  assign enE=read_hitE0 & read_bankEn0_reg || read_hitE1 & read_bankEn1_reg || read_hitE2 & read_bankEn2_reg || read_hitE3 & read_bankEn3_reg;
  assign enO=read_hitO0 & read_bankEn0_reg || read_hitO1 & read_bankEn1_reg || read_hitO2 & read_bankEn2_reg || read_hitO3 & read_bankEn3_reg;

//  assign onE=~read_odd0_reg & read_bankEn0_reg || ~read_odd1_reg & read_bankEn1_reg || ~read_odd2_reg & read_bankEn2_reg || ~read_odd3_reg & read_bankEn3_reg;
//  assign onO=read_odd0_reg & read_bankEn0_reg || read_odd1_reg & read_bankEn1_reg || read_odd2_reg & read_bankEn2_reg || read_odd3_reg & read_bankEn3_reg;

  assign read_addr[0]=read_bankEn0 ? read_addrE0 : 'z;
  assign read_addr[0]=read_bankEn1 ? read_addrE1 : 'z;
  assign read_addr[0]=read_bankEn2 ? read_addrE2 : 'z;
  assign read_addr[0]=read_bankEn3 ? read_addrE3 : 'z;
  assign read_addr[0]=none_bankEn ? {ADDR_WIDTH{1'b0}} : 'z;

  assign read_addr[1]=read_bankEn0 ? read_addrO0 : 'z;
  assign read_addr[1]=read_bankEn1 ? read_addrO1 : 'z;
  assign read_addr[1]=read_bankEn2 ? read_addrO2 : 'z;
  assign read_addr[1]=read_bankEn3 ? read_addrO3 : 'z;
  assign read_addr[1]=none_bankEn ? {ADDR_WIDTH{1'b0}} : 'z;

  assign write_addrE=write_bankEn0 ? write_addrE0 : write_addrE1;
  assign write_addrO=write_bankEn0 ? write_addrO0 : write_addrO1;
  assign write_bankEn=write_bankEn0 | write_bankEn1;
 
  assign write_ben=(write_bankEn0 && write_begin0==INDEX && ~init) ? write_bBen0 : 4'bz;
  assign write_ben=(write_bankEn0 && write_end0==INDEX && ~init) ?   write_enBen0 : 4'bz;
  assign write_ben=((write_bankEn0 && write_begin0!=INDEX && write_end0!=INDEX) || init) ? 4'b1111 : 4'bz;
  assign write_ben=(write_bankEn1 && write_begin1==INDEX && ~init) ? write_bBen1 : 4'bz;
  assign write_ben=(write_bankEn1 && write_end1==INDEX && ~init) ?   write_enBen1 : 4'bz;
  assign write_ben=(write_bankEn1 && write_begin1!=INDEX && write_end1!=INDEX && ~init) ? 4'b1111 : 4'bz;
  assign write_ben=(~write_bankEn1 && ~write_bankEn0 && ~init) ? 4'b0 : 4'bz;
  
  assign bank_hit=enE | enO;

  assign error[0]=^read_data_ram[0][8:0]|^read_data_ram[0][17:9]|^read_data_ram[0][26:18]|^read_data_ram[0][35:27];
  assign error[1]=^read_data_ram[1][8:0]|^read_data_ram[1][17:9]|^read_data_ram[1][26:18]|^read_data_ram[1][35:27];

  wire read_errX;
  
  dcache1_ram ramE_mod(
  .clk(clk),
  .rst(rst),
  .read_nClkEn(none_bankEn),
  .read_addr(read_addr[0]),
  .read_data(read_data_ram[0]),
  .write_addr(write_addrE),
  .write_data(write_data),
  .write_wen((write_bankEn && write_hitE0|write_hitE1)|init|(ins_hit&~read_odd0_reg)),
  .write_ben(write_ben)
  );

  dcache1_ram ramO_mod(
  .clk(clk),
  .rst(rst),
  .read_nClkEn(none_bankEn),
  .read_addr(read_addr[1]),
  .read_data(read_data_ram[1]),
  .write_addr(write_addrO),
  .write_data(write_data),
  .write_wen((write_bankEn && write_hitO0|write_hitO1)|init|(ins_hit&read_odd0_reg)),
  .write_ben(write_ben)
  );
  
  generate
    if (~TOP) begin
        assign read_dataP=(enE & ~ins_hit) ? read_data_ram[0] : 'z;
        assign read_dataP=(enO & ~ins_hit) ? read_data_ram[1] : 'z;
        assign read_dataP=(~bank_hit | ins_hit) ? {DATA_WIDTH{1'B0}} : 'z;

        assign read_errX=(enE & ~ins_hit) ? error[0] : 'z;
        assign read_errX=(enO & ~ins_hit) ? error[1] : 'z;
        assign read_errX=(~bank_hit | ins_hit) ? 1'b0 : 'z;
  
        assign read_data=~(read_dataP|read_data_in);  
        assign read_err=~(read_errX|read_err_in);  
    end else begin
        assign read_dataP=(enE & ~ins_hit) ? ~read_data_ram[0] : 'z;
        assign read_dataP=(enO & ~ins_hit) ? ~read_data_ram[1] : 'z;
        assign read_dataP=(~bank_hit | ins_hit) ? {DATA_WIDTH{1'B1}} : 'z;

        assign read_errX=(enE & ~ins_hit) ? ~error[0] : 'z;
        assign read_errX=(enO & ~ins_hit) ? ~error[1] : 'z;
        assign read_errX=(~bank_hit | ins_hit) ? 1'B1 : 'z;
  
        assign read_data=~(read_dataP&read_data_in);  
        assign read_err=~(read_errX&read_err_in);  
    end
  endgenerate
  always @(negedge clk)
    begin
      if (rst)
        begin
          read_bankEn0_reg<=1'b0;
          read_bankEn1_reg<=1'b0;
          read_bankEn2_reg<=1'b0;
          read_bankEn3_reg<=1'b0;
          read_odd0_reg<=1'b0;
          read_odd1_reg<=1'b0;
          read_odd2_reg<=1'b0;
          read_odd3_reg<=1'b0;
        end
      else
        begin
          read_bankEn0_reg<=read_bankEn0;
          read_bankEn1_reg<=read_bankEn1;
          read_bankEn2_reg<=read_bankEn2;
          read_bankEn3_reg<=read_bankEn3;
          read_odd0_reg<=read_odd0;
          read_odd1_reg<=read_odd1;
          read_odd2_reg<=read_odd2;
          read_odd3_reg<=read_odd3;
        end
    end
  
endmodule


//dcache1_way compiled into a hard macro (1 for odd, 1 for even).
//DO NOT delete the inverted IO from the hard macro block
//use 1 x2 layer horizontal
module dcache1_way(
  clk,
  rst,
  read_addrE0, read_addrO0, read_bank0, read_clkEn0, read_hit0, 
    read_odd0, read_split0, read_pbit0, read_pbit0_in, read0_err,
  read_addrE1, read_addrO1, read_bank1, read_clkEn1, read_hit1,   
    read_odd1, read_split1, read_pbit1, read_pbit1_in, read1_err,
  read_addrE2, read_addrO2, read_bank2, read_clkEn2, read_hit2,   
    read_odd2, read_split2, read_pbit2, read_pbit2_in, read2_err,
  read_addrE3, read_addrO3, read_bank3, read_clkEn3, read_hit3,   
    read_odd3, read_split3, read_pbit3, read_pbit3_in, read3_err,
  read_bankNoRead,
  read_invalidate,
  read_bankHit,
  read_data,
  read_data_in,
  read_err,
  read_err_in,
  read_begin0,
  read_begin1,
  read_begin2,
  read_begin3,
  write_addrE0,
  write_addrO0,
  write_bank0,
  write_begin0,write_end0,
  write_bBen0,write_enBen0,
  write_clkEn0,
  write_hit0,
  write_hitCl0,
  write_dupl0,
  write_split0,
  write_pbit0,write_d128_0,
  write_odd0,
  write0_err,
  write_addrE1,
  write_addrO1,
  write_bank1,
  write_begin1,write_end1,
  write_bBen1,write_enBen1,
  write_clkEn1,
  write_hit1,
  write_hitCl1,
  write_dupl1,
  write_split1,
  write_pbit1,write_d128_1,
  write_odd1,
  write1_err,
  write_insert,
  write_insertExclusive,
  write_insertDirty,
  write_data,
  write_dataPTR,
  err_tag,
  recent_in,
  recent_out,
  insert_rand,
  insert_hit,
  wb_addr,
  wb_valid,
  puke_addr,
  puke_en
  );
  localparam ADDR_WIDTH=37;
  localparam DATA_WIDTH=`dcache1_data_width;
  localparam TAG_WIDTH=`dc1Tag_width;
  localparam BANK_COUNT=32;
  localparam LINE_WIDTH=DATA_WIDTH*BANK_COUNT;
  localparam RAM_ADDR_WIDTH=`dcache1_addr_width;
  parameter [2:0] INDEX=0;
  
  input clk;
  input rst;
  
  input [ADDR_WIDTH-2:0] read_addrE0;
  input [ADDR_WIDTH-2:0] read_addrO0;
  input [BANK_COUNT-1:0] read_bank0;
  input read_clkEn0;
  output [1:0] read_hit0;
  input read_odd0;
  input read_split0;
  output [1:0] read_pbit0;
  input [1:0] read_pbit0_in;
  output read0_err;
  
  input [ADDR_WIDTH-2:0] read_addrE1;
  input [ADDR_WIDTH-2:0] read_addrO1;
  input [BANK_COUNT-1:0] read_bank1;
  input read_clkEn1;
  output [1:0] read_hit1;
  input read_odd1;
  input read_split1;
  output [1:0] read_pbit1;
  input [1:0] read_pbit1_in;
  output read1_err;
  
  input [ADDR_WIDTH-2:0] read_addrE2;
  input [ADDR_WIDTH-2:0] read_addrO2;
  input [BANK_COUNT-1:0] read_bank2;
  input read_clkEn2;
  output [1:0] read_hit2;
  input read_odd2;
  input read_split2;
  output [1:0] read_pbit2;
  input [1:0] read_pbit2_in;
  output read2_err;

  input [ADDR_WIDTH-2:0] read_addrE3;
  input [ADDR_WIDTH-2:0] read_addrO3;
  input [BANK_COUNT-1:0] read_bank3;
  input read_clkEn3;
  output [1:0] read_hit3;
  input read_odd3;
  input read_split3;
  output [1:0] read_pbit3;
  input [1:0] read_pbit3_in;
  output read3_err;
  
  input [BANK_COUNT-1:0] read_bankNoRead;//bits are 1 if other bank reads are 0
  
  input read_invalidate; 

  output [BANK_COUNT-1:0] read_bankHit;
  
  output [LINE_WIDTH-1:0] read_data;
  input [LINE_WIDTH-1:0] read_data_in;
  output [31:0] read_err;
  input [31:0] read_err_in;
 
  input [4:0] read_begin0; 
  input [4:0] read_begin1; 
  input [4:0] read_begin2; 
  input [4:0] read_begin3; 

  input [ADDR_WIDTH-2:0] write_addrE0;
  input [ADDR_WIDTH-2:0] write_addrO0;
  input [BANK_COUNT-1:0] write_bank0;
  input [4:0] write_begin0;
  input [4:0] write_end0;
  input [3:0] write_bBen0;
  input [3:0] write_enBen0;
  input write_clkEn0;
  input write_hit0;
  input [1:0] write_pbit0;
  input write_d128_0;
  output [1:0] write_hitCl0;
  output [1:0] write_dupl0;
  input write_split0;
  input write_odd0;
  output write0_err;
  input [ADDR_WIDTH-2:0] write_addrE1;
  input [ADDR_WIDTH-2:0] write_addrO1;
  input [BANK_COUNT-1:0] write_bank1;
  input [4:0] write_begin1;
  input [4:0] write_end1;
  input [3:0] write_bBen1;
  input [3:0] write_enBen1;
  input write_clkEn1;
  input write_hit1;
  input [1:0] write_pbit1;
  input write_d128_1;
  output [1:0] write_hitCl1;
  output [1:0] write_dupl1;
  input write_split1;
  input write_odd1;
  output write1_err;
  
  input write_insert;    
  input write_insertExclusive;
  input write_insertDirty;
  input [LINE_WIDTH-1:0] write_data;
  input [15:0] write_dataPTR;
  


  
  output [5:0] err_tag;
  
  input recent_in;
  output recent_out;
  input [5:0] insert_rand;

  output insert_hit;
 
  output [ADDR_WIDTH-1:0] wb_addr;
  output wb_valid;  
  input [5:0][6:0] puke_addr;
  input [5:0] puke_en;
  
  wire [3:0] recent;
  
  wire [5:0] ins_hit;
  wire [5:0] errH;
  wire [5:0] errL;
  wire dirtyE,dirtyO;
  
  reg [4:0] write_begin0_reg;
  reg [4:0] write_end0_reg;
  reg [3:0] write_bBen0_reg;
  reg [3:0] write_enBen0_reg;
  reg [4:0] write_begin1_reg;
  reg [4:0] write_end1_reg;
  reg [3:0] write_bBen1_reg;
  reg [3:0] write_enBen1_reg;

  wire [3:0] read_hitEL;
  wire [3:0] read_hitOL;
  wire [3:0] read_hitEH;
  wire [3:0] read_hitOH;
  wire [3:0] read_hitE;
  wire [3:0] read_hitO;

  wire [1:0] write_hitEL;
  wire [1:0] write_hitOL;
  wire [1:0] write_hitEH;
  wire [1:0] write_hitOH;

  wire [3:0] read_clkEn={read_clkEn3,read_clkEn2,read_clkEn1,read_clkEn0};
  wire [3:0] read_odd={read_odd3,read_odd2,read_odd1,read_odd0};
  wire [3:0] read_split={read_split3,read_split2,read_split1,read_split0};
  
  wire [ADDR_WIDTH-2:0] read_addrE[3:0];
  wire [ADDR_WIDTH-2:0] read_addrO[3:0];
 
  wire [1:0] write_clkEn={write_clkEn1,write_clkEn0};
  wire [ADDR_WIDTH-2:0] write_addrO[1:0];
  wire [ADDR_WIDTH-2:0] write_addrE[1:0];
  wire [1:0] write_odd={write_odd1,write_odd0};
  wire [1:0] write_split={write_split1,write_split0};
  
  reg read_odd0_reg,read_odd1_reg,read_odd2_reg,read_odd3_reg;
  reg read_split0_reg,read_split1_reg,read_split2_reg,read_split3_reg;
  reg write_odd0_reg,write_odd1_reg;
  reg write_split0_reg,write_split1_reg;
  reg write_insert_reg;
  
  reg read_invalidate_reg;
  
  wire write_reqE0,write_reqO0;
  wire write_reqE1,write_reqO1;
  
  reg write_clkEn0_reg,write_clkEn1_reg;
  reg write_clkEn0_reg2,write_clkEn1_reg2;

  reg [ADDR_WIDTH-2:0] write_addrE0_reg;
  reg [ADDR_WIDTH-2:0] write_addrO0_reg;
  reg [ADDR_WIDTH-2:0] write_addrE1_reg;
  reg [ADDR_WIDTH-2:0] write_addrO1_reg;
  reg [ADDR_WIDTH-2:0] read_addrE0_reg;
  reg [ADDR_WIDTH-2:0] read_addrO0_reg;
  reg read_clkEn0_reg;
  wire [1:0] write_hitO;
  wire [1:0] write_hitE;
  reg ins_hit_reg;
 
  wire [1:0] write_dupl[1:0];
  
  wire [1:0] read_pbit0P;
  wire [1:0] read_pbit1P;
  wire [1:0] read_pbit2P;
  wire [1:0] read_pbit3P;
  
  wire [1:0] read0_pbitP;
  wire [1:0] read1_pbitP;
  wire [1:0] read2_pbitP;
  wire [1:0] read3_pbitP;
 
  reg init;
  reg init_dirty;
  `ifdef DCACHE_256K
  reg [6:0] initCount;
  wire [6:0] initCount_d;
  `else
  reg [5:0] initCount;
  wire [5:0] initCount_d;
  `endif
  //verilator lint_off WIDTH
  dc1_xbit pbit_mod(
  .clk(clk),
  .rst(rst),
  .read0_clkEn(1'b1),.read0_addrO({read_addrO0[6:0],read_begin0[4:1]}),
  .read0_addrE({read_addrE0[6:0],read_begin0[4:1]}),.read0_odd(read_odd0),.read0_pbit(read0_pbitP),
  .read1_clkEn(1'b1),.read1_addrO({read_addrO1[6:0],read_begin1[4:1]}),
  .read1_addrE({read_addrE1[6:0],read_begin1[4:1]}),.read1_odd(read_odd1),.read1_pbit(read1_pbitP),
  .read2_clkEn(1'b1),.read2_addrO({read_addrO2[6:0],read_begin2[4:1]}),
  .read2_addrE({read_addrE2[6:0],read_begin2[4:1]}),.read2_odd(read_odd2),.read2_pbit(read2_pbitP),
  .read3_clkEn(1'b1),.read3_addrO({read_addrO3[6:0],read_begin3[4:1]}),
  .read3_addrE({read_addrE3[6:0],read_begin3[4:1]}),.read3_odd(read_odd3),.read3_pbit(read3_pbitP),
  .write0_clkEn(1'b1),.write0_addrO({write_addrO0[6:0],write_begin0[4:1]}),
  .write0_addrE({write_addrE0[6:0],write_begin0[4:1]}),.write0_odd(write_odd0),.write0_pbit(write_pbit0),
  .write0_d128(write_d128_0),
  .write1_clkEn(1'b1),.write1_addrO({write_addrO1[6:0],write_begin1[4:1]}),
  .write1_addrE({write_addrE1[6:0],write_begin1[4:1]}),.write1_odd(write_odd1),.write1_pbit(write_pbit1),
  .write1_d128(write_d128_1),
  .write_ins(ins_hit),.write_data(write_dataPTR));
  //verilator lint_on WIDTH
  generate
    genvar b,r,w;
    if (~INDEX[0]) begin
        assign read_pbit0=~(read_pbit0P|read_pbit0_in);  
        assign read_pbit1=~(read_pbit1P|read_pbit1_in);  
        assign read_pbit2=~(read_pbit2P|read_pbit2_in);  
        assign read_pbit3=~(read_pbit3P|read_pbit3_in);  
        
        assign read_pbit0P=read0_pbitP&{2{(read_hitE[0]&~read_odd0_reg||read_hitO[0]&read_odd0_reg)}};
        assign read_pbit1P=read1_pbitP&{2{(read_hitE[1]&~read_odd1_reg||read_hitO[1]&read_odd1_reg)}};
        assign read_pbit2P=read2_pbitP&{2{(read_hitE[2]&~read_odd2_reg||read_hitO[2]&read_odd2_reg)}};
        assign read_pbit3P=read3_pbitP&{2{(read_hitE[3]&~read_odd3_reg||read_hitO[3]&read_odd3_reg)}};

	assign read_dataN=~((read_data)&read_dataN_in);
    end else begin
        assign read_pbit0=~(read_pbit0P&read_pbit0_in);  
        assign read_pbit1=~(read_pbit1P&read_pbit1_in);  
        assign read_pbit2=~(read_pbit2P&read_pbit2_in);  
        assign read_pbit3=~(read_pbit3P&read_pbit3_in);  

        assign read_pbit0P=~read0_pbitP|{2{~(read_hitE[0]&~read_odd0_reg||read_hitO[0]&read_odd0_reg)}};
        assign read_pbit1P=~read1_pbitP|{2{~(read_hitE[1]&~read_odd1_reg||read_hitO[1]&read_odd1_reg)}};
        assign read_pbit2P=~read2_pbitP|{2{~(read_hitE[2]&~read_odd2_reg||read_hitO[2]&read_odd2_reg)}};
        assign read_pbit3P=~read3_pbitP|{2{~(read_hitE[3]&~read_odd3_reg||read_hitO[3]&read_odd3_reg)}};
	assign read_dataN=~((read_data)|read_dataN_in);
    end
    for (b=0;b<BANK_COUNT;b=b+1) begin : banks

       if (b<16) begin : banks_low
/* verilator lint_off WIDTH */
          dcache1_bank #(b,INDEX[0]) bank_mod(
          clk,
          rst,
          read_addrE0[6:0], read_hitEL[0], 
          read_addrO0[6:0], read_hitOL[0], 
          read_bank0[b],read_odd0,
          read_addrE1[6:0], read_hitEL[1], 
          read_addrO1[6:0], read_hitOL[1], 
          read_bank1[b],read_odd1,
          read_addrE2[6:0], read_hitEL[2], 
          read_addrO2[6:0], read_hitOL[2], 
          read_bank2[b],read_odd2,
          read_addrE3[6:0], read_hitEL[3], 
          read_addrO3[6:0], read_hitOL[3], 
          read_bank3[b],read_odd3,
          read_bankNoRead[b],
          read_bankHit[b],
          read_data[DATA_WIDTH*b+:DATA_WIDTH],
          read_data_in[DATA_WIDTH*b+:DATA_WIDTH],
          write_addrE0_reg[6:0], write_hitEL[0] && write_hit0,
          write_addrO0_reg[6:0], write_hitOL[0] && write_hit0,
          write_bank0[b], 
          write_begin0_reg,write_end0_reg,
          write_bBen0_reg,write_enBen0_reg,
          write_addrE1_reg[6:0], write_hitEL[1] && write_hit0 && write_hit1,
          write_addrO1_reg[6:0], write_hitOL[1] && write_hit0 && write_hit1,
          write_bank1[b],
          write_begin1_reg,write_end1_reg,
          write_bBen1_reg,write_enBen1_reg,
          (write_data[DATA_WIDTH*b+:DATA_WIDTH]|~write_dataN[DATA_WIDTH*b+:DATA_WIDTH])&{DATA_WIDTH{~init}},
          ins_hit[0],
          init
          );
/* verilator lint_on WIDTH */
       end else begin : banks_hi
/* verilator lint_off WIDTH */
          dcache1_bank #(b,INDEX[0]) bank_mod(
          clk,
          rst,
          read_addrE0[6:0], read_hitEH[0], 
          read_addrO0[6:0], read_hitOH[0], 
          read_bank0[b],read_odd0,
          read_addrE1[6:0], read_hitEH[1], 
          read_addrO1[6:0], read_hitOH[1], 
          read_bank1[b],read_odd1,
          read_addrE2[6:0], read_hitEH[2], 
          read_addrO2[6:0], read_hitOH[2], 
          read_bank2[b],read_odd2,
          read_addrE3[6:0], read_hitEH[3], 
          read_addrO3[6:0], read_hitOH[3], 
          read_bank3[b],read_odd3,
          read_bankNoRead[b],
          read_bankHit[b],
          read_data[DATA_WIDTH*b+:DATA_WIDTH],
          read_data_in[DATA_WIDTH*b+:DATA_WIDTH],
          write_addrE0_reg[6:0], write_hitEH[0] && write_hit0,
          write_addrO0_reg[6:0], write_hitOH[0] && write_hit0,
          write_bank0[b], 
          write_begin0_reg,write_end0_reg,
          write_bBen0_reg,write_enBen0_reg,
          write_addrE1_reg[6:0], write_hitEH[1] && write_hit0 && write_hit1,
          write_addrO1_reg[6:0], write_hitOH[1] && write_hit0 && write_hit1,
          write_bank1[b],
          write_begin1_reg,write_end1_reg,
          write_bBen1_reg,write_enBen1_reg,
          (write_data[DATA_WIDTH*b+:DATA_WIDTH]&~write_dataN[DATA_WIDTH*b+:DATA_WIDTH])&{DATA_WIDTH{~init}},
          ins_hit[0],
          init
          );
/* verilator lint_on WIDTH */
       end
    end
    for (r=0;r<4;r=r+1) begin : tagR_gen
        if (r>0)
        dcache1_tag #(INDEX) tagR_mod(
        .clk(clk),
        .rst(rst),
        .read_clkEn(read_clkEn[r] | write_insert),
        .read_en(read_clkEn[r]),
        .read_addrOdd(read_addrO[r]),.read_addrEven(read_addrE[r]),
        .read_odd(read_odd[r]), .read_split(read_split[r]), .read_invl(read_invalidate), 
        .read_hitL_odd(read_hitOL[r]),.read_hitL_even(read_hitEL[r]),
        .read_hitH_odd(read_hitOH[r]),.read_hitH_even(read_hitEH[r]),
        .read_hit_odd(read_hitO[r]),.read_hit_even(read_hitE[r]),
        .read_exclOut0(),.read_exclOut1(),//.read_excl(),
        .errH(errH[r]),.errL(errL[r]),
        .write_exclusive(write_insertExclusive),
        .write_rand(insert_rand),
        .write_recent_out(recent[r]),
        .write_recent_in(recent_in),
        .write_wen(write_insert),
        .write_hit(ins_hit[r]),
        .wb_addr(),
        .wb_valid(),
        .puke_en(puke_en),.puke_addr(puke_addr)
        );  
        else 
        dcache1_tag #(INDEX) tagR_mod(
        .clk(clk),
        .rst(rst),
        .read_clkEn(read_clkEn[r] | write_insert),
        .read_en(read_clkEn[r]),
        .read_addrOdd(read_addrO[r]),.read_addrEven(read_addrE[r]),
        .read_odd(read_odd[r]), .read_split(read_split[r]), .read_invl(read_invalidate), 
        .read_hitL_odd(read_hitOL[r]),.read_hitL_even(read_hitEL[r]),
        .read_hitH_odd(read_hitOH[r]),.read_hitH_even(read_hitEH[r]),
        .read_hit_odd(read_hitO[r]),.read_hit_even(read_hitE[r]),
        .read_exclOut0(),.read_exclOut1(),//.read_excl(),
        .errH(errH[r]),.errL(errL[r]),
        .write_exclusive(write_insertExclusive),
        .write_rand(insert_rand),
        .write_recent_out(recent[r]),
        .write_recent_in(recent_in),
        .write_wen(write_insert),
        .write_hit(ins_hit[r]),
        .wb_addr(wb_addr),
        .wb_valid(wb_valid),
        .puke_en(puke_en),.puke_addr(puke_addr)
        );  
    end

    for (w=0;w<2;w=w+1) begin : tagW_gen
        dcache1_tag #(INDEX) tagW_mod(
        .clk(clk),
        .rst(rst),
        .read_clkEn(write_clkEn[w] | write_insert),
        .read_en(write_clkEn[w]),
        .read_addrOdd(write_addrO[w]),.read_addrEven(write_addrE[w]),
        .read_odd(write_odd[w]), .read_split(write_split[w]), .read_invl(read_invalidate),
        .read_exclOut0(write_dupl[w][0]),.read_exclOut1(write_dupl[w][1]), 
        .read_hitL_odd(write_hitOL[w]),.read_hitL_even(write_hitEL[w]),
        .read_hitH_odd(write_hitOH[w]),.read_hitH_even(write_hitEH[w]),
        .read_hit_odd(write_hitO[w]),.read_hit_even(write_hitE[w]),
        //.read_excl(),
        .errH(errH[w+4]),.errL(errL[w+4]),
        .write_exclusive(write_insertExclusive),
        .write_rand(insert_rand),
        .write_recent_out(),
        .write_recent_in(recent_in),
        .write_wen(write_insert),
        .write_hit(ins_hit[w+4]),
        .wb_addr(),
        .wb_valid()
        .puke_en(puke_en),.puke_addr(puke_addr)
        ); 
        
    end
  endgenerate
  

  `ifdef DCACHE_256K
  adder_inc #(7) initAdd_mod(initCount,initCount_d,1'b1,);
  `else
  adder_inc #(6) initAdd_mod(initCount,initCount_d,1'b1,);
  `endif

  assign read_addrO[0]=read_addrO0;
  assign read_addrO[1]=read_addrO1;
  assign read_addrO[2]=read_addrO2;
  assign read_addrO[3]=read_addrO3;

  assign read_addrE[0]=read_addrE0;
  assign read_addrE[1]=read_addrE1;
  assign read_addrE[2]=read_addrE2;
  assign read_addrE[3]=read_addrE3;
 
  assign write_addrO[0]=write_addrO0;
  assign write_addrE[0]=write_addrE0;
  assign write_addrO[1]=write_addrO1;
  assign write_addrE[1]=write_addrE1;
  
  assign err_tag=errH|errL;  

  assign read_hit0={read_hitO[0],read_hitE[0]};
  assign read_hit1={read_hitO[1],read_hitE[1]};
  assign read_hit2={read_hitO[2],read_hitE[2]};
  assign read_hit3={read_hitO[3],read_hitE[3]};
 
  assign read0_err=errH[0]|errL[0];   
  assign read1_err=errH[1]|errL[1];   
  assign read2_err=errH[2]|errL[2];   
  assign read3_err=errH[3]|errL[3];   
  assign write0_err=errH[4]|errL[4];   
  assign write1_err=errH[5]|errL[5];   

  assign write_dupl0=~write_dupl[0] & {write_hitO[0],write_hitE[0]};
  assign write_dupl1=~write_dupl[1] & {write_hitO[1],write_hitE[1]};

  assign write_hitCl0[0]=write_hitE[0] & write_reqE0;
  assign write_hitCl0[1]=write_hitO[0] & write_reqO0;
  assign write_hitCl1[0]=write_hitE[1] & write_reqE1;
  assign write_hitCl1[1]=write_hitO[1] & write_reqO1;
  
  assign write_reqE0=(~write_odd0_reg | write_split0_reg) & write_clkEn0_reg;
  assign write_reqO0=(write_odd0_reg | write_split0_reg) & write_clkEn0_reg;
  assign write_reqE1=(~write_odd1_reg | write_split1_reg) & write_clkEn1_reg;
  assign write_reqO1=(write_odd1_reg | write_split1_reg) & write_clkEn1_reg;
  
  assign insert_hit=ins_hit[0];
  
  assign recent_out=|recent[2:0];
  
//  assign write_back=ins_hit[0] && (dirtyE & ~read_odd0_reg || dirtyO & read_odd0_reg);
//  assign write_back2=(|read_hit0) && read_invalidate_reg && dirtyE | dirtyO;
  
  always @(negedge clk) begin
      if (rst) begin
          read_odd0_reg<=1'b0;
          read_odd1_reg<=1'b0;
          read_odd2_reg<=1'b0;
          read_odd3_reg<=1'b0;
          write_odd0_reg<=1'b0;
          write_odd1_reg<=1'b0;
          read_split0_reg<=1'b0;
          read_split1_reg<=1'b0;
          read_split2_reg<=1'b0;
          read_split3_reg<=1'b0;
          write_split0_reg<=1'b0;
          write_split1_reg<=1'b0;
          write_insert_reg<=1'b0;
          read_invalidate_reg<=1'b0;
          write_clkEn0_reg<=1'b0;
          write_clkEn1_reg<=1'b0;
          write_addrE0_reg<=36'b0;
          write_addrO0_reg<=36'b0;
          write_addrE1_reg<=36'b0;
          write_addrO1_reg<=36'b0;
          read_addrE0_reg<=36'b0;
          read_addrO0_reg<=36'b0;
          read_clkEn0_reg<=1'b0;
          write_begin0_reg<=5'b0;
          write_end0_reg<=5'b0;
          write_bBen0_reg<=4'b0;
          write_enBen0_reg<=4'b0;
          write_begin1_reg<=5'b0;
          write_end1_reg<=5'b0;
          write_bBen1_reg<=4'b0;
          write_enBen1_reg<=4'b0;
          ins_hit_reg<=1'b0;
      end else begin
          if (read_clkEn0) read_odd0_reg<=read_odd0;
          if (read_clkEn1) read_odd1_reg<=read_odd1;
          if (read_clkEn2) read_odd2_reg<=read_odd2;
          if (read_clkEn3) read_odd3_reg<=read_odd3;
          if (write_clkEn0) write_odd0_reg<=write_odd0;
          if (write_clkEn1) write_odd1_reg<=write_odd1;
          if (read_clkEn0) read_split0_reg<=read_split0;
          if (read_clkEn1) read_split1_reg<=read_split1;
          if (read_clkEn2) read_split2_reg<=read_split2;
          if (read_clkEn3) read_split3_reg<=read_split3;
          if (write_clkEn0) write_split0_reg<=write_split0;
          if (write_clkEn1) write_split1_reg<=write_split1;
          write_insert_reg<=write_insert;
          read_invalidate_reg<=read_invalidate;
          write_clkEn0_reg<=write_clkEn0;
          write_clkEn1_reg<=write_clkEn1;
          write_addrE0_reg<=write_addrE0;
          write_addrO0_reg<=write_addrO0;
          write_addrE1_reg<=write_addrE1;
          write_addrO1_reg<=write_addrO1;
          read_addrE0_reg<=read_addrE0;
          read_addrO0_reg<=read_addrO0;
          read_clkEn0_reg<=read_clkEn0;
          write_begin0_reg<=write_begin0;
          write_end0_reg<=write_end0;
          write_bBen0_reg<=write_bBen0;
          write_enBen0_reg<=write_enBen0;
          write_begin1_reg<=write_begin1;
          write_end1_reg<=write_end1;
          write_bBen1_reg<=write_bBen1;
          write_enBen1_reg<=write_enBen1;
          ins_hit_reg<=ins_hit[0];
      end
     `ifdef DCACHE_256K
      if (rst) begin
          init<=1'b1;
          init_dirty<=1'b1;
          initCount<=7'b0;
      end else if (init) begin
          initCount<=initCount_d;
          if (initCount==7'h7f) init<=1'b0;
          if (initCount==7'hf) init_dirty<=1'b0;
      end
     `else
      if (rst) begin
          init<=1'b1;
          init_dirty<=1'b1;
          initCount<=6'b0;
      end else if (init) begin
          initCount<=initCount_d;
          if (initCount==6'd63) init<=1'b0;
          if (initCount==6'hf) init_dirty<=1'b0;
      end
      `endif
  end
    
endmodule


//module dcache1 compiled to hard-macro with extra 1 x2 layer vertical
//in addition to the dcache1_way horizontal x2 wire
//duplicated read_data?? outputs per instruction domain.
//outputs at same per bit distances as in LSU/ALU domains and the same spacing in
//between
//do not delete the inverted io

module dcache1(
  clk,
  rst,
  read_addrE0, read_addrO0, read_bank0, read_clkEn0, read_hit0, read_hitCl0, 
    read_odd0, read_split0, read_dataA0, read_dataX0, read_pbit0,
    read_beginA0, read_low0, read_sz0,
  read_addrE1, read_addrO1, read_bank1, read_clkEn1, read_hit1, read_hitCl1,   
    read_odd1, read_split1, read_dataA1, read_dataX1, read_pbit1,
    read_beginA1, read_low1, read_sz1,
  read_addrE2, read_addrO2, read_bank2, read_clkEn2, read_hit2, read_hitCl2,   
    read_odd2, read_split2, read_dataA2, read_dataX2, read_pbit2,
    read_beginA2,  read_low2, read_sz2,
  read_addrE3, read_addrO3, read_bank3, read_clkEn3, read_hit3, read_hitCl3,   
    read_odd3, read_split3, read_dataA3, read_dataX3, read_pbit3,
    read_beginA3, read_low3, read_sz3,
  read_bankNoRead,
  read_invalidate,
  write_addrE0,
  write_addrO0,
  write_bank0,
  write_clkEn0,
  write_hit0,
  write_hitCl0,
  write_dupl0,
  write_split0,
  write_odd0,
  write_begin0,
  write_end0,
  write_bgnBen0,
  write_endBen0,
  write_data0,
  write_dataM0,
  write_pbit0,
  write_d128_0,
  write_addrE1,
  write_addrO1,
  write_bank1,
  write_clkEn1,
  write_hit1,
  write_hitCl1,
  write_dupl1,
  write_split1,
  write_odd1,
  write_begin1,
  write_end1,
  write_bgnBen1,
  write_endBen1,
  write_data1,
  write_dataM1,
  write_pbit1,
  write_d128_1,
  write_clear,
  insert_en,
  insert_from_ram,
  insert_exclusive,
  insert_dirty,
//  wb_en,
//  busWb_data,
  busIns_data,
  busIns_dataPTR,
  insbus_A,insbus_B,
  expun_addr,expun_en
  );
  localparam ADDR_WIDTH=37;
  localparam DATA_WIDTH=`dcache1_data_width;
  localparam TAG_WIDTH=`dc1Tag_width;
  localparam BANK_COUNT=32;
  localparam LINE_WIDTH=DATA_WIDTH*BANK_COUNT;
  localparam RAM_ADDR_WIDTH=`dcache1_addr_width;
  localparam WLINE_WIDTH=1024;
/*verilator hier_block*/
  
  input clk;
  input rst;
  
  input [ADDR_WIDTH-2:0] read_addrE0;
  input [ADDR_WIDTH-2:0] read_addrO0;
  input [BANK_COUNT-1:0] read_bank0;
  input read_clkEn0;
  output reg read_hit0;
  output reg [1:0] read_hitCl0;
  input read_odd0;
  input read_split0;
  output [127+8:0] read_dataA0;
  output [127+8:0] read_dataX0;
  output [1:0] read_pbit0;
  input [4:0] read_beginA0;
  input [1:0] read_low0;
  input [4:0] read_sz0;

  input [ADDR_WIDTH-2:0] read_addrE1;
  input [ADDR_WIDTH-2:0] read_addrO1;
  input [BANK_COUNT-1:0] read_bank1;
  input read_clkEn1;
  output reg read_hit1;
  output reg [1:0] read_hitCl1;
  input read_odd1;
  input read_split1;
  output [127+8:0] read_dataA1;
  output [127+8:0] read_dataX1;
  output [1:0] read_pbit1;
  input [4:0] read_beginA1;
  input [1:0] read_low1;
  input [4:0] read_sz1;

  
  input [ADDR_WIDTH-2:0] read_addrE2;
  input [ADDR_WIDTH-2:0] read_addrO2;
  input [BANK_COUNT-1:0] read_bank2;
  input read_clkEn2;
  output reg read_hit2;
  output reg [1:0] read_hitCl2;
  input read_odd2;
  input read_split2;
  output [127+8:0] read_dataA2;
  output [127+8:0] read_dataX2;
  output [1:0] read_pbit2;
  input [4:0] read_beginA2;
  input [1:0] read_low2;
  input [4:0] read_sz2;


  input [ADDR_WIDTH-2:0] read_addrE3;
  input [ADDR_WIDTH-2:0] read_addrO3;
  input [BANK_COUNT-1:0] read_bank3;
  input read_clkEn3;
  output reg read_hit3;
  output reg [1:0] read_hitCl3;
  input read_odd3;
  input read_split3;
  output [127+8:0] read_dataX3;
  output [127+8:0] read_dataX3;
  output [1:0] read_pbit3;
  input [4:0] read_beginA3;
  input [1:0] read_low3;
  input [4:0] read_sz3;

  
  input [BANK_COUNT-1:0] read_bankNoRead;//bits are 1 if other bank reads are 0
  
  input read_invalidate; 

  input [ADDR_WIDTH-2:0] write_addrE0;
  input [ADDR_WIDTH-2:0] write_addrO0;
  input [BANK_COUNT-1:0] write_bank0;
  input write_clkEn0;
  output reg write_hit0;
  output reg [1:0] write_hitCl0;
  output reg [1:0] write_dupl0;
  input write_split0;
  input write_odd0;
  input [4:0] write_begin0;
  input [4:0] write_end0;
  input [3:0] write_bgnBen0;
  input [3:0] write_endBen0;
  input [5*32-1:0] write_data0;
  input [5*32-1:0] write_dataM0;
  input [1:0] write_pbit0;
  input write_d128_0;
  input [ADDR_WIDTH-2:0] write_addrE1;
  input [ADDR_WIDTH-2:0] write_addrO1;
  input [BANK_COUNT-1:0] write_bank1;
  input write_clkEn1;
  output reg write_hit1;
  output reg [1:0] write_hitCl1;
  output reg [1:0] write_dupl1;
  input write_split1;
  input write_odd1;
  input [4:0] write_begin1;
  input [4:0] write_end1;
  input [3:0] write_bgnBen1;
  input [3:0] write_endBen1;
  input [5*32-1:0] write_data1;
  input [5*32-1:0] write_dataM1;
  input [1:0] write_pbit1;
  input write_d128_1;
  input write_clear;
  
  input insert_en;    
  input insert_from_ram;
  input insert_exclusive;
  input insert_dirty;
//  output reg wb_en;
//  output [LINE_WIDTH/4-1:0] busWb_data;
  input [511:0] busIns_data;
  input [7:0] busIns_dataPTR;
  input insbus_A,insbus_B;
  output [ADDR_WIDTH-1:0] expun_addr;
  output expun_en;
  
  wire [1023:0] write_data;
  wire [1023:0] write_dataM;
//  wire [LINE_WIDTH-1:0] read_data;
  
  wire [LINE_WIDTH-1:0] read_dataP[8:0];
  wire [LINE_WIDTH-1:0] read_dataPN[8:0];
  reg [LINE_WIDTH-1:0] read_dataP_reg;
  reg [LINE_WIDTH-1:0] read_dataP_reg2;
  wire [BANK_COUNT*32-1:0] read_data_strip;
  wire [1:0] read_pbit0P[8:0];
  wire [1:0] read_pbit1P[8:0];
  wire [1:0] read_pbit2P[8:0];
  wire [1:0] read_pbit3P[8:0];
  
  reg [1:0] read_pbit0P_reg;
  reg [1:0] read_pbit0P_reg2;
  reg [1:0] read_pbit1P_reg;
  reg [1:0] read_pbit1P_reg2;
  reg [1:0] read_pbit2P_reg;
  reg [1:0] read_pbit2P_reg2;
  reg [1:0] read_pbit3P_reg;
  reg [1:0] read_pbit3P_reg2;

  wire [5:0] err_tag[7:0];
  
  wire recent_in;
  wire [7:0] recent_out;

  wire [5:0] insert_rand;
  
  wire [BANK_COUNT-1:0] read_bankHit_way[7:0];
  wire [BANK_COUNT-1:0] bank_hit;

  wire [7:0] insert_hit_way;
  
  wire [1:0] read_hit0_way[7:0];
  wire [1:0] read_hit1_way[7:0];
  wire [1:0] read_hit2_way[7:0];
  wire [1:0] read_hit3_way[7:0];
  
  wire [1:0] read_hitCl0Q;
  wire [1:0] read_hitCl1Q;
  wire [1:0] read_hitCl2Q;
  wire [1:0] read_hitCl3Q;

  wire [1:0] read_hitCl0P;
  wire [1:0] read_hitCl1P;
  wire [1:0] read_hitCl2P;
  wire [1:0] read_hitCl3P;

  reg [1:0] read_hitCl0P_reg;
  reg [1:0] read_hitCl1P_reg;
  reg [1:0] read_hitCl2P_reg;
  reg [1:0] read_hitCl3P_reg;

  wire read_hit0P;
  wire read_hit1P;
  wire read_hit2P;
  wire read_hit3P;

  reg read_hit0P_reg;
  reg read_hit1P_reg;
  reg read_hit2P_reg;
  reg read_hit3P_reg;

  wire [1:0] write_hit0_way[7:0];
  wire [1:0] write_hit1_way[7:0];

  wire write_hit0P;
  wire write_hit1P;

  reg write_hit0P_reg;
  reg write_hit1P_reg;

  wire [1:0] write_hitCl0P;
  wire [1:0] write_hitCl1P;

  reg [1:0] write_hitCl0P_reg;
  reg [1:0] write_hitCl1P_reg;
  
  wire [1:0] write_dupl0_way[7:0];
  wire [1:0] write_dupl1_way[7:0];

  wire [1:0] write_dupl0P;
  wire [1:0] write_dupl1P;
  reg [1:0] write_dupl0P_reg;
  reg [1:0] write_dupl1P_reg;
  
  reg rdreqE0,rdreqO0;
  reg rdreqE1,rdreqO1;
  reg rdreqE2,rdreqO2;
  reg rdreqE3,rdreqO3;

  reg wrreqE0,wrreqO0;
  reg wrreqE1,wrreqO1;

  reg [ADDR_WIDTH-2:0] read_addrE0_reg;
  reg [ADDR_WIDTH-2:0] read_addrO0_reg;
  reg [BANK_COUNT-1:0] read_bank0_reg;
  reg read_clkEn0_reg;
  reg read_odd0_reg;
  reg read_split0_reg;

  reg [ADDR_WIDTH-2:0] read_addrE1_reg;
  reg [ADDR_WIDTH-2:0] read_addrO1_reg;
  reg [BANK_COUNT-1:0] read_bank1_reg;
  reg read_clkEn1_reg;
  reg read_odd1_reg;
  reg read_split1_reg;
  
  reg [ADDR_WIDTH-2:0] read_addrE2_reg;
  reg [ADDR_WIDTH-2:0] read_addrO2_reg;
  reg [BANK_COUNT-1:0] read_bank2_reg;
  reg [3:0][BANK_COUNT-1:0] read_bank;
  reg read_clkEn2_reg;
  reg read_odd2_reg;
  reg read_split2_reg;

  reg [ADDR_WIDTH-2:0] read_addrE3_reg;
  reg [ADDR_WIDTH-2:0] read_addrO3_reg;
  reg [BANK_COUNT-1:0] read_bank3_reg;
  reg read_clkEn3_reg;
  reg read_odd3_reg;
  reg read_split3_reg;
  
  reg [BANK_COUNT-1:0] read_bankNoRead_reg;//bits are 1 if other bank reads are 0
  
  reg read_invalidate_reg; 
  reg read_invalidate_reg2;
  
  reg [ADDR_WIDTH-2:0] write_addrE0_reg;
  reg [ADDR_WIDTH-2:0] write_addrO0_reg;
  reg [BANK_COUNT-1:0] write_bank0_reg;
  reg [4:0] write_begin0_reg;
  reg [4:0] write_end0_reg;
  reg [3:0] write_bgnBen0_reg;
  reg [3:0] write_endBen0_reg;
  reg write_clkEn0_reg;
  reg write_split0_reg;
  reg [1:0] write_pbit0_reg;
  reg write_d128_0_reg;
  reg write_odd0_reg;
  reg [ADDR_WIDTH-2:0] write_addrE1_reg;
  reg [ADDR_WIDTH-2:0] write_addrO1_reg;
  reg [BANK_COUNT-1:0] write_bank1_reg;
  reg write_clkEn1_reg;
  reg write_split1_reg;
  reg [1:0] write_pbit1_reg;
  reg write_d128_1_reg;
  reg write_odd1_reg;
  reg [4:0] write_begin1_reg;
  reg [4:0] write_end1_reg;
  reg [3:0] write_bgnBen1_reg;
  reg [3:0] write_endBen1_reg;
  
  reg insert_en_reg;    
  reg insert_exclusive_reg;
  reg insert_dirty_reg;
  reg [1023:0] write_data_reg;
  reg [1023:0] write_dataM_reg;
  reg insert_exclusive_reg2;
  reg insert_dirty_reg2;
  reg [1023:0] write_data_reg2;
  reg [1023:0] write_dataM_reg2;
  wire [LINE_WIDTH-1:0] write_data_ecc;
  wire [LINE_WIDTH-1:0] write_dataM0_ecc;
  wire [LINE_WIDTH-1:0] write_dataM_ecc;
  reg [15:0] write_dataPTR_reg;
  reg [15:0] write_dataPTR_reg2;
  reg [BANK_COUNT-1:0] write_bank0_reg2;
  reg [BANK_COUNT-1:0] write_bank1_reg2;
  
  reg insert_en_reg2;

  wire [255:0] rxdata0[3:0];
  wire [255:0] rxdata1[3:0];
  wire [255:0] rxdata2[3:0];
  wire [255:0] rxdata3[3:0];
  wire [255:0] rxdata4[3:0];
  wire [255:0] rxdata5[3:0];
  wire [255:0] rxdata6[3:0];
  wire [255:0] rxdata7[3:0];
  wire [255:0] rxdata[3:0];
  wire [3:0][127+8:0] rddata1;
  wire [3:0][127:0] rddata2;
//  wire [4:0] rdcan[3:0];
  wire [3:0][127+8:0] read_dataA;
  reg [5:0] mskdata1[3:0];
  reg [4:0] read_sz[3:0];
  reg [4:0] read_sz_reg[3:0];

  wire [7:0] write_back_way;
  wire [7:0] write_back2_way;
  
  wire write_back;
  wire write_back2;

  reg write_back_P;
  reg write_back2_P;

  reg [4:0] read_beginA[3:0];
  reg [4:0] read_beginA_reg[3:0];
  reg [4:0] read_beginA_reg2[3:0];
  
  reg [7:0] read_low;
  reg [7:0] read_low_reg;
  reg [7:0] read_low_reg2;
  
//  reg [LINE_WIDTH-1:0] wb_data;
 
  integer v;


  reg sticky_wen;
  reg write_clear_reg;
  reg write_clear_reg2;
  reg write_clkEn0_reg2;
  reg write_clkEn1_reg2;
  
  reg read_clkEnAny;
//  reg wb_en_reg,wb_en_reg2,wb_en_reg3;
  wire [ADDR_WIDTH-1:0] wb_addr;
  reg [ADDR_WIDTH-1:0] wb_addr_reg;
  reg [ADDR_WIDTH-1:0] wb_addr_reg2;
  wire wb_enOut;
  reg wb_enOut_reg;
  reg wb_enOut_reg2;
  generate
      genvar w,b,p,q;
      for (w=0;w<8;w=w+1) begin : ways_gen
          dcache1_way #(w) way_mod(
          clk,
          rst,
          read_addrE0, read_addrO0, read_bank0, read_clkEn0, read_hit0_way[w], 
            read_odd0, read_split0, read_pbit0P[w+1], read_pbit0P[w], read_errT0[w],
          read_addrE1, read_addrO1, read_bank1, read_clkEn1, read_hit1_way[w],   
            read_odd1, read_split1, read_pbit1P[w+1], read_pbit1P[w], read_errT1[w],
          read_addrE2, read_addrO2, read_bank2, read_clkEn2, read_hit2_way[w],   
            read_odd2, read_split2, read_pbit2P[w+1], read_pbit2P[w], read_errT2[w],
          read_addrE3, read_addrO3, read_bank3, read_clkEn3, read_hit3_way[w],   
            read_odd3, read_split3, read_pbit3P[w+1], read_pbit3P[w], read_errT3[w],
          read_bankNoRead,
          read_invalidate_reg,
          read_bankHit_way[w],
          read_dataP[w+1],
	  read_dataP[w],
          read_errP[w+1],
	  read_errP[w],
	  read_beginA0,
	  read_beginA1,
	  read_beginA2,
	  read_beginA3,
          write_addrE0_reg,
          write_addrO0_reg,
          write_bank0_reg2,
          write_begin0_reg,write_end0_reg,
          write_bgnBen0_reg,write_endBen0_reg,
          write_clkEn0_reg,
          write_hit0P&sticky_wen,
          write_hit0_way[w],
          write_dupl0_way[w],
          write_split0_reg,
          write_pbit0_reg,
          write_d128_0_reg,
          write_odd0_reg,
          write_errS0,
          write_addrE1_reg,
          write_addrO1_reg,
          write_bank1_reg2,
          write_begin1_reg,write_end1_reg,
          write_bgnBen1_reg,write_endBen1_reg,
          write_clkEn1_reg,
          write_hit1P&sticky_wen,
          write_hit1_way[w],
          write_dupl1_way[w],
          write_split1_reg,
          write_pbit1_reg,
          write_d128_1_reg,
          write_odd1_reg,
          write_errS1,
          insert_en_reg,
          insert_exclusive_reg2,
          insert_dirty_reg2,
          write_data_ecc,
          write_dataM_ecc,
          write_dataPTR_reg2,
          err_tag[w],
          recent_in,
          recent_out[w],
          insert_rand,
          insert_hit_way[w],
          wb_addr,wb_enOut,
          puke_addr,puke_en
          );
      end
      for (b=0;b<BANK_COUNT;b=b+1) begin
          dc1_strip_par strip_mod(read_dataP_reg2[b*DATA_WIDTH+:DATA_WIDTH],read_data_strip[b*32+:32]);
          dc1_get_par wrEcc_mod(write_data_reg2[b*32+:32],write_data_ecc[b*DATA_WIDTH+:DATA_WIDTH]); 
          dc1_get_par wrEcc2_mod(~write_dataM_reg2[b*32+:32],write_dataM0_ecc[b*DATA_WIDTH+:DATA_WIDTH]); 

	  assign write_dataM_ecc[b*DATA_WIDTH+:DATA_WIDTH]=~write_dataM0_ecc[b*DATA_WIDTH+:DATA_WIDTH];
          
          wire [4:0] wr0;
          wire [4:0] wr1;
          for(q=0;q<5;q=q+1) begin
              assign wr0[q]=((b-q)&5'h1f)==write_begin0 && write_clkEn0 && write_bank0[b];
              assign wr1[q]=((b-q)&5'h1f)==write_begin1 && write_clkEn1 && write_bank1[b];
              assign write_data[b*32+:32]=wr0[q] ? write_data0[q*32+:32] : 32'BZ;
              assign write_data[b*32+:32]=wr1[q] ? write_data1[q*32+:32] : 32'BZ;
              assign write_dataM[b*32+:32]=wr0[q] ? write_dataM0[q*32+:32] : 32'BZ;
              assign write_dataM[b*32+:32]=wr1[q] ? write_dataM1[q*32+:32] : 32'BZ;
          end
          assign  write_data[b*32+:32]=(|{wr0,wr1}) ? 32'BZ : 
            busIns_data[(b%16)*32+:32];
          assign  write_dataM[b*32+:32]=(|{wr0,wr1}) ? 32'BZ : 
            ~busIns_data[(b%16)*32+:32];
  /*        assign bank_hit[b]=read_bankHit_way[0][b] | read_bankHit_way[1][b] | read_bankHit_way[2][b] | 
            read_bankHit_way[3][b] | read_bankHit_way[4][b] | read_bankHit_way[5][b] |  
            read_bankHit_way[6][b] | read_bankHit_way[7][b]; */
          if (b<16) begin
              assign rddata1[0]=({read_beginA_reg[0][1:0],read_low_reg[1:0]}==b) ? rxdata[0][b*8+:136] : 136'BZ;
              assign rddata1[1]=({read_beginA_reg[1][1:0],read_low_reg[3:2]}==b) ? rxdata[1][b*8+:136] : 136'BZ;
              assign rddata1[2]=({read_beginA_reg[2][1:0],read_low_reg[5:4]}==b) ? rxdata[2][b*8+:136] : 136'BZ;
              assign rddata1[3]=({read_beginA_reg[3][1:0],read_low_reg[7:6]}==b) ? rxdata[3][b*8+:136] : 136'BZ;
              assign rderr1[0]=({read_beginA_reg[0][1:0],2'b0}==b) ? |rxerr[0][b+:4] : 136'BZ;
              assign rderr1[1]=({read_beginA_reg[1][1:0],2'b0}==b) ? |rxerr[1][b+:4] : 136'BZ;
              assign rderr1[2]=({read_beginA_reg[2][1:0],2'b0)==b) ? |rxerr[2][b+:4] : 136'BZ;
              assign rderr1[3]=({read_beginA_reg[3][1:0],2'b0}==b) ? |rxerr[3][b+:4] : 136'BZ;
              assign rderr2[0]=({read_beginA_reg[0][1:0],2'b0}==b) ? |rxerr7B[0][b+:4] : 136'BZ;
              assign rderr2[1]=({read_beginA_reg[1][1:0],2'b0}==b) ? |rxerr7B[1][b+:4] : 136'BZ;
              assign rderr2[2]=({read_beginA_reg[2][1:0],2'b0)==b) ? |rxerr7B[2][b+:4] : 136'BZ;
              assign rderr2[3]=({read_beginA_reg[3][1:0],2'b0}==b) ? |rxerr7B[3][b+:4] : 136'BZ;
          end
      end
      for (p=0;p<4;p=p+1) begin
              assign rddata2[p]=rxdata[p][255:128];
	      assign rxdata0[p]=read_data_strip[255:0]&{256{read_beginA_reg[p][4:2]==3'd0}};
              assign rxerr0[p]=read_errP_reg2[7:0]&read_banks[p][7:0]&{8{read_beginA_reg[p][4:2]==3'd0}};
	      assign rxdata1[p]=read_data_strip[128+255:128]&{256{read_beginA_reg[p][4:2]==3'd1}};
              assign rxerr1[p]=read_errP_reg2[11:4]&read_banks[p][11:4]&{8{read_beginA_reg[p][4:2]==3'd1}};
	      assign rxdata2[p]=read_data_strip[511:256]&{256{read_beginA_reg[p][4:2]==3'd2}};
              assign rxerr2[p]=read_errP_reg2[15:8]&read_banks[p][15:8]&{8{read_beginA_reg[p][4:2]==3'd2}};
	      assign rxdata3[p]=read_data_strip[128+511:128+256]&{256{read_beginA_reg[p][4:2]==3'd3}};
              assign rxerr3[p]=read_errP_reg2[19:12]&read_banks[p][19:12]&{8{read_beginA_reg[p][4:2]==3'd3}};
	      assign rxdata4[p]=read_data_strip[767:512]&{256{read_beginA_reg[p][4:2]==3'd4}};
              assign rxerr4[p]=read_errP_reg2[23:16]&read_banks[p][23:16]&{8{read_beginA_reg[p][4:2]==3'd4}};
	      assign rxdata5[p]=read_data_strip[767+128:128+512]&{256{read_beginA_reg[p][4:2]==3'd5}};
              assign rxerr5[p]=read_errP_reg2[27:20]&read_banks[p][27:20]&{8{read_beginA_reg[p][4:2]==3'd5}};
	      assign rxdata6[p]=read_data_strip[1023:768]&{256{read_beginA_reg[p][4:2]==3'd6}};
              assign rxerr6[p]=read_errP_reg2[31:24]&read_banks[p][31:24]&{8{read_beginA_reg[p][4:2]==3'd6}};
	      assign rxdata7[p]={read_data_strip[127:0],read_data_strip[1023:768+128]}&
		{256{read_beginA_reg[p][4:2]==3'd7}};
              assign rxerr7[p]={4'b0,read_errP_reg2[31:28]}&{read_banks[p][31:28]}&
                {8{read_beginA_reg[p][4:2]==3'd7}};
              assign rxerr7B[p]={read_errP_reg2[3:0],4'b0}&{read_banks[p][3:0],4'b0}&
                {8{read_beginA_reg[p][4:2]==3'd7}};
	      assign rxdata[p]=rxdata0[p]|rxdata1[p]|rxdata2[p]|rxdata3[p]|
		rxdata4[p]|rxdata5[p]|rxdata6[p]|rxdata7[p];
	      assign rxerr[p]=rxerr0[p]|rxerr1[p]|rxerr2[p]|rxerr3[p]|
		rxerr4[p]|rxerr5[p]|rxerr6[p]|rxerr7[p];
              assign read_dataA[p]=rddata1[p] & {{8{mskdata1[p][5]}},{48{mskdata1[p][4]}},{16{mskdata1[p][3]}},{32{mskdata1[p][2]}},
                    {16{mskdata1[p][1]}},{8{mskdata1[p][0]}},8'hff};
              assign puke_addr[p]=read_odd[p] & rderr1[p] || read_errH_reg2[p] ? read_addrO[p][6:0] : read_addrE[p][6:0];
              assign puke_en[p]=rderr1[p] | rderr2[p] | read_errL_reg2[p] | read_errH_reg2[p];
    end
  endgenerate
  assign puke_addr[4]=write_odd[4] && write_errL_reg2[4] ? write_addrO[4][6:0] : read_addrE[4][6:0];
  assign puke_en[4]=write_errL_reg2[4] | write_errH_reg2[4];
  assign puke_addr[5]=write_odd[5] && write_errL_reg2[5] ? write_addrO[5][6:0] : read_addrE[5][6:0];
  assign puke_en[5]=write_errL_reg2[5] | write_errH_reg2[5];

  LFSR16_6 rnd_mod(clk,rst,insert_rand);
  
  assign read_pbit0=read_pbit0P_reg2;
  assign read_pbit1=read_pbit1P_reg2;
  assign read_pbit2=read_pbit2P_reg2;
  assign read_pbit3=read_pbit3P_reg2;
  
  assign read_hitCl0Q=read_hit0_way[0] | read_hit0_way[1] | read_hit0_way[2] | 
    read_hit0_way[3] | read_hit0_way[4] | read_hit0_way[5] |  
    read_hit0_way[6] | read_hit0_way[7]; 
  assign read_hitCl1Q=read_hit1_way[0] | read_hit1_way[1] | read_hit1_way[2] | 
    read_hit1_way[3] | read_hit1_way[4] | read_hit1_way[5] |  
    read_hit1_way[6] | read_hit1_way[7]; 
  assign read_hitCl2Q=read_hit2_way[0] | read_hit2_way[1] | read_hit2_way[2] | 
    read_hit2_way[3] | read_hit2_way[4] | read_hit2_way[5] |  
    read_hit2_way[6] | read_hit2_way[7]; 
  assign read_hitCl3Q=read_hit3_way[0] | read_hit3_way[1] | read_hit3_way[2] | 
    read_hit3_way[3] | read_hit3_way[4] | read_hit3_way[5] |  
    read_hit3_way[6] | read_hit3_way[7];
    
  assign read_hitCl0P=read_hitCl0Q & {rdreqO0,rdreqE0};
  assign read_hitCl1P=read_hitCl1Q & {rdreqO1,rdreqE1};
  assign read_hitCl2P=read_hitCl2Q & {rdreqO2,rdreqE2};
  assign read_hitCl3P=read_hitCl3Q & {rdreqO3,rdreqE3};

  assign read_NdataA0=~read_dataA0;
  assign read_NdataA1=~read_dataA1;
  assign read_NdataA2=~read_dataA2;
  assign read_NdataA3=~read_dataA3;

  assign write_dupl0P=write_dupl0_way[0]|write_dupl0_way[1]|write_dupl0_way[2]|write_dupl0_way[3]|write_dupl0_way[4]|
    write_dupl0_way[5]|write_dupl0_way[6]|write_dupl0_way[7];
  assign write_dupl1P=write_dupl1_way[0]|write_dupl1_way[1]|write_dupl1_way[2]|write_dupl1_way[3]|write_dupl1_way[4]|
        write_dupl1_way[5]|write_dupl1_way[6]|write_dupl1_way[7];

  assign expun_addr=wb_addr_reg2;
  assign expun_en=wb_enOut_reg2;
  assign wb_addr=insert_hit_way!=0 ? 37'bz : 37'b0;
  assign wb_enOut=insert_hit_way!=0 ? 1'bz : 1'b0;
  
  assign write_hitCl0P=write_hit0_way[0] | write_hit0_way[1] | write_hit0_way[2] | 
    write_hit0_way[3] | write_hit0_way[4] | write_hit0_way[5] |  
    write_hit0_way[6] | write_hit0_way[7];
  assign write_hitCl1P=write_hit1_way[0] | write_hit1_way[1] | write_hit1_way[2] | 
    write_hit1_way[3] | write_hit1_way[4] | write_hit1_way[5] |  
    write_hit1_way[6] | write_hit1_way[7]; 
    
 assign write_hit0P=(write_hitCl0P[0] | ~wrreqE0 && write_hitCl0P[1] | ~wrreqO0 ) &&
   (wrreqE0|wrreqO0);
 assign write_hit1P=(write_hitCl1P[0] | ~wrreqE1 && write_hitCl1P[1] | ~wrreqO1 ) &&
   (wrreqE1|wrreqO1);
   
 assign write_back=|write_back_way;
 assign write_back2=|write_back2_way;
   
    
  assign recent_in=|recent_out;

  assign read_dataA0=read_dataA[0];
  assign read_dataA1=read_dataA[1];
  assign read_dataA2=read_dataA[2];
  assign read_dataA3=read_dataA[3];

  assign read_dataX0={128{read_sz_reg[0][4:1]==4'd6 || read_sz_reg[0]==5'd14}}&rddata2[0];
  assign read_dataX1={128{read_sz_reg[1][4:1]==4'd6 || read_sz_reg[1]==5'd14}}&rddata2[0];
  assign read_dataX2={128{read_sz_reg[2][4:1]==4'd6 || read_sz_reg[2]==5'd14}}&rddata2[0];
  assign read_dataX3={128{read_sz_reg[3][4:1]==4'd6 || read_sz_reg[3]==5'd14}}&rddata2[0];
 
  assign read_dataP[0]={LINE_WIDTH{1'B0}}; 
  assign read_dataPN[0]={LINE_WIDTH{1'B1}}; 
  assign read_pbit0P[0]=2'b0;
  assign read_pbit1P[0]=2'b0;
  assign read_pbit2P[0]=2'b0;
  assign read_pbit3P[0]=2'b0;

  assign read_hit0P=(|read_hitCl0Q[0] | ~rdreqE0) && (read_hitCl0Q[1] | ~rdreqO0) &&
    (rdreqE0 | rdreqO0) && ~insert_en_reg2 & ~rderr1[0] & ~rderr2[0];
  assign read_hit1P=(read_hitCl1Q[0] | ~rdreqE1) && (read_hitCl1Q[1] | ~rdreqO1) &&
    (rdreqE1 | rdreqO1) && ~insert_en_reg2 & ~rderr1[1] & ~rderr2[1];
  assign read_hit2P=(read_hitCl2Q[0] | ~rdreqE2) && (read_hitCl2Q[1] | ~rdreqO2) &&
    (rdreqE2 | rdreqO2) && ~insert_en_reg2 & ~rderr1[2] & ~rderr2[2];
  assign read_hit3P=(read_hitCl3Q[0] | ~rdreqE3) && (read_hitCl3Q[1] | ~rdreqO3) &&
    (rdreqE3 | rdreqO3) && ~insert_en_reg2 & ~rderr1[3] & ~rderr2[3];
    
  always @(posedge clk) begin
      if (rst)  begin
          read_invalidate_reg<=1'B0; 

          write_addrE0_reg<={ADDR_WIDTH-1{1'B0}};
          write_addrO0_reg<={ADDR_WIDTH-1{1'B0}};
          write_bank0_reg<={BANK_COUNT{1'B0}};
          write_clkEn0_reg<=1'B0;
          write_split0_reg<=1'B0;
          write_odd0_reg<=1'B0;
          write_begin0_reg<=5'b0;
          write_end0_reg<=5'b0;
          write_bgnBen0_reg<=4'b0;
          write_endBen0_reg<=4'b0; 
          write_pbit0_reg<=2'b0;
          write_d128_0_reg<=1'b0;

          write_addrE1_reg<={ADDR_WIDTH-1{1'B0}};
          write_addrO1_reg<={ADDR_WIDTH-1{1'B0}};
          write_bank1_reg<={BANK_COUNT{1'B0}};
          write_begin1_reg<=5'b0;
          write_end1_reg<=5'b0;
          write_bgnBen1_reg<=4'b0;
          write_endBen1_reg<=4'b0; 
          write_clkEn1_reg<=1'B0;
          write_split1_reg<=1'B0;
          write_odd1_reg<=1'B0;
          write_pbit1_reg<=2'b0;
          write_d128_1_reg<=1'b0;

          insert_en_reg<=1'b0;
          insert_exclusive_reg<=1'b0;
          insert_dirty_reg<=1'b0;

          read_hitCl0<=2'b0;
          read_hitCl1<=2'b0;
          read_hitCl2<=2'b0;
          read_hitCl3<=2'b0;
          read_hit0<=1'b0;
          read_hit1<=1'b0;
          read_hit2<=1'b0;
          read_hit3<=1'b0;

          write_hit0<=1'b0;
          write_hit1<=1'b0;
          write_hitCl0<=2'b0;
          write_hitCl1<=2'b0;
          write_dupl0<=2'b0;
          write_dupl1<=2'b0;

          read_clkEnAny<=1'b0;
          
          write_clear_reg<=1'b0;
          
          wb_addr_reg2<={ADDR_WIDTH{1'B0}};
          wb_enOut_reg2<=1'b0;

          read_low<=8'b0;
          read_low_reg<=8'b0;
          
          
          write_data_reg<=1024'B0;
          write_dataM_reg<=1024'B0;
          write_dataPTR_reg<=16'b0;
          read_dataP_reg2<={LINE_WIDTH{1'B0}};
          read_pbit0P_reg2<=2'b0;
          read_pbit1P_reg2<=2'b0;
          read_pbit2P_reg2<=2'b0;
          read_pbit3P_reg2<=2'b0;

          read_bank0_reg<=32'b0;
          read_bank1_reg<=32'b0;
          read_bank2_reg<=32'b0;
          read_bank3_reg<=32'b0;
          
          for(v=0;v<4;v=v+1) begin
              mskdata1[v]<=6'b0;
              read_sz[v]<=5'b0;
              read_sz_reg[v]<=5'b0;
              read_beginA[v]<=5'b0;
              read_beginA_reg[v]<=5'b0;
              read_bank[v]<=32'b0;
          end
          
      end else begin
          read_invalidate_reg<=read_invalidate; 

          write_addrE0_reg<=write_addrE0;
          write_addrO0_reg<=write_addrO0;
          write_bank0_reg<=write_bank0;
          write_clkEn0_reg<=write_clkEn0;
          write_split0_reg<=write_split0;
          write_odd0_reg<=write_odd0;
          write_begin0_reg<=write_begin0;
          write_end0_reg<=write_end0;
          write_bgnBen0_reg<=write_bgnBen0;
          write_endBen0_reg<=write_endBen0;
          write_pbit0_reg<=write_pbit0;
          write_d128_0_reg<=write_d128_0;

          write_addrE1_reg<=write_addrE1;
          write_addrO1_reg<=write_addrO1;
          write_bank1_reg<=write_bank1;
          write_begin1_reg<=write_begin1;
          write_end1_reg<=write_end1;
          write_bgnBen1_reg<=write_bgnBen1;
          write_endBen1_reg<=write_endBen1;
          write_clkEn1_reg<=write_clkEn1;
          write_split1_reg<=write_split1;
          write_odd1_reg<=write_odd1;
          write_pbit1_reg<=write_pbit1;
          write_d128_1_reg<=write_d128_1;

          insert_en_reg<=insert_en;    
          insert_exclusive_reg<=insert_exclusive;
          insert_dirty_reg<=insert_dirty;

          read_hitCl0<=read_hitCl0P_reg;
          read_hitCl1<=read_hitCl1P_reg;
          read_hitCl2<=read_hitCl2P_reg;
          read_hitCl3<=read_hitCl3P_reg;
          read_hit0<=read_hit0P_reg;
          read_hit1<=read_hit1P_reg;
          read_hit2<=read_hit2P_reg;
          read_hit3<=read_hit3P_reg;

          write_hit0<=write_hit0P_reg | &write_hitCl0P_reg;//bypass write cache miss if full miss occurs
          write_hit1<=write_hit1P_reg | &write_hitCl1P_reg;//bypass write cache miss if full miss occurs 
          write_hitCl0<=write_hitCl0P_reg;
          write_hitCl1<=write_hitCl1P_reg;
          write_dupl0<=write_dupl0P_reg;
          write_dupl1<=write_dupl1P_reg;

          read_clkEnAny<=|{read_clkEn0,read_clkEn1,read_clkEn2,read_clkEn3};
          
          write_clear_reg<=write_clear;
          
          wb_addr_reg2<=wb_addr_reg;
          wb_enOut_reg2<=wb_enOut_reg;
          
          read_low<={read_low3,read_low2,read_low1,read_low0};
          read_low_reg<=read_low;
          
          
          if (~insbus_B) write_data_reg[WLINE_WIDTH/2-1:0]<=write_data[WLINE_WIDTH/2-1:0];
          if (~insbus_A) write_data_reg[WLINE_WIDTH-1:WLINE_WIDTH/2]<=write_data[WLINE_WIDTH-1:WLINE_WIDTH/2];
          
          if (~insbus_B) write_dataPTR_reg[7:0]<=busIns_dataPTR;
          if (~insbus_A) write_dataPTR_reg[15:8]<=busIns_dataPTR;
          
          if (~insbus_B) write_dataM_reg[WLINE_WIDTH/2-1:0]<=write_dataM[WLINE_WIDTH/2-1:0];
          if (~insbus_A) write_dataM_reg[WLINE_WIDTH-1:WLINE_WIDTH/2]<=write_dataM[WLINE_WIDTH-1:WLINE_WIDTH/2];
          
          
	  if (read_clkEnAny) read_dataP_reg2<=read_dataP_reg;
          if (read_clkEnAny) read_pbit0P_reg2<=read_pbit0P_reg;
          if (read_clkEnAny) read_pbit1P_reg2<=read_pbit1P_reg;
          if (read_clkEnAny) read_pbit2P_reg2<=read_pbit2P_reg;
          if (read_clkEnAny) read_pbit3P_reg2<=read_pbit3P_reg;

          read_sz[0]<=read_sz0;
          read_sz[1]<=read_sz1;
          read_sz[2]<=read_sz2;
          read_sz[3]<=read_sz3;
          
          read_beginA[0]<=read_beginA0;
          read_beginA[1]<=read_beginA1;
          read_beginA[2]<=read_beginA2;
          read_beginA[3]<=read_beginA3;

          read_bank0_reg<=read_bank0;
          read_bank1_reg<=read_bank1;
          read_bank2_reg<=read_bank2;
          read_bank3_reg<=read_bank3;

          read_bank[0]<=read_bank0_reg;
          read_bank[1]<=read_bank1_reg;
          read_bank[2]<=read_bank2_reg;
          read_bank[3]<=read_bank3_reg;
          
          for(v=0;v<4;v=v+1) begin
              read_sz_reg[v]<=read_sz[v];
       //verilator lint_off CASEINCOMPLETE

              case(read_sz[v])
         5'd16: mskdata1[v]<=6'b00000;
         5'd17: mskdata1[v]<=6'b00001;
         5'd18: mskdata1[v]<=6'b00011;
         5'd19: mskdata1[v]<=6'b00111;
         5'h3:  mskdata1[v]<=6'b01111; //long double
         5'h0,5'h1,5'h2:  mskdata1[v]<=6'b11111; //int, double, single 128 bit (u)
         5'hc,5'hd,5'he:  mskdata1[v]<=6'b11111; //int, double, single 128 bit (a)
         5'h4,5'h5,5'h6:  mskdata1[v]<=6'b00011; //singleE,single,singleD
         5'h8,5'h9,5'ha:  mskdata1[v]<=6'b00111; //doubleE, double, singlePairD
         5'hb,5'h7:  mskdata1[v]<=6'b00111; //singlePair,64 int(u), 64 int(a)
	 5'hf: mskdata1[v]<=6'b111111;
              endcase
       //verilator lint_on CASEINCOMPLETE
              read_beginA_reg[v]<=read_beginA[v];
           end

      end
  end
  
  always @(negedge clk) begin
      if (rst) begin
          write_bank0_reg2<=32'b0;
          write_bank1_reg2<=32'b0;
          write_data_reg2<={WLINE_WIDTH{1'B0}};
          write_dataM_reg2<={WLINE_WIDTH{1'B0}};
          write_dataPTR_reg2<=16'b0;
          insert_exclusive_reg2<=1'b0;
          insert_dirty_reg2<=1'b0;
          
          read_hitCl0P_reg<=2'b0;
          read_hitCl1P_reg<=2'b0;
          read_hitCl2P_reg<=2'b0;
          read_hitCl3P_reg<=2'b0;
          read_hit0P_reg<=1'b0;
          read_hit1P_reg<=1'b0;
          read_hit2P_reg<=1'b0;
          read_hit3P_reg<=1'b0;

          write_hit0P_reg<=1'b0;
          write_hit1P_reg<=1'b0;
          write_hitCl0P_reg<=2'b0;
          write_hitCl1P_reg<=2'b0;
          write_dupl0P_reg<=2'b0;
          write_dupl1P_reg<=2'b0;
          
          write_bank0_reg2<={BANK_COUNT{1'b0}};
          write_bank1_reg2<={BANK_COUNT{1'b0}};

          rdreqE0<=1'b0;
          rdreqO0<=1'b0;
          rdreqE1<=1'b0;
          rdreqO1<=1'b0;
          rdreqE2<=1'b0;
          rdreqO2<=1'b0;
          rdreqE3<=1'b0;
          rdreqO3<=1'b0;

          wrreqE0<=1'b0;
          wrreqO0<=1'b0;
          wrreqE1<=1'b0;
          wrreqO1<=1'b0;

          insert_exclusive_reg2<=1'b0;
          insert_dirty_reg2<=1'b0;
          
          read_invalidate_reg2<=1'b0;
          
          wb_addr_reg<={ADDR_WIDTH{1'B0}};
          wb_enOut_reg<=1'b0;

          sticky_wen<=1'b1;
          write_clear_reg2<=1'b0;
          write_clkEn0_reg2<=1'b0;
          write_clkEn1_reg2<=1'b0;
          
          insert_en_reg2<=1'b0;
          read_pbit0P_reg<=2'b0;
          read_pbit1P_reg<=2'b0;
          read_pbit2P_reg<=2'b0;
          read_pbit3P_reg<=2'b0;
          read_dataP_reg<={LINE_WIDTH{1'B0}};
          write_data_reg2<={WLINE_WIDTH{1'B0}};
          write_dataM_reg2<={WLINE_WIDTH{1'B0}};
      end else begin
          write_bank0_reg2<=write_bank0_reg;
          write_bank1_reg2<=write_bank1_reg;
          write_data_reg2<=write_data;
          write_dataPTR_reg2<=write_dataPTR_reg;
          insert_exclusive_reg2<=insert_exclusive_reg;
          insert_dirty_reg2<=insert_dirty;
          
          read_hitCl0P_reg<=read_hitCl0P;
          read_hitCl1P_reg<=read_hitCl1P;
          read_hitCl2P_reg<=read_hitCl2P;
          read_hitCl3P_reg<=read_hitCl3P;
          read_hit0P_reg<=read_hit0P;
          read_hit1P_reg<=read_hit1P;
          read_hit2P_reg<=read_hit2P;
          read_hit3P_reg<=read_hit3P;
          
          write_hit0P_reg<=write_hit0P & sticky_wen;
          write_hit1P_reg<=write_hit1P & sticky_wen & (write_hit0P|~write_clkEn0_reg2);
          write_hitCl0P_reg<=write_hitCl0P;
          write_hitCl1P_reg<=write_hitCl1P;
          write_dupl0P_reg<=write_dupl0P;
          write_dupl1P_reg<=write_dupl1P;

          write_bank0_reg2<=write_bank0_reg;
          write_bank1_reg2<=write_bank1_reg;
          
          insert_exclusive_reg2<=insert_exclusive_reg;
          insert_dirty_reg2<=insert_dirty_reg;
          
          read_invalidate_reg2<=read_invalidate_reg;//?? remove _reg 
          
          wb_addr_reg<=wb_addr;
          wb_enOut_reg<=wb_enOut;

          rdreqE0<=~read_odd0 | read_split0 && read_clkEn0;
          rdreqO0<=read_odd0 | read_split0 && read_clkEn0;
          rdreqE1<=~read_odd1 | read_split1 && read_clkEn1;
          rdreqO1<=read_odd1 | read_split1 && read_clkEn1;
          rdreqE2<=~read_odd2 | read_split2 && read_clkEn2;
          rdreqO2<=read_odd2 | read_split2 && read_clkEn2;
          rdreqE3<=~read_odd3 | read_split3 && read_clkEn3;
          rdreqO3<=read_odd3 | read_split3 && read_clkEn3;

          wrreqE0<=~write_odd0_reg | write_split0_reg && write_clkEn0_reg;
          wrreqO0<=write_odd0_reg | write_split0_reg && write_clkEn0_reg;
          wrreqE1<=~write_odd1_reg | write_split1_reg && write_clkEn1_reg;
          wrreqO1<=write_odd1_reg | write_split1_reg && write_clkEn1_reg;
          
          if (write_clear_reg2) sticky_wen<=1'b1;
          else if (write_clkEn0_reg2 & ~write_hit0P || write_clkEn1_reg2 & ~write_hit1P)
            sticky_wen<=1'b0;
          write_clear_reg2<=write_clear_reg;
          write_clkEn0_reg2<=write_clkEn0_reg;
          write_clkEn1_reg2<=write_clkEn1_reg;
          
          insert_en_reg2<=insert_en_reg;
          read_pbit0P_reg<=read_pbit0P[8];
          read_pbit1P_reg<=read_pbit1P[8];
          read_pbit2P_reg<=read_pbit2P[8];
          read_pbit3P_reg<=read_pbit3P[8];
          read_dataP_reg<=read_dataP[8];
          write_data_reg2<=write_data_reg;
          write_dataM_reg2<=write_dataM_reg;
      end
  end
endmodule


module dc1_strip_ECC(dataIn,dataOut);
  input [39:1] dataIn;
  output [31:0] dataOut;
  
  assign dataOut={dataIn[38:33],dataIn[31:17],dataIn[15:9],dataIn[7:5],dataIn[3]};
  
endmodule