#!/usr/bin/env python

'''
Script that reads two classes, and generates a heatmap of distribution of edges

'''

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

def readInteractions(filename):
	fh=open(filename,'r')
	interactions=[]
	for line in fh:
		words=line.rstrip().split();
		interactions.append((words[0],words[1]));
	return interactions

def readClass(geneList, classList):
	geneFH	= open(geneList,'r')
	classFH	= open(classList,'r')
	genes={}
	glArr=[]
	clArr=[]
	for line in geneFH:
		glArr.append(line.rstrip())
	for line in classFH:
		clArr.append(int(line.rstrip()))
	for i in range(len(glArr)):
		if(clArr[i] == 1):
			genes[glArr[i]] = 1
	geneFH.close()
	classFH.close()
	return genes

def hmp(interactions, geneNames,eFile,lFile):
	egenes=readClass(geneNames, eFile)
	lgenes=readClass(geneNames, lFile)

	#heatmap=[[0,0,0] , [0,0,0] , [0,0,0]]
	heatmap=[0,0,0,0,0,0,0,0,0,0,0]
	#heatmap=[0,0,0,0,0,0,0,0,0]
	#Ordering is	EtoE
	#				EtoL
	#				EtoOther
	#				LtoE
	#				LtoL
	#				LtoOther
	#				OtoE
	#				OtoL
	#				OtoOther

	for i in interactions:
		if (i[0] in egenes):
			if (i[1] in egenes):
				heatmap[0] += 1
			elif (i[1] in lgenes):
				heatmap[1] += 1
			else:
				heatmap[2] += 1
		elif (i[0] in lgenes):
			if (i[1] in egenes):
				heatmap[3] += 1
			elif (i[1] in lgenes):
				heatmap[4] += 1
			else:
				heatmap[5] += 1
		else:
			if (i[1] in egenes):
				heatmap[6] += 1
			elif (i[1] in lgenes):
				heatmap[7] += 1
			else:
				heatmap[8] += 1

	egenes_all={}
	lgenes_all={}
	ogenes_all={}

	for i in interactions:
		if (i[0] in egenes):
			egenes_all[i[0]]=1
		elif (i[0] in lgenes):
			lgenes_all[i[0]]=1
		else:
			ogenes_all[i[0]]=1
		if (i[1] in egenes):
			egenes_all[i[1]]=1
		elif (i[1] in lgenes):
			lgenes_all[i[1]]=1
		else:
			ogenes_all[i[1]]=1
	
	#print(len(egenes_all))
	#print(len(lgenes_all))
	#print(len(ogenes_all))

	#Ordering is	EtoE
	#				EtoL
	#				EtoOther
	#				LtoE
	#				LtoL
	#				LtoOther
	#				OtoE
	#				OtoL
	#				OtoOther
	heatmap[0] = float(heatmap[0]) / (len(egenes_all)*(len(egenes_all)-1))
	heatmap[1] = float(heatmap[1]) / (len(egenes_all)*(len(lgenes_all)))
	heatmap[2] = float(heatmap[2]) / (len(egenes_all)*(len(ogenes_all)))
	heatmap[3] = float(heatmap[3]) / (len(lgenes_all)*(len(egenes_all)))
	heatmap[4] = float(heatmap[4]) / (len(lgenes_all)*(len(lgenes_all)-1))
	heatmap[5] = float(heatmap[5]) / (len(lgenes_all)*(len(ogenes_all)))
	heatmap[6] = float(heatmap[6]) / (len(ogenes_all)*(len(egenes_all)))
	heatmap[7] = float(heatmap[7]) / (len(ogenes_all)*(len(lgenes_all)))
	heatmap[8] = float(heatmap[8]) / (len(ogenes_all)*(len(ogenes_all)-1))
	heatmap[9] = float(0.0)
	heatmap[10] = float(0.007)


	#plt.figure(1)
	#plt.imshow(heatmap,interpolation='None');
	#plt.colorbar();
	#plt.grid(True);
	##plt.xticks([0,1,2],['E','L','O'])
	##plt.yticks([0,1,2],['E','L','O'])
	#plt.xticks([0,1,2],['E','Control','Others'])
	#plt.yticks([0,1,2],['E','Control','Others'])
	#plt.savefig(plotFileName);
	
	return heatmap




	
if(len(sys.argv)>4 and ( len(sys.argv) % 2 ==1 ) ):
	#intFiles , geneNames , el1, cl1 , el2, cl2
	cnt = (len(sys.argv) - 3) / 2 
	interactions=readInteractions(sys.argv[1])
	heatmap = [];
	#main(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4])
	for i in range(cnt):
		htmp = hmp(interactions, sys.argv[2] , sys.argv[2*i + 3] , sys.argv[2*i + 4] )
		heatmap.append(htmp)
	
	for k in heatmap:
		print(k)
	
	#Ordering is	EtoE
	#				EtoL
	#				EtoOther
	#				LtoE
	#				LtoL
	#				LtoOther
	#				OtoE
	#				OtoL
	#				OtoOther
	plt.figure(1)
	plt.imshow(heatmap,interpolation='None');
	plt.colorbar();
	#plt.grid(True);
	#plt.xticks([0,1,2],['E','L','O'])
	#plt.yticks([0,1,2],['E','L','O'])
	#plt.xticks([0,1,2],['E','Control','Others'])
	#plt.yticks([0,1,2],['E','Control','Others'])
	#plt.yticks(range(12),['L0', 'L1','L2','L3','L4','L5','H0', 'H1','H2','H3','H4','H5'])
	#plt.yticks(range(11),['0.0', '0.1','0.2','0.3','0.4','0.5','0.6', '0.7','0.8','0.9','1.0'
	plt.yticks(range(55),[
#				'0.0', '','','','','5   0.5','', '','','','1.0',
			      '', '','','','','10   0.5','', '','','','1.0',
#			      '', '','','','','15   0.5','', '','','','1.0',
			      '', '','','','','20   0.5','', '','','','1.0',
#			      '', '','','','','25   0.5','', '','','','1.0',
			      '', '','','','','30   0.5','', '','','','1.0',
#			      '', '','','','','35   0.5','', '','','','1.0',
			      '', '','','','','40   0.5','', '','','','1.0',
#			      '', '','','','','45   0.5','', '','','','1.0',
			      '', '','','','','50   0.5','', '','','','1.0'
#			      '', '','','','','5   0.5','', '','','','1.0'	      
			      ])
	#plt.xticks(range(9),['EtoE', 'EtoC', 'EtoO', 'CtoE', 'CtoC', 'CtoO', 'OtoE', 'OtoC', 'OtoO'])
	plt.xticks(range(9),['', 'E', '', '', 'C', '', '', 'O', ''])
	#plt.xticks(range(9),['E-E', 'E-C', 'E-O', 'C-E', 'C-C', 'C-O', 'O-E', 'O-C', 'O-O'])
	plt.savefig('hm.png')
	
else:
	print('more than 4 arguments required, interaction file name, gene Name file, plus as many ')



