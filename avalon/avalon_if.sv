//------------------------
// Avalon interface
//------------------------

interface avalon_if #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10
) (
    input logic clk,
    input logic rst
);
    logic read;
    logic write;
    logic waitrequest;
    logic readdatavalid;
    logic beginbursttransfer;
    logic [1:0] response;
    logic [ADDR_WIDTH-1:0] address;
    logic [DATA_WIDTH-1:0] writedata;
    logic [DATA_WIDTH-1:0] readdata;
    logic [DATA_WIDTH-1:0] burstcount;

    modport host (
        input clk,
        input rst,
        input readdata,
        input waitrequest,
        input readdatavalid,
        input response,
        output read,
        output write,
        output address,
        output writedata,
        output burstcount
        output beginbursttransfer
    );

    modport agent (
        input clk,
        input rst,
        input read,
        input write,
        input address,
        input writedata,
        input burstcount
        input beginbursttransfer,
        output waitrequest,
        output readdatavalid,
        output readdata,
        output response
    );

endinterface