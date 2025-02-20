`timescale 1ps / 1ps

module avalon_master_bfm_module (
		input  wire        clk,
		input  wire        reset,
		output wire  [4:0] avs_address,
		input  wire [31:0] avs_readdata,
		output wire [31:0] avs_writedata,
		output wire        avs_write
	);

	altera_avalon_mm_master_bfm #(
		.AV_ADDRESS_W               (5),
		.AV_SYMBOL_W                (8),
		.AV_NUMSYMBOLS              (4),
		.AV_BURSTCOUNT_W            (1),
		.AV_READRESPONSE_W          (8),
		.AV_WRITERESPONSE_W         (8),
		.USE_READ                   (0),
		.USE_WRITE                  (1),
		.USE_ADDRESS                (1),
		.USE_BYTE_ENABLE            (0),
		.USE_BURSTCOUNT             (0),
		.USE_READ_DATA              (1),
		.USE_READ_DATA_VALID        (0),
		.USE_WRITE_DATA             (1),
		.USE_BEGIN_TRANSFER         (0),
		.USE_BEGIN_BURST_TRANSFER   (0),
		.USE_WAIT_REQUEST           (1),
		.USE_TRANSACTIONID          (0),
		.USE_WRITERESPONSE          (0),
		.USE_READRESPONSE           (0),
		.USE_CLKEN                  (0),
		.AV_CONSTANT_BURST_BEHAVIOR (0),
		.AV_BURST_LINEWRAP          (0),
		.AV_BURST_BNDR_ONLY         (0),
		.AV_MAX_PENDING_READS       (0),
		.AV_MAX_PENDING_WRITES      (0),
		.AV_FIX_READ_LATENCY        (0),
		.AV_READ_WAIT_TIME          (1),
		.AV_WRITE_WAIT_TIME         (0),
		.REGISTER_WAITREQUEST       (0),
		.AV_REGISTERINCOMINGSIGNALS (0),
		.VHDL_ID                    (0)
	) mm_master_bfm (
		.clk                    (clk),             //       clk.clk
		.reset                  (reset),           // clk_reset.reset
		.avm_address            (avs_address),     //        m0.address
		.avm_readdata           (avs_readdata),    //          .readdata
		.avm_writedata          (avs_writedata),   //          .writedata
		.avm_waitrequest        (1'b0),            //          .waitrequest
		.avm_write              (avs_write),       //          .write
		.avm_read               (),                //          .read
		.avm_byteenable         (),                //          .byteenable
		.avm_burstcount         (),                // (terminated)
		.avm_begintransfer      (),                // (terminated)
		.avm_beginbursttransfer (),                // (terminated)
		.avm_readdatavalid      (1'b0),            // (terminated)
		.avm_arbiterlock        (),                // (terminated)
		.avm_lock               (),                // (terminated)
		.avm_debugaccess        (),                // (terminated)
		.avm_transactionid      (),                // (terminated)
		.avm_readid             (8'b00000000),     // (terminated)
		.avm_writeid            (8'b00000000),     // (terminated)
		.avm_clken              (),                // (terminated)
		.avm_response           (),                // (terminated)
    .avm_writeresponserequest(),
		.avm_writeresponsevalid (1'b0),            // (terminated)
		.avm_readresponse       (8'b00000000),     // (terminated)
		.avm_writeresponse      (8'b00000000)      // (terminated)
	);

endmodule
