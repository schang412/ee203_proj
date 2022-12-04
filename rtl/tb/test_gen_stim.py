import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.binary import BinaryValue
from cocotb.result import TestFailure

@cocotb.test()
async def test_gen_stim(dut):
    clk = Clock(dut.CLK_500K, 2, 'us')
    # Start the clock
    cocotb.fork(clk.start())

    dut.MEASURE_PRESCALAR.value = 0b0001
    await Timer(1000, units='ms')

    dut.MEASURE_PRESCALAR.value = 0b0011
    await Timer(1000, units='ms')

    dut.MEASURE_PRESCALAR.value = 0b0111
    await Timer(1000, units='ms')
