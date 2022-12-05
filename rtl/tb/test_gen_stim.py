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

    dut.STIM_PERIOD_CYCLES.value = 5000  # 5000 * 2e-6s = 10ms
    dut.STIM_WIDTH_CYCLES.value = 500  # 1ms pulse width
    dut.STIM_GAP_CYCLES.value = 500  # 1 ms pulse gap

    dut.MEASURE_PRESCALAR.value = 0b0001
    await Timer(100, units='ms')

    dut.MEASURE_PRESCALAR.value = 0b0011
    await Timer(100, units='ms')

    dut.MEASURE_PRESCALAR.value = 0b0111
    await Timer(100, units='ms')

    dut.STIM_PERIOD_CYCLES.value = 2500  # 2500 * 2e-6s = 5ms
    await Timer(30, units='ms')
