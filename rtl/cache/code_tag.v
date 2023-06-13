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


module ccTag_ram(
  clk,
  rst,
  read_clkEn,
  read_addr,
  read_data,
  write_addr,
  write_data,
  write_wen
  );

  localparam DATA_WIDTH=`cc1Tag_width;
  `ifdef ICACHE_256K
  localparam ADDR_WIDTH=8;
  localparam ADDR_COUNT=256;
  `else
  localparam ADDR_WIDTH=7;
  localparam ADDR_COUNT=128;
  `endif

  input clk;
  input rst;
  input read_clkEn;
  input [ADDR_WIDTH-1:0] read_addr;
  output [DATA_WIDTH-1:0] read_data;
  input [ADDR_WIDTH-1:0] write_addr;
  input [DATA_WIDTH-1:0] write_data;
  input write_wen;

  reg [DATA_WIDTH-1:0] ram [ADDR_COUNT-1:0];
  reg [ADDR_WIDTH-1:0] read_addr_reg;
  
  assign read_data=ram[read_addr_reg];

  always @(negedge clk)
    begin
      if (rst) read_addr_reg<={ADDR_WIDTH{1'b0}};
      else if (read_clkEn) read_addr_reg<=read_addr;
      if (write_wen) ram[write_addr]<=write_data;
    end

endmodule

module ccTag_lram(
  clk,
  rst,
  read_clkEn,
  read_addr,
  read_data,
  write_addr,
  write_data,
  write_wen
  );

  localparam DATA_WIDTH=3;
  `ifdef ICACHE_256K
  localparam ADDR_WIDTH=8;
  localparam ADDR_COUNT=256;
  `else
  localparam ADDR_WIDTH=7;
  localparam ADDR_COUNT=128;
  `endif

  input clk;
  input rst;
  input read_clkEn;
  input [ADDR_WIDTH-1:0] read_addr;
  output [DATA_WIDTH-1:0] read_data;
  input [ADDR_WIDTH-1:0] write_addr;
  input [DATA_WIDTH-1:0] write_data;
  input write_wen;

  reg [DATA_WIDTH-1:0] ram [ADDR_COUNT-1:0];
  reg [ADDR_WIDTH-1:0] read_addr_reg;
  
  assign read_data=ram[read_addr_reg];

  always @(negedge clk)
    begin
      if (rst) read_addr_reg<={ADDR_WIDTH{1'b0}};
      else if (read_clkEn) read_addr_reg<=read_addr;
      if (write_wen) ram[write_addr]<=write_data;
    end

endmodule



module ccTag(
  clk,
  rst,
  read_clkEn,
  read_phys_addr,
  read_hit,
  read_err,
  write_phys_addr,
  write_wen,
  invalidate,
  hitNRU,hitNRU_in,
  hitNRU_reg,
  write_hit,
  write_expun_addr,
  write_exp_en,
  init
  );

  parameter [2:0] INDEX=0;
  parameter [0:0] EXT=1'b0;
  localparam DATA_WIDTH=`cc1Tag_width;
  `ifdef ICACHE_256K
  localparam ADDR_WIDTH=8;
  localparam ADDR_COUNT=256;
  `else
  localparam ADDR_WIDTH=7;
  localparam ADDR_COUNT=128;
  `endif
  localparam PHYS_BITS=44;
  localparam VIRT_BITS=64;

  input clk;
  input rst;
  input read_clkEn;
  input [PHYS_BITS-8:0] read_phys_addr;
  output read_hit;
  output read_err;
  
  input [PHYS_BITS-8:0] write_phys_addr;
  input write_wen;
  input invalidate;
  
  
  output [2:0] hitNRU;
  input [2:0] hitNRU_in;
  input [2:0] hitNRU_reg;
  output write_hit;
  output [36:0] write_expun_addr;
  output write_exp_en;
  input init;

  wire [PHYS_BITS-8:0] tag_paddr;
  wire tag_valid;


  wire [DATA_WIDTH-1:0] read_data;
  wire [DATA_WIDTH-1:0] readW_data;
  wire [DATA_WIDTH-1:0] read_dataW;

  wire [DATA_WIDTH-1:0] write_data_way;
  wire [DATA_WIDTH-1:0] write_data_new;
  
  reg read_clkEn_reg;
  reg read_clkEn_reg2;

  reg read_hit_reg;

  reg [PHYS_BITS-8:0] read_phys_addr_reg;
  reg [PHYS_BITS-8:0] write_phys_addr_reg;
  reg [PHYS_BITS-8:0] read_phys_addr_reg2;
 

  wire [2:0] read_NRUr;
  wire [2:0] read_NRUw;
  wire [2:0] write_NRU;
  
  reg write_wen_reg;

  reg [2:0] read_NRUr_reg;
  
  reg invalidate_reg;
  reg init_reg,init_reg2;
  
  assign tag_paddr=read_data[`cc1Tag_paddr];
  assign tag_valid=read_data[`cc1Tag_valid];

  assign read_err=^read_data;
  assign read_hit=tag_valid && tag_paddr==read_phys_addr_reg && ~init && read_clkEn_reg;
  
  assign write_data_way=(invalidate_reg | init_reg) ? {DATA_WIDTH{1'B0}} : write_data_new;
  
  assign write_data_new[`cc1Tag_valid]=1'b1;
  assign write_data_new[`cc1Tag_paddr]=write_phys_addr_reg;
  assign write_data_new[`cc1Tag_parity]=^write_data_new[DATA_WIDTH-2:0];

  assign write_expun_addr=read_dataW[`cc1Tag_paddr] & {37{write_hit}};
  assign write_exp_en=write_hit && read_dataW[`cc1Tag_valid ];

  generate
    if (INDEX[0]) begin
        assign hitNRU=~(~({3{read_hit_reg}} & read_NRUr_reg) & hitNRU_in); 
    end else begin
        assign hitNRU=~(({3{read_hit_reg}} & read_NRUr_reg) | hitNRU_in); 
    end
  endgenerate

  assign write_hit=(write_wen_reg && read_NRUw==3'd5) || (invalidate_reg && read_dataW[`cc1Tag_paddr]==write_phys_addr_reg && read_dataW[`cc1Tag_valid]);
  ccTag_ram ram_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(read_clkEn),
  .read_addr(read_phys_addr[7:0]),
  .read_data(read_data),
  .write_addr(write_phys_addr_reg[7:0]),
  .write_data(write_data_way),
  .write_wen(write_hit|init_reg)
  );

  ccTag_ram ramW_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(read_clkEn),
  .read_addr(write_phys_addr[7:0]),
  .read_data(read_dataW),
  .write_addr(write_phys_addr_reg[7:0]),
  .write_data(write_data_way),
  .write_wen(write_hit|init_reg)
  );

  ccTag_lram lram0_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(read_clkEn),
  .read_addr(read_phys_addr[7:0]),
  .read_data(read_NRUr),
  .write_addr(read_phys_addr_reg2[7:0]),
  .write_data(write_NRU),
  .write_wen(EXT ? init_reg2 : read_clkEn_reg2|init_reg2)
  );

  ccTag_lram lram1_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(write_wen),
  .read_addr(write_phys_addr[7:0]),
  .read_data(read_NRUw),
  .write_addr(read_phys_addr_reg2[7:0]),
  .write_data(write_NRU),
  .write_wen(EXT ? init_reg2 : read_clkEn_reg2|init_reg2)
  );

  lru_single #(3,INDEX) NRU_mod(
  .lru(read_NRUr_reg),
  .newLRU(write_NRU),
  .hitLRU(hitNRU_reg),
  .init(init_reg2),
  .en(read_clkEn_reg2)
  );

  
  always @(negedge clk)
  begin
      if (rst) read_clkEn_reg<=1'b0;
      else read_clkEn_reg<=read_clkEn;
      if (rst) read_clkEn_reg2<=1'b0;
      else read_clkEn_reg2<=read_clkEn_reg;
      if (rst) begin
          read_phys_addr_reg<=37'b0;
          write_phys_addr_reg<=37'b0;
          write_wen_reg<=1'b0;
          read_NRUr_reg<=3'b0;
          invalidate_reg<=1'b0;
          read_phys_addr_reg2<=37'b0;
          init_reg<=1'b0;
          init_reg2<=1'b0;
	  read_hit_reg<=1'b0;
      end
      else begin
          read_phys_addr_reg<=read_phys_addr;
          write_phys_addr_reg<=write_phys_addr;
          write_wen_reg<=write_wen;
          read_NRUr_reg<=read_NRUr;
          invalidate_reg<=invalidate;
          read_phys_addr_reg2<=read_phys_addr_reg;
          init_reg<=init;
          init_reg2<=init_reg;
	  read_hit_reg<=read_hit;
      end
      if (write_wen_reg) $display("whit ",write_data_way," lruw ",read_NRUw);
     // if (read_clkEn_reg) $display("rhit ",read_phys_addr_reg," ",read_hit);
  end
  
endmodule
