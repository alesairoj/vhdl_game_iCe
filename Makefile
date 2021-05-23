all: top.bin

sim: tb_vgadriver.ghw

# Analyze vhdl sources
%.o: %.vhd
	ghdl -a $<

tb_vgadriver: contador.o comparador.o dibuja.o vgadriver.o tb_vgadriver.o
	ghdl -e tb_vgadriver

tb_vgadriver.ghw: tb_vgadriver
	./tb_vgadriver --wave=tb_vgadriver.ghw

# Generate simulation executable
#tb_vga_driver.vhd: tb_vga_driver.o
#	ghdl -e tb_vga_driver

# Synthesize
top.json: top.vhd
	yosys -m ghdl -p 'ghdl contador.vhd comparador.vhd dibuja.vhd vgadriver.vhd top.vhd -e top; synth_ice40 -json top.json'

# Place and route
top.asc: top.json
	nextpnr-ice40 --up5k --package sg48 --freq 25 --pcf top.pcf --json top.json --asc top.asc

# Bitstream generation
top.bin: top.asc
	icepack top.asc top.bin

# Configure the FPGA
prog: top.bin
	iceprog top.bin

# Clean:
clean:
	rm -f *.json *.asc *.bin
	rm -f *.o work-obj??.cf
	rm -f tb_vgadriver tb_vgadriver.ghw

.PHONY: all prog clean

