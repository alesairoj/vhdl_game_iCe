all: top.bin

sim: tb_vgadriver.ghw

# Analyze vhdl sources
%.o: %.vhd
	ghdl -a $<

tb_vgadriver: pseudo.o gameover.o gameover_ram.o fondo.o fondo1.o coche.o selector.o cuadrado.o contador.o comparador.o dibuja.o vgadriver.o tb_vgadriver.o ctud.o enemigo.o

	ghdl -e tb_vgadriver

tb_vgadriver.ghw: tb_vgadriver
	./tb_vgadriver --wave=tb_vgadriver.ghw --stop-time=20ms

#tb_ctud: car.o cuadrado.o contador.o comparador.o dibuja.o vgadriver.o tb_vgadriver.o ctud.o tb_ctud.o
#	ghdl -e tb_ctud
#
#tb_ctud.ghw: tb_ctud
#	./tb_ctud --wave=tb_ctud.ghw --stop-time=350ms


# Generate simulation executable
#tb_vga_driver.vhd: tb_vga_driver.o
#	ghdl -e tb_vga_driver

# Synthesize
top.json: top.vhd
	yosys -m ghdl -p 'ghdl pseudo.vhd gameover.vhd gameover_ram.vhd fondo.vhd fondo1.vhd coche.vhd selector.vhd ctud.vhd enemigo.vhd contador.vhd comparador.vhd cuadrado.vhd vgadriver.vhd top.vhd -e top; synth_ice40 -json top.json'

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
	rm -f tb_vgadriver tb_vgadriver.ghw write.txt

.PHONY: all prog clean
