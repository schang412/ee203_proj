module gen_stim #(
    parameter CLK_US = 2,
    parameter STIM_WIDTH_US = 1000,
    parameter STIM_GAP_US = 1000,
    parameter STIM_PERIOD_US = 600000
)
(
    input  wire CLK_500K,

    output wire VSTIM_P,
    output wire VSTIM_N,

    input  wire [3:0] MEASURE_PRESCALAR,

    output wire DO_SAMPLE
);
localparam PLUS_STIM_END = STIM_WIDTH_US/CLK_US;
localparam NEG_STIM_BEGIN = PLUS_STIM_END + STIM_GAP_US/CLK_US;
localparam NEG_STIM_END = NEG_STIM_BEGIN + STIM_WIDTH_US/CLK_US;

reg VSTIM_P_Q = 0;
reg VSTIM_N_Q = 0;
reg DO_SAMPLE_Q = 0;

reg [3:0] MEASURE_PRESCALAR_Q = 0;
reg [31:0] counter = 0;

assign VSTIM_P = VSTIM_P_Q;
assign VSTIM_N = VSTIM_N_Q;
assign DO_SAMPLE = DO_SAMPLE_Q;

always @(posedge CLK_500K) begin
    VSTIM_P_Q <= 0;
    VSTIM_N_Q <= 0;
    counter <= counter + 1;
    MEASURE_PRESCALAR_Q <= MEASURE_PRESCALAR;

    if (counter <= NEG_STIM_END) begin
        DO_SAMPLE_Q <= 0;
        if (counter <= PLUS_STIM_END)
            VSTIM_P_Q <= 1;
        else if (counter >= NEG_STIM_BEGIN)
            VSTIM_N_Q <= 1;
    end else begin
        if (counter % MEASURE_PRESCALAR_Q == 0) begin
            DO_SAMPLE_Q <= ~DO_SAMPLE_Q;
        end
    end

    if (counter >= STIM_PERIOD_US/CLK_US) begin
        counter <= 0;
    end

end
endmodule
