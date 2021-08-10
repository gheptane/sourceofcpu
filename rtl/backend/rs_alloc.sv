`include "../struct.sv"



module rsAlloc2(
  clk,
  alloc0,alloc1,
  bufFree,
  newRsSelect0,
  newRsSelect1,
  doStall
  );
  parameter WIDTH=`rs_buf_count;
  
  input clk;
  input alloc0;
  input alloc1;
  input [WIDTH-1:0] bufFree;
  output [WIDTH-1:0] newRsSelect0;
  output [WIDTH-1:0] newRsSelect1;
  output doStall;

  wire [WIDTH-1:0] select0;
  wire [WIDTH-1:0] select1;
  wire found0;
  wire found1;
  wire selectsEqual;

  
  bit_find_first_bit first_mod(
    bufFree,
    select0,
    found0);
  defparam first_mod.WIDTH=WIDTH;

  bit_find_last_bit last_mod(
    bufFree,
    select1,
    found1);
  defparam last_mod.WIDTH=WIDTH;
  
  assign selectsEqual=(select0==select1);
  assign doStall=selectsEqual;
  assign newRsSelect0=select0 & {WIDTH{alloc0}};
  assign newRsSelect1=select1 & {WIDTH{alloc1}};

  
endmodule



module rsAlloc3(
  clk,
  alloc0,alloc1,alloc2,
  bufFree,
  newRsSelect0,
  newRsSelect1,
  newRsSelect2,
  doStall,
  stall
  );
  parameter WIDTH=`rs_buf_count;
  
  input clk;
  input alloc0;
  input alloc1;
  input alloc2;
  input [WIDTH-1:0] bufFree;
  output [WIDTH-1:0] newRsSelect0;
  output [WIDTH-1:0] newRsSelect1;
  output [WIDTH-1:0] newRsSelect2;
  output doStall;
  input stall;

  wire [WIDTH-1:0] select0;
  wire [WIDTH-1:0] select1;
  wire [WIDTH-1:0] select2;
  wire found0;
  wire found1;
  wire found2;
  wire error;

  
  bit_find_first_bit #(WIDTH) first_mod(
    bufFree,
    select0,
    found0);

  bit_find_first_bit #(WIDTH) first2_mod(
    bufFree&~select0,
    select2,
    found2);

  bit_find_last_bit #(WIDTH) last_mod(
    bufFree,
    select1,
    found1);
  
  assign error=(bufFree & ~(select0 | select1))=={WIDTH{1'B0}};
  assign doStall=error;
  assign newRsSelect0=select0 & {WIDTH{alloc0}};
  assign newRsSelect1=select1 & {WIDTH{alloc1}};
  assign newRsSelect2=select2 & {WIDTH{alloc2}};

  
endmodule


