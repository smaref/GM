#include "cublas_v2.h"
#include <algorithm>
#include <cuda_runtime.h>

#include "utils.h"
#include <time.h>  

int main(int argc, char *argv[]) {

  /***********************************************
  *    initialize program's input parameters     *
  ***********************************************/
  double alpha = 1;
  double beta = 0;
  double norm = 0;

  h_vec_t<double> h_distance_1;
  int num_feat_1 = atoi(argv[2]);
  ReadMatrix(h_distance_1, argv[1], num_feat_1);

#ifdef ACCELERATE
  std::cout << "CUDA" << std::endl;
  d_vec_t<double> d_distance_1 = h_distance_1;
#endif

  h_vec_t<double> h_distance_2;
  int num_feat_2 = atoi(argv[4]);
  ReadMatrix(h_distance_2, argv[3], num_feat_2);

#ifdef ACCELERATE
  d_vec_t<double> d_distance_2 = h_distance_2;
#endif

  int num_iters = 20;
  if (8 == argc)
    num_iters = atoi(argv[7]);
  
  /**************************************************
  *            construct affinity  matrix            *
  ***************************************************/

  double *distance_ptr_1 = raw_pointer_cast(h_distance_1.data());
  double *distance_ptr_2 = raw_pointer_cast(h_distance_2.data());


  const clock_t begin_time = clock();
  
  double *affinity = new double[h_distance_1.size() * h_distance_2.size()];
  affinity = AffinityMatrixCtor(distance_ptr_1, distance_ptr_2, num_feat_1,
                                num_feat_2);
  
  std::cout << "affinity runtime: "
            << (clock() - begin_time) / double(CLOCKS_PER_SEC) * 1000 << std::endl;

  d_vec_t<double> d_affinity(
      affinity, affinity + h_distance_1.size() * h_distance_2.size());
  
  
  unsigned affinity_size = h_distance_1.size() * h_distance_2.size();

  //std::cout << "affinity" << std::endl;
//  for (int i = 0; i < num_feat_1 * num_feat_2; ++i) {
//    for (int j = 0; j < num_feat_1 * num_feat_2; ++j) {
//        std::cout << affinity[i * num_feat_1 * num_feat_2 + j] << "  ";
//    }
//    std::cout << std::endl;
//  }
//  std::cout << std::endl;

  /************************************************
  *           initialize eigen vectors            *
  ************************************************/
  int len_eigen_vec = num_feat_1 * num_feat_2;
  d_vec_t<double> d_eigen_new(len_eigen_vec);
  fill(d_eigen_new.begin(), d_eigen_new.end(), 0);

  d_vec_t<double> d_eigen_old(len_eigen_vec);
  norm = 1.0 / sqrt(len_eigen_vec);
  fill(d_eigen_old.begin(), d_eigen_old.end(), norm);

  cublasHandle_t handle;
  cublasCreate(&handle);

  
  /************************************************
  *           initialize eigen vectors            *
  ************************************************/
  const clock_t begin_time2 = clock();
  
  for (int iter = 0; iter < num_iters; ++iter) {
    cublasDgemv(handle, CUBLAS_OP_N, num_feat_1 * num_feat_2,
                num_feat_1 * num_feat_2, &alpha,
                raw_pointer_cast(d_affinity.data()), num_feat_1 * num_feat_2,
                raw_pointer_cast(d_eigen_old.data()), 1, &beta,
                raw_pointer_cast(d_eigen_new.data()), 1);

    double init = 0;
    norm = std::sqrt(transform_reduce(d_eigen_new.begin(), d_eigen_new.end(),
                                      square(), init, thrust::plus<double>()));

    transform(d_eigen_new.begin(), d_eigen_new.end(), d_eigen_old.begin(),
              division(norm));

    fill(d_eigen_new.begin(), d_eigen_new.end(), 0);
  }

  std::cout << "Eigen runtime: "
            << (clock() - begin_time2) / double(CLOCKS_PER_SEC) * 1000 << std::endl;
  
  //std::cout << "eigen values" << std::endl;
  //for (int i = 0; i < d_eigen_old.size(); i++) {
  //  std::cout << "eigen new value = " << d_eigen_new[i] << "  ";
  //  std::cout << "eigen old value = " << d_eigen_old[i] << std::endl;
  //}

  cublasDestroy(handle);

  return (0);
}
