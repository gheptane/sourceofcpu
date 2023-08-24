
module testcase(
  input clk,
  input rst);

  wire IRQ;
  wire [16:0] IRQ_data;
  wire IRQ_thr;
  wire [67:0] obusIn;
  wire [81:0] obusOut;
  wire obusOut_want;
  wire obusOut_can;
  wire [37:0] obusDIns;
  wire [511+56:0] obusDIn_data;
  wire [511+56:0] obusDOut_dataAUD;
  wire [75:0] obusDOut_iosig;
  wire obusDOut_can;
  wire obusDOut_want;
  wire obusDOut_replay;

  reg [1023:0] RAM[1024*1024*5-1:0];
  reg [15:0] RAM_PTR[1024*1024*5-1:0];
  reg [4*33-1:0] RAM_RETIRE[1024*1024*8-1:0]
  reg [4*33-1:0] reti_read_data[9:0];
  reg [22:0] retire_index;
  integer k,j,p,n,err,noretcnt;

  reg [4:0] rA[9:0];
  reg [4:0] rB[9:0];
  reg [4:0] rT[9:0];
  reg rT_en[9:0];
  reg [31:0] binoffaddr[9:0];
  reg [64:0] data[9:0];
  reg [9:0] pook_en;

  reg [8:0] ret_en;
  reg [8:0] ret_enV;
  reg [8:0] ret_enF;
  reg [9:0] ret_enX;
  reg [9:0] ret_enX0;
  reg [8:0][64:0] ret_data;
  reg [8:0][5:0] ret_rT;

  reg [5:0][`lsaddr_width-1:0] reqA_adata;
  reg [5:0] reqA_en;
  reg reqA_clkEn;
  reg reqA_clkEnP;
  reg [3:0] mem_hit;
  reg [`lsqshare_width-1:0] reqA_shrdata;
  integer reqA_cnt;

  generate
    genvar b1,b2;
    for(b1=0;b1<71; b1=b1+1) begin
        for(b2=0;b2<8;b2=b2+1) begin
            assign obusDOut_dataX[b1+71*b2]=obusDOut_dataAUD[2*b1+71*b2];
            ecc_strip #(64) str_mod({1'b0,oubsDOut_dataX[b2*71+:71]}, obusDOut_dataY[b2*64+:64]);
        end
    end
  endgenerate
  always @* begin
      pook_en=0;
      ret_data=core_mod.bck_mod.ret_dataA;
      ret_enX0=~core_mod.bck_mod.retM_xbreak&{10{core_mod.bck_mod.retM_retire}};
      ret_en[0]=core_mod.bck_mod.retire0_enG;
      ret_en[1]=core_mod.bck_mod.retire1_enG;
      ret_en[2]=core_mod.bck_mod.retire2_enG;
      ret_en[3]=core_mod.bck_mod.retire3_enG;
      ret_en[4]=core_mod.bck_mod.retire4_enG;
      ret_en[5]=core_mod.bck_mod.retire5_enG;
      ret_en[6]=core_mod.bck_mod.retire6_enG;
      ret_en[7]=core_mod.bck_mod.retire7_enG;
      ret_en[8]=core_mod.bck_mod.retire8_enG;
      ret_rT[0]=core_mod.bck_mod.retire0_rT;
      ret_rT[1]=core_mod.bck_mod.retire1_rT;
      ret_rT[2]=core_mod.bck_mod.retire2_rT;
      ret_rT[3]=core_mod.bck_mod.retire3_rT;
      ret_rT[4]=core_mod.bck_mod.retire4_rT;
      ret_rT[5]=core_mod.bck_mod.retire5_rT;
      ret_rT[6]=core_mod.bck_mod.retire6_rT;
      ret_rT[7]=core_mod.bck_mod.retire7_rT;
      ret_rT[8]=core_mod.bck_mod.retire8_rT;
      reqA_adata[0]=core_mod.bck_mod.LSQ_grouped.LSQ_dataA0;
      reqA_adata[1]=core_mod.bck_mod.LSQ_grouped.LSQ_dataA1;
      reqA_adata[2]=core_mod.bck_mod.LSQ_grouped.LSQ_dataA2;
      reqA_adata[3]=core_mod.bck_mod.LSQ_grouped.LSQ_dataA3;
      reqA_adata[4]=core_mod.bck_mod.LSQ_grouped.LSQ_dataA4;
      reqA_adata[5]=core_mod.bck_mod.LSQ_grouped.LSQ_dataA5;
      reqA_en[0]=core_mod.bck_mod.LSQ_grouped.LSQ_enA[0];
      reqA_en[1]=core_mod.bck_mod.LSQ_grouped.LSQ_enA[1];
      reqA_en[2]=core_mod.bck_mod.LSQ_grouped.LSQ_enA[2];
      reqA_en[3]=core_mod.bck_mod.LSQ_grouped.LSQ_enA[3];
      reqA_en[4]=core_mod.bck_mod.LSQ_grouped.LSQ_enA[4];
      reqA_en[5]=core_mod.bck_mod.LSQ_grouped.LSQ_enA[5];
      reqA_clkEn=core_mod.bck_mod.LSQ_grouped.LSQ_rdy_A;
      reqA_clkEnP=core_mod.bck_mod.LSQ_grouped.LSQ_rdy_AP;
      mem_hit[0]=core_mod.bck_mod.FU0Hit;
      mem_hit[1]=core_mod.bck_mod.FU1Hit;
      mem_hit[2]=core_mod.bck_mod.FU2Hit;
      mem_hit[3]=core_mod.bck_mod.FU3Hit;
      reqA_shrdata=core_mod.bck_mod.LSQ_grouped.LSQ_shr_dataA;
      //V,F later
      for(k=0;k<10;k=k+1) begin
          reti_read_data[k]=RAM_RETIRE[retire_index[k]];
          if (ret_enX[k] && rT_en[k]) begin
              pook_en[k]=1;
              for(j=k;j<10;j=j+1) begin
                  if (ret_enX[j] && rT_en[j] && rT[j]==rT[k]) pook_en[k]=0;
              end
          end
      end
  end
  initial begin
      $readmemh(RAM_RETIRE,"./prog.memh");
      $readmemh(RAM,"./bin.memh");
      $readmemh(RAM,"./bin_p.memh");
  end

  always @(posedge clk) begin
      ret_enX<=ret_enX0;
      err=-1;
      if (rst) begin noretcnt=0; reqA_cnt=0; end
      if (!rst) begin
          for(p=0;p<10;p=p+1) begin
              if (read_enX[p] && ~read_enX[(p+1)%10]|(p==9)) begin
                  noretcnt=0;
              end
              if (pook_en[p]) begin
                  for(n=0;n<9;n=n+1) begin
                      if ((ret_rT[n]==rT[p] && ret_data[n]=data[p])||!rT_en[p]) begin
                          err=p;
                      end else if (ret_rT[n]==rT[p] && ret_en[n] && rT_en[p] && pook_en[p]) begin
                          $display("errval velrilog=%x, c++=%x",ret_data[n],data[p]);
                      end                     
                  end
                  if (err!=p) $display("miss-execution %%RIP=0x%x, rT=%i, rB=%i, rA=%i, rT_en=%i",
                      binoff[p],rT[p],rB[p],rA[p],rT_en[p]);
              end
              if (read_enX[p] && ~read_enX[(p+1)%10]|(p==9)) begin
                  retire_index=retire_index+p;
                  if (p!=err) $finish();
              end
              if (read_enX==0) noretcnt=noretcnt+1;
              if (noretcnt>=200) begin
                  $display("error: 200 cycles no retire");
                  $finish();
              end
          end
          if (reqA_en) begin
              reqA_cnt=0;
          end else begin
              reqA_cnt=reqA_cnt+1;
              if (reqA_cnt>=200) begin
                   $display("error: 200 cycles no ldq align");
              end
          end
      end
  end

 

  heptane_core core_mod(
  clk,
  rst,
  IRQ,
  IRQ_data,
  IRQ_thr,
  obusIn,
  obusOut,
  obusOut_want,
  obusOut_can,
  obusDIns,
  obusDIn_data,
  obusDOut_dataAUD,
  obusDOut_iosig,
  obusDOut_can,
  inout obusDOut_want,
  obusDOut_replay
  );

endmodule
