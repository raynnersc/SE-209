//------------------------
// Avalon RAM
//------------------------

module avalon_ram #(
    parameter int mem_adr_width = 10
) (
    avalon_if.agent av_agent
);

    logic[7:0] ram [0:2**mem_adr_width - 1];

    always @(posedge av_agent.clk) begin
        if (!av_agent.rst) begin
            av_agent.readdata <= 0;
            av_agent.response <= 2'b01; // RESERVED
        end 
        else begin
            if (av_agent.write && !av_agent.read) begin
                ram[av_agent.address] <= av_agent.writedata;
                av_agent.response <= 2'b00; // OK
            end
            else if (av_agent.read && !av_agent.write) begin
                av_agent.readdata <= ram[av_agent.address];
                av_agent.response <= 2'b00; // OK
            end
            else begin
                av_agent.response <= 2'b10; // SLVERR
            end
        end
    end

endmodule