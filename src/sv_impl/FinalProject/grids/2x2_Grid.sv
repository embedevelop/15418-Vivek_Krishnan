module internal_stage_fixed #(parameter DATA_SIZE = 32, parameter SAMPLE_SIZE = 4,
		 parameter NUM_SAMPLES = 4, parameter NUM_NODES = 32) (
    //Input pipeline
    input  logic [DATA_SIZE * SAMPLE_SIZE - 1: 0]	samp00, samp10,
    input  logic					sVal00, sVal10,
    input  logic [$clog2(NUM_NODES) - 1: 0]		nIdx00, nIdx01,
    input  logic					nVal00, nVal01,
    output logic					rec01, rec00, rec10,
    //Output pipeline
    output logic [DATA_SIZE * SAMPLE_SIZE - 1: 0]	samp02, samp12,
    output logic					sVal02, sVal12,
    output logic [$clog2(NUM_NODES) - 1: 0]		nIdx20, nIdx21,
    output logic					nVal20, nVal21,
    input  logic					rec20, rec21, rec02, rec12,
    //Memory
    input  logic [2 * DATA_SIZE - 1: 0]			memBus00, memBus01, memBus10, memBus11,
    output logic [$clog2(NUM_NODES) - 1: 0]		memRec00, memRec01, memRec10, memRec11,	
    //util
    input  logic					enable, memRdy,
    input  logic					clk, rst );

    logic [DATA_SIZE * SAMPLE_SIZE - 1: 0] 	samp01, samp11;
    logic				   	sVal01, sVal11;
    logic [$clog2(NUM_NODES) - 1: 0]		nIdx10, nIdx11;
    logic					nVal10, nVal11;

    logic					rec11;
    
    //Internal Branch Row 0 
    internal_branch_stage_fixed #(SAMPLE_SIZE,NUM_NODES,DATA_SIZE) 
					 b00 (memRdy, nVal00, sVal00, rec00, nVal10, sVal01, 
				              rec10, rec01,samp00,samp01, nIdx00, nIdx10,
					      memBus00, memRec00,clk, rst);
   
    internal_branch_stage_fixed #(SAMPLE_SIZE,NUM_NODES,DATA_SIZE) 
					 b01 (memRdy, nVal01, sVal01, rec01, nVal11, sVal02, 
				              rec11, rec02,samp01,samp02, nIdx01, nIdx11,
					      memBus01, memRec01,clk, rst);
    
     //Internal Branch Row 1
    internal_branch_stage_fixed #(SAMPLE_SIZE,NUM_NODES,DATA_SIZE) 
					 b10 (memRdy, nVal10, sVal10, rec10, nVal20, sVal11, 
				              rec20, rec11,samp10,samp11, nIdx10, nIdx20,
					      memBus10, memRec10,clk, rst);
   
    internal_branch_stage_fixed #(SAMPLE_SIZE,NUM_NODES,DATA_SIZE) 
					 b11 (memRdy, nVal11, sVal11, rec11, nVal21, sVal12, 
				              rec21, rec12,samp11,samp12, nIdx11, nIdx21,
					      memBus11, memRec11,clk, rst);
endmodule : internal_stage_fixed
