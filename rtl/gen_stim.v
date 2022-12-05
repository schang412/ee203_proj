module gen_stim #(
    parameter CLK_PERIOD_US = 2
)
(
    input  wire CLK_500K,

    output wire VSTIM_P,
    output wire VSTIM_N,
    output wire DO_SAMPLE,

    // this divides the clock by a prescalar to produce the clock for do_sample
    input  wire [3:0] MEASURE_PRESCALAR,
    
    // this times the clock period will give you the pulse width of a positive or negative stimulus
    input  wire [9:0] STIM_WIDTH_CYCLES,  
    
    // this times the clock period will give you the gap between the stimulus pulse (physiological effects) and the charge recovery pulse (the pulse used to reverse the direction of electrochemical processes incurred by the stimulus)
    input  wire [9:0] STIM_GAP_CYCLES,  
    
    // this times the clock period will give you the period between stimulus events
    input  wire [19:0] STIM_PERIOD_CYCLES
);

reg VSTIM_P_Q = 0;
reg VSTIM_N_Q = 0;
reg DO_SAMPLE_Q = 0;

reg [3:0] MEASURE_PRESCALAR_Q = 0;
reg [9:0] STIM_WIDTH_CYCLES_Q = 500;
reg [9:0] STIM_GAP_CYCLES_Q = 500;
reg [19:0] STIM_PERIOD_CYCLES_Q = 300000;
reg [31:0] counter = 0;

assign VSTIM_P = VSTIM_P_Q;
assign VSTIM_N = VSTIM_N_Q;
assign DO_SAMPLE = DO_SAMPLE_Q;

always @(posedge CLK_500K) begin
    VSTIM_P_Q <= 0;
    VSTIM_N_Q <= 0;
    counter <= counter + 1;
    MEASURE_PRESCALAR_Q <= MEASURE_PRESCALAR;
    STIM_WIDTH_CYCLES_Q <= STIM_WIDTH_CYCLES;
    STIM_GAP_CYCLES_Q <= STIM_GAP_CYCLES;
    STIM_PERIOD_CYCLES_Q <= STIM_PERIOD_CYCLES;

    if (counter <= 2*STIM_WIDTH_CYCLES_Q+STIM_GAP_CYCLES_Q) begin
        DO_SAMPLE_Q <= 0;
        if (counter <= STIM_WIDTH_CYCLES_Q)
            VSTIM_P_Q <= 1;
        else if (counter >= STIM_WIDTH_CYCLES_Q+STIM_GAP_CYCLES_Q)
            VSTIM_N_Q <= 1;
    end else begin
        if (counter % MEASURE_PRESCALAR_Q == 0) begin
            DO_SAMPLE_Q <= ~DO_SAMPLE_Q;
        end
    end

    if (counter >= STIM_PERIOD_CYCLES_Q) begin
        counter <= 0;
    end
end

initial begin
    $display("Default Stimulation Pulse Width:                   %d us", STIM_WIDTH_CYCLES_Q*CLK_PERIOD_US);
    $display("Default Gap between Stimulus and Recovery Pulse:   %d us", STIM_GAP_CYCLES_Q*CLK_PERIOD_US);
    $display("Default Period between Stimulus Pulses:            %d us", STIM_GAP_CYCLES_Q*CLK_PERIOD_US);
end
endmodule
