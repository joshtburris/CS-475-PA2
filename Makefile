LIBRARIES=-O3 -std=c99 -fopenmp -I/usr/include/malloc/ -lm
CC=gcc
AR=xiar
OBJS=MMScan.o

all: plain verb int rand verb-rand check DNC DNCP1 DNCP2 DNCP3 EFF EFFPAR OPT

debug: CFLAGS =-DDEBUG -g -Wall -Wextra -std=c99 -I/usr/include/malloc/
debug: all

EXECS=MMScan MMScanDNC MMScanDNCP1 MMScanDNCP2 MMScanDNCP3 MMScanEFF MMScanEFFPAR MMScanOPT
EXEC_FLAGS="" "-DDNC -DPONE" "-DDNC -DPTWO" "-DDNC -DPTHREE" "-DDNC -DEFF" "-DDNC -DEFFPAR" "-DDNC -DOPT"
DFLAGS="" -DVERBOSE -DINTERACTIVE -DRANDOM "-DVERBOSE -DRANDOM" -DCHECKING
EXTENSIONS="" .verb .int .rand .verb-rand .check
loop:
	for i in 1 2 3 4 5 6 7 8 ; do \
		for j in 1 2 3 4 5 6 ; do \
			exec=$(word $$i, $(EXECS)) ; \
			exec_flag=$(word $$i, $(EXEC_FLAGS)) ; \
			dflag=$(word $$j, $(DFLAGS)) ; \
			ext=$(word $$j, $(EXTENSIONS)) ; \
			echo $(CC) MMScan.c -o $(exec).o $(LIBRARIES) -c $(exec_flag) ; \
			$(CC) MMScan.c -o $(exec).o $(LIBRARIES) -c $(exec_flag) ; \
			$(CC) MMScan-wrapper.c -o $(exec)$(ext) $(exec).o $(LIBRARIES) $(exec_flag) $(dflag) ; \
			echo $(CC) MMScan-wrapper.c -o $(exec)$(ext) $(exec).o $(LIBRARIES) $(exec_flag) $(dflag) ; \
		done ; \
	done

test:
	for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ; do \
		export OMP_NUM_THREADS=$$i ; \
		./MMScan 100000 10 >> results.txt ; \
	done

plain: $(OBJS)
	$(CC) MMScan-wrapper.c -o MMScan $(OBJS) $(LIBRARIES) 

verb:
	$(CC) MMScan-wrapper.c -o MMScan.verb $(OBJS) $(LIBRARIES) -DVERBOSE

int: 
	$(CC) MMScan-wrapper.c -o MMScan.int $(OBJS) $(LIBRARIES) -DINTERACTIVE

rand: 
	$(CC) MMScan-wrapper.c -o MMScan.rand $(OBJS) $(LIBRARIES) -DRANDOM

verb-rand: 
	$(CC) MMScan-wrapper.c -o MMScan.verb-rand $(OBJS) $(LIBRARIES) -DVERBOSE -DRANDOM

check: 
	$(CC) MMScan-wrapper.c -o MMScan.check $(OBJS) $(LIBRARIES) -DCHECKING

MMScan.o: MMScan.c
	$(CC) MMScan.c -o MMScan.o $(LIBRARIES) -c

#DNC
MMScanDNC.o: MMScan.c
	$(CC) MMScan.c -o MMScanDNC.o $(LIBRARIES) -c -DDNC
DNC: MMScanDNC.o
	$(CC) MMScan-wrapper.c -o MMScanDNC MMScanDNC.o $(LIBRARIES) -DDNC

#DNCP1
MMScanDNCP1.o: MMScan.c
	$(CC) MMScan.c -o MMScanDNCP1.o $(LIBRARIES) -c -DDNC -DPONE
DNCP1: MMScanDNCP1.o
	$(CC) MMScan-wrapper.c -o MMScanDNCP1 MMScanDNCP1.o  $(LIBRARIES) -DDNC -DPONE
	
#DNCP2
MMScanDNCP2.o: MMScan.c
	$(CC) MMScan.c -o MMScanDNCP2.o $(LIBRARIES) -c -DDNC -DPTWO
DNCP2: MMScanDNCP2.o
	$(CC) MMScan-wrapper.c -o MMScanDNCP2 MMScanDNCP2.o $(LIBRARIES) -DDNC -DPTWO

#DNCP3
MMScanDNCP3.o: MMScan.c
	$(CC) MMScan.c -o MMScanDNCP3.o $(LIBRARIES) -c -DDNC -DPTHREE
DNCP3: MMScanDNCP3.o
	$(CC) MMScan-wrapper.c -o MMScanDNCP3 MMScanDNCP3.o $(LIBRARIES) -DDNC -DPTHREE

#EFF
MMScanEFF.o: MMScan.c
	$(CC) MMScan.c -o MMScanEFF.o $(LIBRARIES) -c -DDNC -DEFF
EFF: MMScanEFF.o
	$(CC) MMScan-wrapper.c -o MMScanEFF MMScanEFF.o $(LIBRARIES) -DDNC -DEFF

#EFFPAR
MMScanEFFPAR.o: MMScan.c
	$(CC) MMScan.c -o MMScanEFFPAR.o $(LIBRARIES) -c -DDNC -DEFFPAR
EFFPAR: MMScanEFFPAR.o
	$(CC) MMScan-wrapper.c -o MMScanEFFPAR MMScanEFFPAR.o $(LIBRARIES) -DDNC -DEFFPAR

#OPT
MMScanOPT.o: MMScan.c
	$(CC) MMScan.c -o MMScanOPT.o $(LIBRARIES) -c -DDNC -DOPT
OPT: MMScanOPT.o
	$(CC) MMScan-wrapper.c -o MMScanOPT MMScanOPT.o $(LIBRARIES) -DDNC -DOPT

clean:
	rm -f *.o MMScan MMScan.verb MMScan.int MMScan.rand MMScan.verb-rand MMScan.check MMScanDNC MMScanDNC.int MMScanDNCP1 MMScanDNCP2 MMScanDNCP3 MMScanEFF MMScanEFFPAR MMScanOPT
