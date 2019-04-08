import subprocess
import os, time, sys, getopt

def get_available_gpus(card_num=1, wait_secs=30, try_times=20):
	cuda = '-1'
	memmax = 12189
	cnt = 0
	command = 'nvidia-smi dmon -c 1 -s m'
	while cnt < try_times :
		cudas=[]
		handle =subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
		res = handle.communicate()[0]
		if type(res) == bytes:
			lines = bytes.decode(res).split(os.linesep)
		elif type(res) == str:
			lines = res.split(os.linesep)
		else:
			print ('not supported type', type(res))
			return cuda

		lens = len(lines)
		if lens < 6:
			return cuda
		for line in lines:
			if line.startswith('#') or len(line)< 5:
				continue
			cols = line.split()
			if int(cols[1]) < 200:
				cudas.append(cols[0])
		if len(cudas) >= card_num:
			return ','.join(cudas[0:card_num])
		cnt+=1
		time.sleep(wait_secs)
	return cuda

def usage():
	print ("usage: python gpustatus.py [options]")
	print ("options:")
	print ("-n number of GPU cards wanted, default 1 ")
	print ("-w wait seconds when no cards available and try again, default 30")
	print ("-t times try, default 20")
	print ("-h help : print some help information")

def main():
	try:
		opts, args = getopt.getopt(sys.argv[1:], "n:w:t:h")
	except getopt.GetoptError as err:
		print ( str(err) )
		usage()
		sys.exit(2)
	card_num = 1
	wait_secs = 30
	try_times = 20
	for o, a in opts:
		if o == "-n":
			card_num = int(a)
		elif o == "-w":
			wait_secs = int(a)
		elif o == "-t":
			try_times = int(a)
		elif o == "-h":
			usage()
			sys.exit(0)
		else:
			print ("[error]Not recognized option[%s %s]" % (o,a))
			sys.exit(1)
	print ( get_available_gpus(card_num, wait_secs, try_times) )

if __name__ == "__main__":
	main()
