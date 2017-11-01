# Folders
BIN=bin
SRC=src
INC=include

# Compiler
NVCC = nvcc 
NVCCFLAGS = -O3 -std=c++11 -lineinfo 
#NVCCFLAGS = -O3 -std=c++11 -lineinfo -Xcompiler -fopenmp -DTHRUST_DEVICE_SYSTEM=THRUST_DEVICE_SYSTEM_OMP
#-lgomp  
#-DTHRUST_DEVICE_SYSTEM=THRUST_DEVICE_SYSTEM_TBB -ltbb 
#NVCCLIBS =  -lcudart -lcusparse -lcudart -lcublas -lcusparse 
#-DTHRUST_DEVICE_SYSTEM=THRUST_DEVICE_SYSTEM_CUDA
NVCCLIBS =  -lcudart -lcusparse -lcublas -lcusparse  


CXX = icpc
CXXFLAGS = -O3 -std=c++11 
#-D ACCELERATE 
CXXLIBS = -mkl
all: distclean mkdir run_b run_bm run_s run_sm run_blocked_b run_blocked_bm run_blocked_s run_blocked_sm

build_all: distclean mkdir blas blas_m sparse sparse_m blas_blocked blas_m_blocked sparse_blocked sparse_m_blocked

mkd:
	mkdir -p $(BIN)



#mkl, full affinity matrix
original: $(SRC)/original.cpp mkd 
	$(CXX) $(CXXFLAGS) $< -I$(INC) -I/usr/include -o $(BIN)/$@ 

run_orig: original
	$(BIN)/$< Input/xxxs/dist1.text 148 Input/xxxs/dist2.text 134 >> out_xxxs_org.text
#	$(BIN)/$< Input/smsm/dist1.text 379 Input/smsm/dist2.text 302 >> out_smsm_org.text
#	$(BIN)/$< Input/xxsmall/dist1.text 291 Input/xxsmall/dist2.text 703 >> out_xxsmall_org.text
#	$(BIN)/$< Input/small/dist1.text 532 Input/small/dist2.text 553 >> out_small_org.text


#/*********************************** MKL ************************************/
#mkl, full affinity matrix
mkl: $(SRC)/mkl_orig.cpp mkd 
	$(CXX) $(CXXFLAGS) $< -I$(INC) -I/usr/include -o $(BIN)/$@ $(CXXLIBS)

#mkl, full affinity matrix, initially matched
mkl_m: $(SRC)/mkl_matched.cpp mkd 
	$(CXX) $(CXXFLAGS) $< -I$(INC) -I/usr/include -o $(BIN)/$@ $(CXXLIBS)

#mkl, blocked affinity matrix
mkl_blocked: $(SRC)/mkl_blocked.cpp mkd 
	$(CXX) $(CXXFLAGS) $< -I$(INC) -I/usr/include -o $(BIN)/$@ $(CXXLIBS)

#mkl, blocked affinity matrix, initially matched
mkl_m_blocked: $(SRC)/mkl_blocked_match.cpp mkd 
	$(CXX) $(CXXFLAGS) $< -I$(INC) -I/usr/include -o $(BIN)/$@ $(CXXLIBS)

#.............................................................................#
run_m: mkl
	$(BIN)/$< Input/xxxs/dist1.text 148 Input/xxxs/dist2.text 134 >> out_xxxs_morg.text
#	$(BIN)/$< Input/smsm/dist1.text 379 Input/smsm/dist2.text 302 >> out_smsm_morg.text
#	$(BIN)/$< Input/xxsmall/dist1.text 291 Input/xxsmall/dist2.text 703 >> out_xxsmall_morg.text
#	$(BIN)/$< Input/small/dist1.text 532 Input/small/dist2.text 553 >> out_small_morg.text

run_mm: mkl_m
#	$(BIN)/$< Input/xxxs/dist1.text 148 Input/xxxs/dist2.text 134 Input/xxxs/matches.text 1081 >> out_xxxs_mmat.text
#	$(BIN)/$< Input/smsm/dist1.text 379 Input/smsm/dist2.text 302 Input/smsm/matches.text 3071 >> out_smsm_mmat.text
#	$(BIN)/$< Input/xxsmall/dist1.text 291 Input/xxsmall/dist2.text 703 Input/xxsmall/matches.text 2455 >> out_xxsmall_mmat.text
#	$(BIN)/$< Input/small/dist1.text 532 Input/small/dist2.text 553 Input/small/matches.text 3000 >> out_small_mmat.text
#	$(BIN)/$< Input/medium/dist1.text 995 Input/medium/dist2.text 930 Input/medium/matches.text 3000 >> out_medium_mmat.text
#	$(BIN)/$< Input/smlg/dist1.text 940 Input/smlg/dist2.text 2124 Input/smlg/matches.text 4500 >> out_smlg_mmat.text
#	$(BIN)/$< Input/large/dist1.text 1394 Input/large/dist2.text 1377 Input/large/matches.text 4000 >> out_large_mmat.text
#	$(BIN)/$< Input/xlarge/dist1.text 2064 Input/xlarge/dist2.text 2064 Input/large/matches.text 4500 >> out_xlarge_mmat.text
#	$(BIN)/$< Input/xxl/dist1.text 3299 Input/xxl/dist2.text 3269 Input/large/matches.text 5000 >> out_xxl_mmat.text

run_blocked_m: mkl_blocked
#	$(BIN)/$< Input/xxxs/dist1_bl.text 148 Input/xxxs/dist2.text 134 >> out_xxxs_mbl.text
#	$(BIN)/$< Input/smsm/dist1_bl.text 374 Input/smsm/dist2.text 302 >> out_smsm_mbl.text
#	$(BIN)/$< Input/xxsmall/dist1_bl.text 288 Input/xxsmall/dist2.text 703 >> out_xxsmall_mbl.text
#	$(BIN)/$< Input/small/dist1_bl.text 530 Input/small/dist2.text 553 >> out_small_mbl.text
#	$(BIN)/$< Input/medium/dist1_bl.text 995 Input/medium/dist2.text 930 >> out_medium_mbl.text
	#$(BIN)/$< Input/smlg/dist1_bl.text 940 Input/smlg/dist2.text 2124 >> out_smlg_mbl.text
#	$(BIN)/$< Input/large/dist1_bl.text 1394 Input/large/dist2.text 1377 >> out_large_mbl.text
#	$(BIN)/$< Input/xlarge/dist1_bl.text 2064 Input/xlarge/dist2.text 2064 >> out_xlarge_mbl.text
#	$(BIN)/$< Input/xxl/dist1_bl.text 3299 Input/xxl/dist2.text 3269 >> out_xxl_mbl.text

run_blocked_mm: mkl_m_blocked
	#$(BIN)/$< Input/xxxs/dist1_blm.text 146 Input/xxxs/dist2_blm.text 116 >> out_xxxs_mblm.text
	#$(BIN)/$< Input/smsm/dist1_blm.text 374 Input/smsm/dist2_blm.text 276 >> out_smsm_mblm.text
	#$(BIN)/$< Input/xxsmall/dist1_blm.text 280 Input/xxsmall/dist2_blm.text 413 >> out_xxsmall_mblm.text
	#$(BIN)/$< Input/small/dist1_blm.text 530 Input/small/dist2_blm.text 503 >> out_small_mblm.text
#	$(BIN)/$< Input/medium/dist1_blm.text 746 Input/medium/dist2_blm.text 696 >> out_medium_mblm.text
#	$(BIN)/$< Input/smlg/dist1_blm.text 934 Input/smlg/dist2_blm.text 1374 >> out_smlg_mblm.text
	$(BIN)/$< Input/large/dist1_blm.text 1219 Input/large/dist2_blm.text 1000 >> out_large_mblm.text
	#$(BIN)/$< Input/xlarge/dist1_blm.text 1550 Input/xlarge/dist2_blm.text 1317 >> out_xlarge_mblm.text
	#$(BIN)/$< Input/xxl/dist1_blm.text 1330 Input/xxl/dist2_blm.text 1215 >> out_xxl_mblm.text


#/*********************************** MKL-COO ************************************/
#mkl_coo, sparse affinity matrix
mkl_csr: $(SRC)/mkl_orig_csr.cpp mkd 
	$(CXX) $(CXXFLAGS) $< -I$(INC) -I/usr/include -o $(BIN)/$@ $(CXXLIBS)

#mkl, full affinity matrix, initially matched
mkl_m_csr: $(SRC)/mkl_matched_csr.cpp mkd 
	$(CXX) $(CXXFLAGS) $< -I$(INC) -I/usr/include -o $(BIN)/$@ $(CXXLIBS)

mkl_bl_csr: $(SRC)/mkl_blocked_csr.cpp mkd 
	$(CXX) $(CXXFLAGS) $< -I$(INC) -I/usr/include -o $(BIN)/$@ $(CXXLIBS)

mkl_blm_csr: $(SRC)/mkl_blocked_match_csr.cpp mkd 
	$(CXX) $(CXXFLAGS) $< -I$(INC) -I/usr/include -o $(BIN)/$@ $(CXXLIBS)

#.............................................................................#
run_mc: mkl_csr
	$(BIN)/$< Input/xxxs/dist1.text 148 Input/xxxs/dist2.text 134 >> out_xxxs_csrmorg.text
	#$(BIN)/$< Input/smsm/dist1.text 379 Input/smsm/dist2.text 302 >> out_smsm_csrmorg.text
#	$(BIN)/$< Input/xxsmall/dist1.text 291 Input/xxsmall/dist2.text 703 >> out_xxsmall_csrmorg.text
#	$(BIN)/$< Input/small/dist1.text 532 Input/small/dist2.text 553 >> out_small_csrmorg.text
	

run_mmc: mkl_m_csr
#	$(BIN)/$< Input/xxxs/dist1.text 148 Input/xxxs/dist2.text 134 Input/xxxs/matches.text 1081 >> out_xxxs_scrmat.text
#	$(BIN)/$< Input/smsm/dist1.text 379 Input/smsm/dist2.text 302 Input/smsm/matches.text 3071 >> out_smsm_scrmat.text
#	$(BIN)/$< Input/xxsmall/dist1.text 291 Input/xxsmall/dist2.text 703 Input/xxsmall/matches.text 2455 >> out_xxsmall_scrmat.text
#	$(BIN)/$< Input/small/dist1.text 532 Input/small/dist2.text 553 Input/small/matches.text 3000 >> out_small_scrmat.text
#	$(BIN)/$< Input/medium/dist1.text 995 Input/medium/dist2.text 930 Input/medium/matches.text 3000 >> out_medium_scrmat.text
#	$(BIN)/$< Input/smlg/dist1.text 940 Input/smlg/dist2.text 2124 Input/smlg/matches.text 4500 >> out_smlg_scrmat.text
#	$(BIN)/$< Input/large/dist1.text 1394 Input/large/dist2.text 1377 Input/large/matches.text 4000 >> out_large_scrmat.text
#	$(BIN)/$< Input/xlarge/dist1.text 2064 Input/xlarge/dist2.text 2064 Input/large/matches.text 4500 >> out_xlarge_scrmat.text
#	$(BIN)/$< Input/xxl/dist1.text 3299 Input/xxl/dist2.text 3269 Input/large/matches.text 5000 >> out_xxl_scrmat.text
	

run_bl_mc: mkl_bl_csr
#	$(BIN)/$< Input/xxxs/dist1_bl.text 148 Input/xxxs/dist2.text 134 >> out_xxxs_scrbl.text
#	$(BIN)/$< Input/smsm/dist1_bl.text 374 Input/smsm/dist2.text 302 >> out_smsm_scrbl.text
#	$(BIN)/$< Input/xxsmall/dist1_bl.text 288 Input/xxsmall/dist2.text 703 >> out_xxsmall_scrbl.text
#	$(BIN)/$< Input/small/dist1_bl.text 530 Input/small/dist2.text 553 >> out_small_scrbl.text
#	$(BIN)/$< Input/medium/dist1_bl.text 995 Input/medium/dist2.text 930 >> out_medium_scrbl.text
	#$(BIN)/$< Input/smlg/dist1_bl.text 940 Input/smlg/dist2.text 2124 >> out_smlg_scrbl.text
#	$(BIN)/$< Input/large/dist1_bl.text 1394 Input/large/dist2.text 1377 >> out_large_scrbl.text
#	$(BIN)/$< Input/xlarge/dist1_bl.text 2064 Input/xlarge/dist2.text 2064 >> out_xlarge_scrbl.text
#	$(BIN)/$< Input/xxl/dist1_bl.text 3299 Input/xxl/dist2.text 3269 >> out_xxl_scrbl.text

run_bl_mmc: mkl_blm_csr
 #   $(BIN)/$< Input/xxxs/dist1_blm.text 146 Input/xxxs/dist2_blm.text 116 >> out_xxxs_scrblm.text
#	$(BIN)/$< Input/smsm/dist1_blm.text 374 Input/smsm/dist2_blm.text 276 >> out_smsm_scrblm.text
#	$(BIN)/$< Input/xxsmall/dist1_blm.text 280 Input/xxsmall/dist2_blm.text 413 >> out_xxsmall_scrblm.text
#	$(BIN)/$< Input/small/dist1_blm.text 530 Input/small/dist2_blm.text 503 >> out_small_scrblm.text
#	$(BIN)/$< Input/medium/dist1_blm.text 746 Input/medium/dist2_blm.text 696 >> out_medium_scrblm.text
#	$(BIN)/$< Input/smlg/dist1_blm.text 934 Input/smlg/dist2_blm.text 1374 >> out_smlg_scrblm.text
	#$(BIN)/$< Input/large/dist1_blm.text 1219 Input/large/dist2_blm.text 1000 >> out_large_scrblm.text
#	$(BIN)/$< Input/xlarge/dist1_blm.text 1550 Input/xlarge/dist2_blm.text 1317 >> out_xlarge_scrblm.text
#	$(BIN)/$< Input/xxl/dist1_blm.text 1330 Input/xxl/dist2_blm.text 1215 >> out_xxl_scrblm.text
	

	




#/****************************** cuBlas **************************************/
#cuBLAS, full affinity matrix
blas: $(SRC)/cuBLAS.cu mkd 
	$(NVCC) $(NVCCFLAGS) $< -I$(INC) -o $(BIN)/$@ $(NVCCLIBS) 

#cuBLAS, full affinity matrix, initially matched
blas_m: $(SRC)/cuBLAS_matched.cu mkd 
	$(NVCC) $(NVCCFLAGS) $< -I$(INC) -o $(BIN)/$@ $(NVCCLIBS) 

#cuBLAS, blocked affinity matrix
blas_blocked: $(SRC)/cuBLAS_blocked.cu mkd 
	$(NVCC) $(NVCCFLAGS) $< -I$(INC) -o $(BIN)/$@ $(NVCCLIBS) 

#cuBLAS, blocked affinity matrix, initially matched
blas_m_blocked: $(SRC)/cuBLAS_blocked_matched.cu mkd 
	$(NVCC) $(NVCCFLAGS) $< -I$(INC) -o $(BIN)/$@ $(NVCCLIBS) 

#.............................................................................#
run_b: blas
	$(BIN)/$< Input/xxxs/dist1.text 148 Input/xxxs/dist2.text 134 >> out_xxxs_borg.text
	$(BIN)/$< Input/smsm/dist1.text 379 Input/smsm/dist2.text 302 >> out_smsm_borg.text
	$(BIN)/$< Input/xxsmall/dist1.text 291 Input/xxsmall/dist2.text 703 >> out_xxsmall_borg.text
	$(BIN)/$< Input/small/dist1.text 532 Input/small/dist2.text 553 >> out_small_borg.text

run_bm: blas_m
#	$(BIN)/$< Input/xxxs/dist1.text 148 Input/xxxs/dist2.text 134 Input/xxxs/matches.text 1081 >> out_xxxs_bmat.text
#	$(BIN)/$< Input/smsm/dist1.text 379 Input/smsm/dist2.text 302 Input/smsm/matches.text 3071 >> out_smsm_bmat.text
#	$(BIN)/$< Input/xxsmall/dist1.text 291 Input/xxsmall/dist2.text 703 Input/xxsmall/matches.text 2455 >> out_xxsmall_bmat.text
#	$(BIN)/$< Input/small/dist1.text 532 Input/small/dist2.text 553 Input/small/matches.text 3000 >> out_small_bmat.text
#	$(BIN)/$< Input/medium/dist1.text 995 Input/medium/dist2.text 930 Input/medium/matches.text 3000 >> out_medium_bmat.text
#	$(BIN)/$< Input/smlg/dist1.text 940 Input/smlg/dist2.text 2124 Input/smlg/matches.text 4500 >> out_smlg_bmat.text
#	$(BIN)/$< Input/large/dist1.text 1394 Input/large/dist2.text 1377 Input/large/matches.text 4000 >> out_large_bmat.text
#	$(BIN)/$< Input/xlarge/dist1.text 2064 Input/xlarge/dist2.text 2064 Input/large/matches.text 4500 >> out_xlarge_bmat.text
#	$(BIN)/$< Input/xxl/dist1.text 3299 Input/xxl/dist2.text 3269 Input/large/matches.text 5000 >> out_xxl_bmat.text

run_blocked_b: blas_blocked
#	$(BIN)/$< Input/xxxs/dist1_bl.text 148 Input/xxxs/dist2.text 134 >> out_xxxs_bbl.text
#	$(BIN)/$< Input/smsm/dist1_bl.text 374 Input/smsm/dist2.text 302 >> out_smsm_bbl.text
#	$(BIN)/$< Input/xxsmall/dist1_bl.text 288 Input/xxsmall/dist2.text 703 >> out_xxsmall_bbl.text
#	$(BIN)/$< Input/small/dist1_bl.text 530 Input/small/dist2.text 553 >> out_small_bbl.text
#	$(BIN)/$< Input/medium/dist1_bl.text 995 Input/medium/dist2.text 930 >> out_medium_bbl.text
#	$(BIN)/$< Input/smlg/dist1_bl.text 940 Input/smlg/dist2.text 2124 >> out_smlg_bbl.text
#	$(BIN)/$< Input/large/dist1_bl.text 1394 Input/large/dist2.text 1377 >> out_large_bbl.text
#	$(BIN)/$< Input/xlarge/dist1_bl.text 2064 Input/xlarge/dist2.text 2064 >> out_xlarge_bbl.text
#	$(BIN)/$< Input/xxl/dist1_bl.text 3299 Input/xxl/dist2.text 3269 >> out_xxl_bbl.text

run_blocked_bm: blas_m_blocked
	$(BIN)/$< Input/xxxs/dist1_blm.text 146 Input/xxxs/dist2_blm.text 116 >> out_xxxs_bblm.text
	#$(BIN)/$< Input/smsm/dist1_blm.text 374 Input/smsm/dist2_blm.text 276 >> out_smsm_bblm.text
	#$(BIN)/$< Input/xxsmall/dist1_blm.text 280 Input/xxsmall/dist2_blm.text 413 >> out_xxsmall_bblm.text
	#$(BIN)/$< Input/small/dist1_blm.text 530 Input/small/dist2_blm.text 503 >> out_small_bblm.text
	#$(BIN)/$< Input/medium/dist1_blm.text 746 Input/medium/dist2_blm.text 696 >> out_medium_bblm.text
	#$(BIN)/$< Input/smlg/dist1_blm.text 934 Input/smlg/dist2_blm.text 1374 >> out_smlg_bblm.text
	#$(BIN)/$< Input/large/dist1_blm.text 1219 Input/large/dist2_blm.text 1000 >> out_large_bblm.text
	#$(BIN)/$< Input/xlarge/dist1_blm.text 1550 Input/xlarge/dist2_blm.text 1317 >> out_xlarge_bblm.text
	#$(BIN)/$< Input/xxl/dist1_blm.text 1330 Input/xxl/dist2_blm.text 1215 >> out_xxl_bblm.text



#/********************** cuSparse COO affinity matrix ************************/
#cuSparse COO, original affinity matrix
sparse_coo: $(SRC)/cuSparse_coo_orig.cu mkd 
	$(NVCC) $(NVCCFLAGS) $(NVCCLIBS) $< -I$(INC) -o $(BIN)/$@

#cuSparse COO, initially matches affinity matrix
sparse_coo_m: $(SRC)/cuSparse_coo_match.cu mkd 
	$(NVCC) $(NVCCFLAGS) $(NVCCLIBS) $< -I$(INC) -o $(BIN)/$@

#cuSparse COO, blocked affinity matrix
sparse_coo_blocked: $(SRC)/cuSparse_coo_blocked.cu mkd 
	$(NVCC) $(NVCCFLAGS) $< -I$(INC) -o $(BIN)/$@ $(NVCCLIBS)  

#cuSparse COO, blocked affinity matrix, initially matched
sparse_coo_m_blocked: $(SRC)/cuSparse_coo_blocked_match.cu mkd 
	$(NVCC) $(NVCCFLAGS) $< -I$(INC) -o $(BIN)/$@ $(NVCCLIBS)  

#cuSparse COO, blocked affinity matrix, initially matched
sparse_thrust_coo_m_blocked: $(SRC)/cuSparse_thrust_coo_block_match.cu mkd 
	$(NVCC) $(NVCCFLAGS) $< -I$(INC) -o $(BIN)/$@ $(NVCCLIBS)  

#.............................................................................#
run_cs: sparse_coo
	$(BIN)/$< Input/xxxs/dist1.text 148 Input/xxxs/dist2.text 134 >> out_xxxs_spcoorg.text
	$(BIN)/$< Input/smsm/dist1.text 379 Input/smsm/dist2.text 302 >> out_smsm_spcoorg.text
	$(BIN)/$< Input/xxsmall/dist1.text 291 Input/xxsmall/dist2.text 703 >> out_xxsmall_spcoorg.text
	$(BIN)/$< Input/small/dist1.text 532 Input/small/dist2.text 553 >> out_small_spcoorg.text

run_csm: sparse_coo_m
	$(BIN)/$< Input/xxxs/dist1.text 148 Input/xxxs/dist2.text 134 Input/xxxs/matches.text 1081 >> out_xxxs_spcomat.text
	$(BIN)/$< Input/smsm/dist1.text 379 Input/smsm/dist2.text 302 Input/smsm/matches.text 3071 >> out_smsm_spcomat.text
	$(BIN)/$< Input/xxsmall/dist1.text 291 Input/xxsmall/dist2.text 703 Input/xxsmall/matches.text 2455 >> out_xxsmall_spcomat.text
	$(BIN)/$< Input/small/dist1.text 532 Input/small/dist2.text 553 Input/small/matches.text 3000 >> out_small_spcomat.text
	$(BIN)/$< Input/medium/dist1.text 995 Input/medium/dist2.text 930 Input/medium/matches.text 3000 >> out_medium_spcomat.text
	$(BIN)/$< Input/smlg/dist1.text 940 Input/smlg/dist2.text 2124 Input/smlg/matches.text 4500 >> out_smlg_spcomat.text
	$(BIN)/$< Input/large/dist1.text 1394 Input/large/dist2.text 1377 Input/large/matches.text 4000 >> out_large_spcomat.text
	$(BIN)/$< Input/xlarge/dist1.text 2064 Input/xlarge/dist2.text 2064 Input/large/matches.text 4500 >> out_xlarge_spcomat.text
	$(BIN)/$< Input/xxl/dist1.text 3299 Input/xxl/dist2.text 3269 Input/large/matches.text 5000 >> out_xxl_spcomat.text

run_blocked_cs: sparse_coo_blocked
	#$(BIN)/$< Input/xxxs/dist1_bl.text 148 Input/xxxs/dist2.text 134 >> out_xxxs_spcobl.text
	#$(BIN)/$< Input/smsm/dist1_bl.text 374 Input/smsm/dist2.text 302 >> out_smsm_spcobl.text
	#$(BIN)/$< Input/xxsmall/dist1_bl.text 288 Input/xxsmall/dist2.text 703 >> out_xxsmall_spcobl.text
	#$(BIN)/$< Input/small/dist1_bl.text 530 Input/small/dist2.text 553 >> out_small_spcobl.text
	#$(BIN)/$< Input/medium/dist1_bl.text 995 Input/medium/dist2.text 930 >> out_medium_spcobl.text
	#$(BIN)/$< Input/smlg/dist1_bl.text 940 Input/smlg/dist2.text 2124 >> out_smlg_spcobl.text
	$(BIN)/$< Input/large/dist1_bl.text 1394 Input/large/dist2.text 1377 >> out_large_spcobl.text
	#$(BIN)/$< Input/xlarge/dist1_bl.text 2064 Input/xlarge/dist2.text 2064 >> out_xlarge_spcobl.text
	#$(BIN)/$< Input/xxl/dist1_bl.text 3299 Input/xxl/dist2.text 3269 >> out_xxl_spcobl.text

run_blocked_csm: sparse_coo_m_blocked
	#$(BIN)/$< Input/xxxs/dist1_blm.text 146 Input/xxxs/dist2_blm.text 116 >> out_xxxs_spcoblm.text
	#$(BIN)/$< Input/smsm/dist1_blm.text 374 Input/smsm/dist2_blm.text 276 >> out_smsm_spcoblm.text
	#$(BIN)/$< Input/xxsmall/dist1_blm.text 280 Input/xxsmall/dist2_blm.text 413 >> out_xxsmall_spcoblm.text
	#$(BIN)/$< Input/small/dist1_blm.text 530 Input/small/dist2_blm.text 503 >> out_small_spcoblm.text
	#$(BIN)/$< Input/medium/dist1_blm.text 746 Input/medium/dist2_blm.text 696 >> out_medium_spcoblm.text
	#$(BIN)/$< Input/smlg/dist1_blm.text 934 Input/smlg/dist2_blm.text 1374 >> out_smlg_spcoblm.text
	$(BIN)/$< Input/large/dist1_blm.text 1219 Input/large/dist2_blm.text 1000 >> out_large_spcoblm.text
	#$(BIN)/$< Input/xlarge/dist1_blm.text 1550 Input/xlarge/dist2_blm.text 1317 >> out_xlarge_spcoblm.text
	#$(BIN)/$< Input/xxl/dist1_blm.text 1330 Input/xxl/dist2_blm.text 1215 >> out_xxl_spcoblm.text

run_blocked_tcsm: sparse_thrust_coo_m_blocked



#/******************** cuSparse CSR affinity matrix  *******************/
#cuSparse CSR, initially matches affinity matrix
sparse_m: $(SRC)/cuSparse_matched.cu mkd 
	$(NVCC) $(NVCCFLAGS) $(NVCCLIBS) $< -I$(INC) -o $(BIN)/$@

#cuSparse CSR, blocked affinity matrix
sparse_blocked: $(SRC)/cuSparse_blocked.cu mkd 
	$(NVCC) $(NVCCFLAGS) $< -I$(INC) -o $(BIN)/$@ $(NVCCLIBS)  

#cuSparse CSR, blocked affinity matrix, initially matched
sparse_m_blocked: $(SRC)/cuSparse_blocked_matched.cu mkd 
	$(NVCC) $(NVCCFLAGS) $< -I$(INC) -o $(BIN)/$@ $(NVCCLIBS) 

#.............................................................................#
run_sm: sparse_m
	#$(BIN)/$< Input/xxxs/dist1.text 148 Input/xxxs/dist2.text 134 Input/xxxs/matches.text 1081 >> out_xxxs_spmat.text
	#$(BIN)/$< Input/smsm/dist1.text 379 Input/smsm/dist2.text 302 Input/smsm/matches.text 3071 >> out_smsm_spmat.text
	#$(BIN)/$< Input/xxsmall/dist1.text 291 Input/xxsmall/dist2.text 703 Input/xxsmall/matches.text 2455 >> out_xxsmall_spmat.text
	#$(BIN)/$< Input/small/dist1.text 532 Input/small/dist2.text 553 Input/small/matches.text 3000 >> out_small_spmat.text
	#$(BIN)/$< Input/medium/dist1.text 995 Input/medium/dist2.text 930 Input/medium/matches.text 3000 >> out_medium_spmat.text
	#$(BIN)/$< Input/smlg/dist1.text 940 Input/smlg/dist2.text 2124 Input/smlg/matches.text 4500 >> out_smlg_spmat.text
	#$(BIN)/$< Input/large/dist1.text 1394 Input/large/dist2.text 1377 Input/large/matches.text 4000 >> out_large_spmat.text
	#$(BIN)/$< Input/xlarge/dist1.text 2064 Input/xlarge/dist2.text 2064 Input/large/matches.text 4500 >> out_xlarge_spmat.text
	#$(BIN)/$< Input/xxl/dist1.text 3299 Input/xxl/dist2.text 3269 Input/large/matches.text 5000 >> out_xxl_spmat.text

run_blocked_s: sparse_blocked
	#$(BIN)/$< Input/xxxs/dist1_bl.text 148 Input/xxxs/dist2.text 134 >> out_xxxs_spbl.text
#	$(BIN)/$< Input/smsm/dist1_bl.text 374 Input/smsm/dist2.text 302 >> out_smsm_spbl.text
	#$(BIN)/$< Input/xxsmall/dist1_bl.text 288 Input/xxsmall/dist2.text 703 >> out_xxsmall_spbl.text
	#$(BIN)/$< Input/small/dist1_bl.text 530 Input/small/dist2.text 553 >> out_small_spbl.text
#	$(BIN)/$< Input/medium/dist1_bl.text 995 Input/medium/dist2.text 930 >> out_medium_spbl.text
#	$(BIN)/$< Input/smlg/dist1_bl.text 940 Input/smlg/dist2.text 2124 >> out_smlg_spbl.text
	$(BIN)/$< Input/large/dist1_bl.text 1394 Input/large/dist2.text 1377 >> out_large_spbl.text
	#$(BIN)/$< Input/xlarge/dist1_bl.text 2064 Input/xlarge/dist2.text 2064 >> out_xlarge_spbl.text
	#$(BIN)/$< Input/xxl/dist1_bl.text 3299 Input/xxl/dist2.text 3269 >> out_xxl_spbl.text

run_blocked_sm: sparse_m_blocked
#	$(BIN)/$< Input/xxxs/dist1_blm.text 146 Input/xxxs/dist2_blm.text 116 >> out_xxxs_spblm.text
#	$(BIN)/$< Input/smsm/dist1_blm.text 374 Input/smsm/dist2_blm.text 276 >> out_smsm_spblm.text
#	$(BIN)/$< Input/xxsmall/dist1_blm.text 280 Input/xxsmall/dist2_blm.text 413 >> out_xxsmall_spblm.text
#	$(BIN)/$< Input/small/dist1_blm.text 530 Input/small/dist2_blm.text 503 >> out_small_spblm.text
#	$(BIN)/$< Input/medium/dist1_blm.text 746 Input/medium/dist2_blm.text 696 >> out_medium_spblm.text
#	$(BIN)/$< Input/smlg/dist1_blm.text 934 Input/smlg/dist2_blm.text 1374 >> out_smlg_spblm.text
	$(BIN)/$< Input/large/dist1_blm.text 1219 Input/large/dist2_blm.text 1000 >> out_large_spblm.text
#	$(BIN)/$< Input/xlarge/dist1_blm.text 1550 Input/xlarge/dist2_blm.text 1317 >> out_xlarge_spblm.text
#	$(BIN)/$< Input/xxl/dist1_blm.text 1330 Input/xxl/dist2_blm.text 1215 >> out_xxl_spblm.text






### with initial matching
#$(BIN)/$< Input/ranch1_appr 62 Input/ranch2 66 Input/ranch_matches 621
#$(BIN)/$< Input/bike1_appr 292 Input/bike2 703 Input/bike_matches 2000  
#$(BIN)/$< Input/building1_appr 683 Input/building2 1496 Input/building_matches 2000

### without initial matching
#$(BIN)/$< Input/ranch1_appr 62 Input/ranch2 66
#$(BIN)/$< Input/bike1_appr 292 Input/bike2 703
#$(BIN)/$< Input/building1_appr 683 Input/building2 1496

clean:
	rm -if $(BIN)/*

distclean:
	rm -irf $(BIN)
