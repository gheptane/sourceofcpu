`include "../struct.sv"
//verilator lint_off WIDTH
//dcache1_ram read during write behaviour: write first
module dc2_cntrl_ram(
  clk,
  rst,
  read_clkEn,
  read_addr,
  read_data,
  write_addr,
  write_data,
  write_wen
  );
  localparam ADDR_WIDTH=4;
  localparam DATA_WIDTH=`mOpC_width+2+16;
  localparam ADDR_COUNT=16;
  
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

  always @(posedge clk)
    begin
      if (rst) read_addr_reg<={ADDR_WIDTH{1'b0}};
      else if (read_clkEn) read_addr_reg<=read_addr; 
      if (write_wen) ram[write_addr]<=write_data;
    end

endmodule

//dcache1_ram read during write behaviour: write first
module dc2_cntrlD_ram(
  clk,
  rst,
  read_clkEn,
  read_addr,
  read_data,
  write_addr,
  write_data,
  write_wen
  );
  localparam ADDR_WIDTH=4;
  localparam DATA_WIDTH=128+16;
  localparam ADDR_COUNT=16;
  
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

  always @(posedge clk)
    begin
      if (rst) read_addr_reg<={ADDR_WIDTH{1'b0}};
      else if (read_clkEn) read_addr_reg<=read_addr; 
      if (write_wen) ram[write_addr]<=write_data;
    end

endmodule

//dcache1_ram read during write behaviour: write first
module dc2_cntrlC_ram(
  clk,
  rst,
  read_clkEn,
  read_addr,
  read_data,
  write_addr,
  write_data,
  write_wen
  );
  localparam ADDR_WIDTH=3;
  localparam DATA_WIDTH=37+5;
  localparam ADDR_COUNT=8;
  
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

  always @(posedge clk)
    begin
      if (rst) read_addr_reg<={ADDR_WIDTH{1'b0}};
      else if (read_clkEn) read_addr_reg<=read_addr; 
      if (write_wen) ram[write_addr]<=write_data;
    end

endmodule

//dcache1_ram read during write behaviour: write first
module dc2_cntrlC1_ram(
  clk,
  rst,
  read_clkEn,
  read_addr,
  read_data,
  write_addr,
  write_data,
  write_wen
  );
  localparam ADDR_WIDTH=4;
  localparam DATA_WIDTH=37+5+1+1+13;
  localparam ADDR_COUNT=16;
  
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

  always @(posedge clk)
    begin
      if (rst) read_addr_reg<={ADDR_WIDTH{1'b0}};
      else if (read_clkEn) read_addr_reg<=read_addr; 
      if (write_wen) ram[write_addr]<=write_data;
    end

endmodule


//dcache1_ram read during write behaviour: write first
module dc2_cntrlM_ram(
  clk,
  rst,
  read_clkEn,
  read_addr,
  read_data,
  write_addr,
  write_data,
  write_wen
  );
  localparam ADDR_WIDTH=5;
  localparam DATA_WIDTH=37+5+1+1+13;
  localparam ADDR_COUNT=25;
  
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

  always @(posedge clk)
    begin
      if (rst) read_addr_reg<={ADDR_WIDTH{1'b0}};
      else if (read_clkEn) read_addr_reg<=read_addr; 
      if (write_wen) ram[write_addr]<=write_data;
    end

endmodule

module dc2_cntrlM1_ram(
  clk,
  rst,
  read_clkEn,
  read_addr,
  read_data,
  write_addr,
  write_data,
  write_wen
  );
  localparam ADDR_WIDTH=5;
  localparam DATA_WIDTH=37+1+1;
  localparam ADDR_COUNT=25;
  
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

  always @(posedge clk)
    begin
      if (rst) read_addr_reg<={ADDR_WIDTH{1'b0}};
      else if (read_clkEn) read_addr_reg<=read_addr; 
      if (write_wen) ram[write_addr]<=write_data;
    end

endmodule

//dcache1_ram read during write behaviour: write first
module dc2_cntrlMiC2_ram(
  clk,
  rst,
  read_clkEn,
  read_addr,
  read_data,
  write_addr,
  write_data,
  write_wen
  );
  localparam ADDR_WIDTH=5;
  localparam DATA_WIDTH=37+5;
  localparam ADDR_COUNT=25;
  
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

  always @(posedge clk)
    begin
      if (rst) read_addr_reg<={ADDR_WIDTH{1'b0}};
      else if (read_clkEn) read_addr_reg<=read_addr; 
      if (write_wen) ram[write_addr]<=write_data;
    end

endmodule

module dc2_cntrl(
  clk,
  rst,
  doSkip,
  read_addr,
  read_en,
  read_req,
  read_dupl,
  read_want_excl,
  read_io,
  read_sz,
  read_bank0,
  read_low,
  Cread_addr,
  Cread_en,
  Cread_req,
  write0_clkEn,
  write_addrE0, 
  write_addrO0,
  write_bankEn0, 
  write_begin0,write_end0,
  write_bBen0,write_enBen0,
  write_odd0,write_split0,
  write_data0,
  write_pbit0,write_d128_0,
  write1_clkEn,
  write_addrE1,
  write_addrO1, 
  write_bankEn1,
  write_begin1,write_end1,
  write_bBen1,write_enBen1,
  write_odd1,write_split1,
  write_data1,
  write_pbit1,write_d128_1,
//  writeI0_clkEn,
  writeI_addrE0, writeI_hitE0,
  writeI_addrO0, writeI_hitO0,
  writeI_bankEn0, 
  writeI_begin0,writeI_end0,
  writeI_bBen0,writeI_enBen0,
  writeI_odd0,writeI_split0,
  writeI_data0,
  writeI_pbit0,writeI_d128_0,
//  writeI1_clkEn,
  writeI_addrE1, writeI_hitE1,
  writeI_addrO1, writeI_hitO1,
  writeI_bankEn1,
  writeI_begin1,writeI_end1,
  writeI_bBen1,writeI_enBen1,
  writeI_odd1,writeI_split1,
  writeI_data1,
  writeI_pbit1,writeI_d128_1,
  writeI_exp,
  readI_en,readI_en2,readI_odd,readI_req,readI_code,readI_dupl,
  readI_want_excl,readI_io,readI_dataIO,readI_ins_A,readI_ins_B,
  miss_en,miss_addr,miss_req,miss_dupl,miss_want_excl, 
  rbus_signals,rbus_src_req,rbus_dst_req,rbus_address,rbus_can,rbus_want,rbus_bank0,rbus_sz,rbus_low,
  rbusD_signals,rbusD_src_req,rbusD_dst_req,rbusD_data64
  );
  parameter [4:0] ID=0;
  localparam STALL_CNT=12;
  localparam ADDR_WIDTH=36;
  input clk;
  input rst;
  output doSkip;
  input [36:0] read_addr;
  input read_en;
  input [4:0] read_req;
  input read_dupl;
  input read_want_excl;
  input read_io;
  input [4:0] read_sz;
  input [4:0] read_bank0;
  input [1:0] read_low;
  input [36:0] Cread_addr;
  input Cread_en;
  input [4:0] Cread_req;
  input [1:0] write0_clkEn;
  input [ADDR_WIDTH-1:0] write_addrE0;
  input [ADDR_WIDTH-1:0] write_addrO0;
  input [31:0] write_bankEn0;
  input [4:0] write_begin0;
  input [4:0] write_end0;
  input [3:0] write_bBen0;
  input [3:0] write_enBen0;
  input write_odd0,write_split0;
  input [159:0] write_data0;
  input [1:0] write_pbit0;
  input write_d128_0;
  input [1:0] write1_clkEn;
  input [ADDR_WIDTH-1:0] write_addrE1;
  input [ADDR_WIDTH-1:0] write_addrO1;
  input [31:0] write_bankEn1;
  input [4:0] write_begin1;
  input [4:0] write_end1;
  input [3:0] write_bBen1;
  input [3:0] write_enBen1;
  input write_odd1,write_split1;
  input [159:0] write_data1;
  input [1:0] write_pbit1;
  input write_d128_1;
  output [ADDR_WIDTH-1:0] writeI_addrE0;
  output writeI_hitE0; //+1 cycle
  output [ADDR_WIDTH-1:0] writeI_addrO0;
  output writeI_hitO0; //+1 cycle
  output [31:0] writeI_bankEn0;
  output [4:0] writeI_begin0;
  output [4:0] writeI_end0;
  output [3:0] writeI_bBen0;
  output [3:0] writeI_enBen0;
  output writeI_odd0,writeI_split0;
  output [159:0] writeI_data0;
  output [1:0] writeI_pbit0;
  output writeI_d128_0;
  output [ADDR_WIDTH-1:0] writeI_addrE1;
  output writeI_hitE1; //+1 cycle
  output [ADDR_WIDTH-1:0] writeI_addrO1;
  output writeI_hitO1; //+1 cycle
  output [31:0] writeI_bankEn1;
  output [4:0] writeI_begin1;
  output [4:0] writeI_end1;
  output [3:0] writeI_bBen1;
  output [3:0] writeI_enBen1;
  output writeI_odd1,writeI_split1;
  output [159:0] writeI_data1;
  output [1:0] writeI_pbit1;
  output writeI_d128_1;
  output writeI_exp;
  output readI_en,readI_en2,readI_odd;
  output [4:0] readI_req;
  output readI_code;
  output readI_dupl;
  output readI_want_excl;
  output readI_io;
  output [63:0] readI_dataIO;
  output readI_ins_A,readI_ins_B;
  input miss_en;
  input [36:0] miss_addr;
  input [4:0] miss_req;
  input miss_dupl;
  input miss_want_excl;
  output [`rbus_width-1:0] rbus_signals;
  output [9:0] rbus_src_req;
  output [9:0] rbus_dst_req;
  output [36:0] rbus_address;
  input rbus_can;
  output rbus_want;
  output [4:0] rbus_bank0;
  output [4:0] rbus_sz;
  output [1:0] rbus_low;
  input [`rbusD_width-1:0] rbusD_signals;
  input [9:0] rbusD_src_req;
  input [9:0] rbusD_dst_req;
  input [63:0] rbusD_data64;
//  output rbusD_en_out;

  wire [36:0] rbusD_addr_out;
  wire [`mOpC_width-1:0] write_mop[1:0];
  wire [`mOpC_width-1:0] read_mop[1:0];
  wire read_clkEn;
  reg [4:0] cnt;
  reg [3:0] read_addr0;
  reg [3:0] write_addr;
  wire [4:0] cnt_plus;
  wire [4:0] cnt_minus;
  wire [3:0] read_addr0_d;
  wire [3:0] write_addr_d;
  wire read_clkEnC;
  reg [3:0] cntC;
  reg [2:0] read_addrC;
  reg [2:0] write_addrC;
  wire [3:0] cntC_plus;
  wire [3:0] cntC_minus;
  wire [2:0] read_addrC_d;
  wire [2:0] write_addrC_d;
  wire read_clkEnM;
  reg [4:0] cntM;
  reg [4:0] read_addrM;
  reg [4:0] write_addrM;
  wire [4:0] cntM_plus;
  wire [4:0] cntM_minus;
  wire [4:0] read_addrM_d;
  wire [4:0] write_addrM_d;
  reg [63:0] rbusD_data64_reg;

  wire [159:0] read_data0;
  wire [159:0] read_data1;
  wire [1:0] read_hit[1:0];

  wire read_clkEnC1;
  reg [4:0] cntC1;
  reg [3:0] read_addrC1;
  reg [3:0] write_addrC1;
  wire [4:0] cntC1_plus;
  wire [4:0] cntC1_minus;
  wire [3:0] read_addrC1_d;
  wire [3:0] write_addrC1_d;

  wire read_clkEnC2;
  reg readI_en2_reg;
  reg [4:0] cntC2;
  reg [4:0] read_addrC2;
  reg [4:0] write_addrC2;
  wire [4:0] cntC2_plus;
  wire [4:0] cntC2_minus;
  wire [4:0] read_addrC2_d;
  wire [4:0] write_addrC2_d;
  reg read_clkEn_reg;

  reg [`rbusD_width-1:0] rbusD_signals_reg;
  reg [9:0] rbusD_src_req_reg;
  reg [9:0] rbusD_dst_req_reg;

  wire [36:0] read_addr1;
  wire [4:0] read_req1;
  wire read_dupl1;
  wire read_want_excl1;
  wire read_io1;
  wire [4:0] read_sz1;
  wire [4:0] read_bank01;
  wire [1:0] read_low1;
  reg read_io1_reg;
  reg [4:0] read_sz1_reg;
  reg [4:0] read_bank01_reg;
  reg [1:0] read_low1_reg;
  reg read_io1_reg2;
  reg [4:0] read_sz1_reg2;
  reg [4:0] read_bank01_reg2;
  reg [1:0] read_low1_reg2;
  reg read_io1_reg3;
  reg [4:0] read_sz1_reg3;
  reg [4:0] read_bank01_reg3;
  reg [1:0] read_low1_reg3;
  reg read_io1_reg4;
  reg [4:0] read_sz1_reg4;
  reg [4:0] read_bank01_reg4;
  reg [1:0] read_low1_reg4;
  wire [36:0] read_addr_C;
  wire [4:0] read_reqC;
  wire [36:0] read_addr_C2;
  wire [4:0] read_req_C2;
  reg read_io_C2;
  reg [63:0] read_data_C2;
  wire [36:0] missR_addr;
  wire [4:0] missR_req;
  wire missR_io;
  wire [4:0] missR_sz;
  wire [4:0] missR_bank0;
  wire [1:0] missR_low;
  wire missR_dupl;
  wire missR_want_excl;
  wire read_clkEnM1;
  wire dupl_M1;
  wire write_wen;
  wire wen_C2;
//  reg rst_reg;
  wire miss_io;
  wire [4:0] miss_sz;
  wire [4:0] miss_bank0;
  wire [1:0] miss_low;

  wire read_M1_exp;
  
  reg init;
  reg [4:0] initCount;
  wire [4:0] initCount_next;
  
  assign write_mop[0][`mOpC_addrEven]=write_addrE0;
  assign write_mop[0][`mOpC_addrOdd]=write_addrO0;
  assign write_mop[0][`mOpC_banks]=write_bankEn0;
  assign write_mop[0][`mOpC_begin]=write_begin0;
  assign write_mop[0][`mOpC_end]=write_end0;
  assign write_mop[0][`mOpC_bben]=write_bBen0;
  assign write_mop[0][`mOpC_endben]=write_enBen0;
  assign write_mop[0][`mOpC_odd]=write_odd0;
  assign write_mop[0][`mOpC_split]=write_split0;
  assign write_mop[0][`mOpC_req]=read_req[2:0];
  assign write_mop[0][`mOpC_pbit]=write_pbit0;
  assign write_mop[0][`mOpC_d128]=write_d128_0;
  
  assign write_mop[1][`mOpC_addrEven]=write_addrE1;
  assign write_mop[1][`mOpC_addrOdd]=write_addrO1;
  assign write_mop[1][`mOpC_banks]=write_bankEn1;
  assign write_mop[1][`mOpC_begin]=write_begin1;
  assign write_mop[1][`mOpC_end]=write_end1;
  assign write_mop[1][`mOpC_bben]=write_bBen1;
  assign write_mop[1][`mOpC_endben]=write_enBen1;
  assign write_mop[1][`mOpC_odd]=write_odd1;
  assign write_mop[1][`mOpC_split]=write_split1;
  assign write_mop[1][`mOpC_req]={1'b0,read_req[4:3]};
  assign write_mop[1][`mOpC_pbit]=write_pbit1;
  assign write_mop[1][`mOpC_d128]=write_d128_1;
  
  assign write_wen=write0_clkEn || write1_clkEn;
  assign read_clkEn=cnt && ~read_clkEnC && ~read_clkEnC2 && ~readI_en2_reg && 
    ~read_clkEnC1 && ~read_clkEnM1; //write
  assign read_clkEnC=~read_clkEnC2 && ~readI_en2_reg && ~read_clkEnC1 && ~read_clkEnM1 && cntC;  //read code
  assign read_clkEnM=rbus_can && rbus_want;
  assign rbus_want=cntM!=5'd0;
  assign read_clkEnC1=cntC1 && ~read_clkEnM1 && ~read_clkEnC2 && ~readI_en2_reg;  //read data
  assign read_clkEnC2=1'b0;
  assign read_clkEnM1=rbusD_signals_reg[`rbusD_used] && (rbusD_signals_reg[`rbusD_mem_reply] &&
    rbusD_dst_req_reg[9:5]==ID)|rbusD_signals_reg[`rbusD_expun]; //cl insert
  assign read_M1_exp=rbusD_signals_reg[`rbusD_used] && rbusD_signals_reg[`rbusD_expun];
  assign writeI_addrE0=read_clkEnC1 ? read_addr1[36:1] : 36'bz;
  assign writeI_addrO0=read_clkEnC1 ? read_addr1[36:1] : 36'bz;
  assign writeI_bankEn0=(read_clkEnC2|read_clkEnC1|read_clkEnC|read_clkEnM1) ? 
    32'hffffffff : read_mop[0][`mOpC_banks];
  assign writeI_begin0=(read_clkEnC2|read_clkEnC1|read_clkEnC|read_clkEnM1) ? 5'd0 : read_mop[0][`mOpC_begin];
  assign writeI_end0=(read_clkEnC2|read_clkEnC1|read_clkEnC|read_clkEnM1) ? 5'd0 : read_mop[0][`mOpC_end];
  assign writeI_bBen0=(read_clkEnC2|read_clkEnC1|read_clkEnC|read_clkEnM1) ? 4'hf : read_mop[0][`mOpC_bben];
  assign writeI_enBen0=(read_clkEnC2|read_clkEnC1|read_clkEnC|read_clkEnM1) ? 4'hf : read_mop[0][`mOpC_endben];
  assign writeI_pbit0=(read_clkEnC2|read_clkEnC1|read_clkEnC|read_clkEnM1) ? 2'b0 : read_mop[0][`mOpC_pbit];
  assign writeI_d128_0=(read_clkEnC2|read_clkEnC1|read_clkEnC|read_clkEnM1) ? 1'b0 : read_mop[0][`mOpC_d128];
  assign writeI_odd0=read_clkEnC1 ? read_addr1[0] : 1'bz;
  assign writeI_split0=read_clkEnC1 ? 1'b0 : 1'bz;
  assign writeI_data0=read_data0;
  assign {writeI_hitO0,writeI_hitE0}=( read_clkEnC2|read_clkEnC1|read_clkEnC|read_clkEnM1) ?
    {writeI_odd0,~writeI_odd0} &{2{~read_clkEnM1}} : read_hit[0] & {2{read_clkEn}};

  assign writeI_addrE1=read_clkEnC1 ? read_addr1[36:1] : 36'bz;
  assign writeI_addrO1=read_clkEnC1 ? read_addr1[36:1] : 36'bz;
  assign writeI_bankEn1=(read_clkEnC1|read_clkEnC) ? 32'h0 : read_mop[1][`mOpC_banks];
  assign writeI_begin1=(read_clkEnC1|read_clkEnC) ? 5'd1 : read_mop[1][`mOpC_begin];
  assign writeI_end1=(read_clkEnC1|read_clkEnC) ? 5'd1 : read_mop[1][`mOpC_end];
  assign writeI_bBen1=(read_clkEnC1|read_clkEnC) ? 4'hf : read_mop[1][`mOpC_bben];
  assign writeI_enBen1=(read_clkEnC1|read_clkEnC) ? 4'hf : read_mop[1][`mOpC_endben];
  assign writeI_pbit1=(read_clkEnC1|read_clkEnC) ? 2'b0 : read_mop[1][`mOpC_pbit];
  assign writeI_d128_1=(read_clkEnC1|read_clkEnC) ? 1'b0 : read_mop[1][`mOpC_d128];
  assign writeI_odd1=read_clkEnC1 ? read_addr1[0] : 1'bz;
  assign writeI_split1=read_clkEnC1 ? 1'b0 : 1'bz;
  assign writeI_data1=read_data1;
  assign {writeI_hitO1,writeI_hitE1}=( read_clkEnC1|read_clkEnC|read_clkEnM1) ? 2'b0 : read_hit[1] & {2{read_clkEn}};

  assign writeI_addrE0=read_clkEn ? read_mop[0][`mOpC_addrEven] : 36'bz;
  assign writeI_addrO0=read_clkEn ? read_mop[0][`mOpC_addrOdd] : 36'bz;
  assign writeI_addrE1=read_clkEn ? read_mop[1][`mOpC_addrEven] : 36'bz;
  assign writeI_addrO1=read_clkEn ? read_mop[1][`mOpC_addrOdd] : 36'bz;
  assign writeI_odd0=read_clkEn ? read_mop[0][`mOpC_odd] : 1'bz;
  assign writeI_split0=read_clkEn ? read_mop[0][`mOpC_split] : 1'bz;
  assign writeI_odd1=read_clkEn ? read_mop[1][`mOpC_odd] : 1'bz;
  assign writeI_split1=read_clkEn ? read_mop[1][`mOpC_split] : 1'bz;


  assign writeI_addrE0=read_clkEnM1&~read_M1_exp ? rbusD_addr_out[36:1] : 36'bz;
  assign writeI_addrO0=read_clkEnM1&~read_M1_exp ? rbusD_addr_out[36:1] : 36'bz;
  assign writeI_addrE1=read_clkEnM1&~read_M1_exp ? rbusD_addr_out[36:1] : 36'bz;
  assign writeI_addrO1=read_clkEnM1&~read_M1_exp ? rbusD_addr_out[36:1] : 36'bz;
  assign writeI_odd0=read_clkEnM1&~read_M1_exp ? rbusD_addr_out[0] : 1'bz;
  assign writeI_split0=read_clkEnM1&~read_M1_exp ? 1'b0 : 1'bz;
  assign writeI_odd1=read_clkEnM1&~read_M1_exp ? rbusD_addr_out[0] : 1'bz;
  assign writeI_split1=read_clkEnM1&~read_M1_exp ? 1'b0 : 1'bz;
  
  assign writeI_addrE0=read_clkEnM1&read_M1_exp ? rbusD_data64_reg[36:1] : 36'bz;
  assign writeI_addrO0=read_clkEnM1&read_M1_exp ? rbusD_data64_reg[36:1] : 36'bz;
  assign writeI_addrE1=read_clkEnM1&read_M1_exp ? rbusD_data64_reg[36:1] : 36'bz;
  assign writeI_addrO1=read_clkEnM1&read_M1_exp ? rbusD_data64_reg[36:1] : 36'bz;
  assign writeI_odd0=read_clkEnM1&read_M1_exp ? rbusD_data64_reg[0] : 1'bz;
  assign writeI_split0=read_clkEnM1&read_M1_exp ? 1'b0 : 1'bz;
  assign writeI_odd1=read_clkEnM1&read_M1_exp ? rbusD_data64_reg[0] : 1'bz;
  assign writeI_split1=read_clkEnM1&read_M1_exp ? 1'b0 : 1'bz;
  
  
  assign writeI_addrE0=read_clkEnC2 ? read_addr_C2[36:1] : 36'bz;
  assign writeI_addrO0=read_clkEnC2 ? read_addr_C2[36:1] : 36'bz;
  assign writeI_addrE1=read_clkEnC2 ? read_addr_C2[36:1] : 36'bz;
  assign writeI_addrO1=read_clkEnC2 ? read_addr_C2[36:1] : 36'bz;
  assign writeI_odd0=read_clkEnC2 ? read_addr_C2[0] : 1'bz;
  assign writeI_split0=read_clkEnC2 ? 1'b0 : 1'bz;
  assign writeI_odd1=read_clkEnC2 ? read_addr_C2[0] : 1'bz;
  assign writeI_split1=read_clkEnC2 ? 1'b0 : 1'bz;
  
  assign writeI_addrE0=(read_clkEnC1|read_clkEnM1|read_clkEn|read_clkEnC2) ? 36'bz : read_addr_C[36:1];
  assign writeI_addrO0=(read_clkEnC1|read_clkEnM1|read_clkEn|read_clkEnC2) ? 36'bz : read_addr_C[36:1];
  assign writeI_addrE1=(read_clkEnC1|read_clkEnM1|read_clkEn|read_clkEnC2) ? 36'bz : read_addr_C[36:1];
  assign writeI_addrO1=(read_clkEnC1|read_clkEnM1|read_clkEn|read_clkEnC2) ? 36'bz : read_addr_C[36:1];
  assign writeI_odd0=(read_clkEnC1|read_clkEnM1|read_clkEn|read_clkEnC2) ? 1'bz : 1'b0;
  assign writeI_split0=(read_clkEnC1|read_clkEnM1|read_clkEn|read_clkEnC2) ? 1'bz : 1'b0;
  assign writeI_odd1=(read_clkEnC1|read_clkEnM1|read_clkEn|read_clkEnC2) ? 1'bz : 1'b0;
  assign writeI_split1=(read_clkEnC1|read_clkEnM1|read_clkEn|read_clkEnC2) ? 1'bz : 1'b0;
  
  assign readI_en=read_clkEnC2 | read_clkEnC1 | read_clkEnC | read_clkEnM1;
  assign readI_en2=read_clkEnC2 | read_clkEnC1 | read_clkEnC;
  assign readI_odd=read_clkEnC1 ? read_addr1[0] : 1'bz; 
  assign readI_odd=read_clkEnC ? read_addr_C[0] : 1'bz;
  assign readI_odd=read_clkEnC2 ? read_addr_C2[0] : 1'bz;
  assign readI_odd=(~read_clkEnC1 & ~read_clkEnC & ~read_clkEnC2) ? rbusD_addr_out[0] : 1'bz; 
  assign readI_req=read_clkEnC1 ? read_req1 : 5'bz;
  assign readI_req=read_clkEnC ? read_reqC : 5'bz;
  assign readI_req=read_clkEnC2 ? read_req_C2 : 5'bz;
  assign readI_req=(~read_clkEnC1 & ~read_clkEnC & ~read_clkEnC2) ? rbusD_dst_req_reg[4:0] : 5'bz;
  assign readI_code=read_clkEnC;
  assign readI_io=read_clkEnC2 && read_io_C2;
  assign readI_dataIO=read_data_C2;
  assign readI_ins_A=read_clkEnM1 && ~rbusD_signals_reg[`rbusD_second] && ~rbusD_signals_reg[`rbusD_iorpl] && 
	  ~rbusD_signals_reg[`rbusD_expun];
  assign readI_ins_B=read_clkEnM1 && rbusD_signals_reg[`rbusD_second] && ~rbusD_signals_reg[`rbusD_iorpl] && 
	  ~rbusD_signals_reg[`rbusD_expun];

  assign readI_dupl=read_clkEnC1 & read_dupl1 || read_clkEnM1 & dupl_M1;
  assign readI_want_excl=read_clkEnC1 & read_want_excl1;

  assign writeI_exp=read_clkEnM1 & rbusD_signals_reg[`rbusD_expun];

  assign miss_sz=read_sz1_reg4;
  assign miss_bank0=read_bank01_reg4;
  assign miss_low=read_low1_reg4;
  assign miss_io=read_clkEnC1 & read_io1_reg4;

  assign rbus_address=missR_addr;
  assign rbus_src_req={ID,missR_req};
  assign rbus_dst_req=10'h3ff;
  assign rbus_signals[`rbus_mreq]=~missR_io;
  assign rbus_signals[`rbus_ior]=missR_io;
  assign rbus_signals[`rbus_bcast]=1'b1;
  assign rbus_signals[`rbus_used]=read_clkEnM;
  assign rbus_signals[`rbus_second]=1'b0;
  assign rbus_signals[`rbus_want_excl]=missR_want_excl;
  assign rbus_signals[`rbus_code]=missR_req[4] && ~missR_req[3];
  assign rbus_signals[`rbus_creq]=1'b0;
  assign rbus_signals[`rbus_dupl]=missR_dupl;
  assign rbus_sz=missR_sz;
  assign rbus_bank0=missR_bank0;
  assign rbus_low=missR_low;

  adder_inc #(5) cntAdd_mod(cnt,cnt_plus,1'b1,);
  adder_inc #(4) wrtAdd_mod(write_addr,write_addr_d,1'b1,);  
  adder_inc #(4) readAdd_mod(read_addr0,read_addr0_d,1'b1,);  
  adder #(5) cntSub_mod(cnt,5'h1f,cnt_minus,1'b0,1'b1,,,,);
  get_carry #(5) cmp_mod(cnt,~STALL_CNT[4:0],1'b1,doSkip);
  adder_inc #(4) cntCAdd_mod(cntC,cntC_plus,1'b1,);
  adder_inc #(3) wrtCAdd_mod(write_addrC,write_addrC_d,1'b1,);  
  adder_inc #(3) readCAdd_mod(read_addrC,read_addrC_d,1'b1,);  
  adder #(4) cntCSub_mod(cntC,4'hf,cntC_minus,1'b0,1'b1,,,,);
  adder_inc #(5) cntMAdd_mod(cntM,cntM_plus,1'b1,);
  adder_inc #(5) wrtMAdd_mod(write_addrM,write_addrM_d,write_addrM!=5'd23,);  
  adder_inc #(5) readMAdd_mod(read_addrM,read_addrM_d,read_addrM!=5'd23,);  
  adder #(5) cntMSub_mod(cntM,5'h1f,cntM_minus,1'b0,1'b1,,,,);
  adder_inc #(5) cntC1Add_mod(cntC1,cntC1_plus,1'b1,);
  adder_inc #(4) wrtC1Add_mod(write_addrC1,write_addrC1_d,1'b1,);  
  adder_inc #(4) readC1Add_mod(read_addrC1,read_addrC1_d,1'b1,);  
  adder #(5) cntC1Sub_mod(cntC1,5'h1f,cntC1_minus,1'b0,1'b1,,,,);
  adder_inc #(5) cntC2Add_mod(cntC2,cntC2_plus,1'b1,);
  adder_inc #(5) wrtC2Add_mod(write_addrC2,write_addrC2_d,write_addrC2!=5'd23,);  
  adder_inc #(5) readC2Add_mod(read_addrC2,read_addrC2_d,read_addrC2!=5'd23,);  
  adder #(5) cntC2Sub_mod(cntC2,5'h1f,cntC2_minus,1'b0,1'b1,,,,);
  
  adder_inc #(5) initAdd_mod(initCount,initCount_next,1'b1,);

  assign write_addrM_d=(write_addrM==5'd23) ? 5'd0 : 5'bz;
  assign read_addrM_d=(read_addrM==5'd23) ? 5'd0 : 5'bz;
  assign write_addrC2_d=(write_addrC2==5'd23) ? 5'd0 : 5'bz;
  assign read_addrC2_d=(read_addrC2==5'd23) ? 5'd0 : 5'bz;

  assign wen_C2=read_clkEnM1 && ~rbusD_signals_reg[`rbusD_second];
  
  dc2_cntrl_ram ram0_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(read_clkEn),
  .read_addr(read_addr0_d),
  .read_data({read_mop[0],read_hit[0],read_data0[143:128]}),
  .write_addr(init ? initCount[3:0] : write_addr),
  .write_data(init ? 1'b0 : {write_mop[0],write0_clkEn,write_data0[143:128]}),
  .write_wen(write_wen|init)
  );
  dc2_cntrl_ram ram1_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(read_clkEn),
  .read_addr(read_addr0_d),
  .read_data({read_mop[1],read_hit[1],read_data0[159:144]}),
  .write_addr(init ? initCount[3:0] : write_addr),
  .write_data(init ? 1'b0 : {write_mop[1],write1_clkEn,write_data0[159:144]}),
  .write_wen(write_wen|init)
  );
  dc2_cntrlD_ram ramB0_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(read_clkEn),
  .read_addr(read_addr0_d),
  .read_data({read_data0[127:0],read_data1[143:128]}),
  .write_addr(init ? initCount[3:0] : write_addr),
  .write_data(init ? 1'b0 : {write_data0[127:0],write_data1[143:128]}),
  .write_wen(write_wen|init)
  );
  dc2_cntrlD_ram ramB1_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(read_clkEn),
  .read_addr(read_addr0_d),
  .read_data({read_data1[127:0],read_data1[159:144]}),
  .write_addr(init ? initCount[3:0] : write_addr),
  .write_data(init ? 1'b0 : {write_data1[127:0],write_data1[159:144]}),
  .write_wen(write_wen|init)
  );
  dc2_cntrlC_ram ramC_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(read_clkEnC),
  .read_addr(read_addrC_d),
  .read_data({read_addr_C,read_reqC}),
  .write_addr(init ? initCount[2:0] : write_addrC),
  .write_data(init ? 1'b0 : {Cread_addr,Cread_req}),
  .write_wen(Cread_en|init)
  );
  dc2_cntrlC1_ram ramC1_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(read_clkEnC1),
  .read_addr(read_addrC1_d),
  .read_data({read_want_excl1,read_dupl1,read_addr1,read_req1,read_io1,read_sz1,read_bank01,read_low1}),
  .write_addr(init ? initCount[3:0] : write_addrC1),
  .write_data(init ? 1'b0 : {read_want_excl,read_dupl,read_addr,read_req,read_io,read_sz,read_bank0,read_low}),
  .write_wen(read_en|init)
  );
  
  dc2_cntrlM_ram ramM_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(read_clkEnM),
  .read_addr(read_addrM_d),
  .read_data({missR_want_excl,missR_dupl,missR_addr,missR_req,missR_io,missR_sz,missR_bank0,missR_low}),
  .write_addr(init ? initCount : write_addrM),
  .write_data(init ? 1'b0 : {miss_want_excl,miss_dupl,miss_addr,miss_req,miss_io,miss_sz,miss_bank0,miss_low}),
  .write_wen(miss_en|init)
  );
  dc2_cntrlM1_ram ramM1_mod(
  .clk(clk),
  .rst(rst),
  .read_clkEn(1'b1),
  .read_addr(rbusD_dst_req[4:0]),
  .read_data({dupl_M1,rbusD_addr_out}),
  .write_addr(init ? initCount : miss_req),
  .write_data(init ? 1'b0 : {miss_dupl,miss_addr}),
  .write_wen(miss_en|init)
  );
  always @(posedge clk) begin
      if (rst) begin
          cnt<=5'd0;
          write_addr<=4'd0;
          read_addr0<=4'b0;
          cntC<=4'd0;
          write_addrC<=3'd0;
          read_addrC<=3'b0;
          cntM<=5'd0;
          write_addrM<=5'd0;
          read_addrM<=5'b0;
          cntC1<=5'd0;
          write_addrC1<=4'd0;
          read_addrC1<=4'b0;
          cntC2<=5'd0;
          write_addrC2<=4'd0;
          read_addrC2<=4'b0;
        //  read_addr_reg<=37'b0;
        //  read_en_reg<=1'b0;
          rbusD_signals_reg<=0;
          rbusD_src_req_reg<=10'b0;
          rbusD_dst_req_reg<=10'b0;
          readI_en2_reg<=1'b0;
	  read_clkEn_reg<=1'b0;
          read_io1_reg<=1'b0;
          read_sz1_reg<=5'b0;
          read_bank01_reg<=5'b0;
          read_low1_reg<=2'b0;
          read_io1_reg2<=1'b0;
          read_sz1_reg2<=5'b0;
          read_bank01_reg2<=5'b0;
          read_low1_reg2<=2'b0;
          read_io1_reg3<=1'b0;
          read_sz1_reg3<=5'b0;
          read_bank01_reg3<=5'b0;
          read_low1_reg3<=2'b0;
          read_io1_reg4<=1'b0;
          read_sz1_reg4<=5'b0;
          read_bank01_reg4<=5'b0;
          read_low1_reg4<=2'b0;
	  read_io_C2<=1'b0;
	  read_data_C2<=64'b0;
	  rbusD_data64_reg<=64'b0;
      end else begin
          if (write_wen & ~read_clkEn) cnt<=cnt_plus;
          if (read_clkEn & ~write_wen) cnt<=cnt_minus;
          if (write_wen) write_addr<=write_addr_d;
          if (read_clkEn) read_addr0<=read_addr0_d;
          if (Cread_en & ~read_clkEnC) cntC<=cntC_plus;
          if (read_clkEnC & ~Cread_en) cntC<=cntC_minus;
          if (Cread_en) write_addrC<=write_addrC_d;
          if (read_clkEnC) read_addrC<=read_addrC_d;
          if (miss_en & ~read_clkEnM) cntM<=cntM_plus;
          if (read_clkEnM & ~miss_en) cntM<=cntM_minus;
          if (miss_en) write_addrM<=write_addrM_d;
          if (read_clkEnM) read_addrM<=read_addrM_d;
          if (read_en & ~read_clkEnC1) cntC1<=cntC1_plus;
          if (read_clkEnC1 & ~read_en) cntC1<=cntC1_minus;
          if (read_en) write_addrC1<=write_addrC1_d;
          if (read_clkEnC1) read_addrC1<=read_addrC1_d;
          if (wen_C2 & ~read_clkEnC2) cntC2<=cntC2_plus;
          if (read_clkEnC2 & ~wen_C2) cntC2<=cntC2_minus;
          if (wen_C2) write_addrC2<=write_addrC2_d;
          if (read_clkEnC2) read_addrC2<=read_addrC2_d;
      //    read_addr_reg<=read_addr;
      //    read_en_reg<=read_en;
          rbusD_signals_reg<=rbusD_signals;
          rbusD_src_req_reg<=rbusD_src_req;
          rbusD_dst_req_reg<=rbusD_dst_req;
          readI_en2_reg<=readI_en2;
	  read_clkEn_reg<=read_clkEn;
          read_io1_reg<=read_io1;
          read_sz1_reg<=read_sz1;
          read_bank01_reg<=read_bank01;
          read_low1_reg<=read_low1;
          read_io1_reg2<=read_io1_reg;
          read_sz1_reg2<=read_sz1_reg;
          read_bank01_reg2<=read_bank01_reg;
          read_low1_reg2<=read_low1_reg;
          read_io1_reg3<=read_io1_reg2;
          read_sz1_reg3<=read_sz1_reg2;
          read_bank01_reg3<=read_bank01_reg2;
          read_low1_reg3<=read_low1_reg2;
          read_io1_reg4<=read_io1_reg3;
          read_sz1_reg4<=read_sz1_reg3;
          read_bank01_reg4<=read_bank01_reg3;
          read_low1_reg4<=read_low1_reg3;
	  if (wen_C2) begin
	      read_io_C2<=rbusD_signals_reg[`rbusD_iorpl];
	      read_data_C2<=rbusD_data64_reg[63:0];
	  end
	  rbusD_data64_reg<=rbusD_data64;
      end
      if (rst) begin
          init<=1'b1;
          initCount<=5'b0;
      end else if (init) begin
          initCount<=initCount_next;
          if (initCount==5'd23) init<=1'b0;
      end
  end
endmodule
//verilator lint_on WIDTH

