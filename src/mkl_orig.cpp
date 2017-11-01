#include "utils.h"
#include <mkl.h>
#include <time.h>

int main(int argc, char *argv[]) {

  /***********************************************
  *    initialize program's input parameters     *
  ***********************************************/
  double alpha = 1;
  double beta = 1;
  double norm = 0;

  h_vec_t<double> distance_1;
  int num_feat_1 = atoi(argv[2]);
  ReadMatrix(distance_1, argv[1], num_feat_1);

  h_vec_t<double> distance_2;
  int num_feat_2 = atoi(argv[4]);
  ReadMatrix(distance_2, argv[3], num_feat_2);

  int num_iters = 20;
  if (8 == argc)
    num_iters = atoi(argv[7]);

  /**************************************************
  *            construct affinity  matrix            *
  ***************************************************/
  double *distance1 = raw_pointer_cast(distance_1.data());
  double *distance2 = raw_pointer_cast(distance_2.data());

  const clock_t begin_time = clock();

  double *affinity = new double[distance_1.size() * distance_2.size()];
  affinity = AffinityMatrixCtor(distance1, distance2, num_feat_1, num_feat_2);

  std::cout << "affinity runtime: "
            << (clock() - begin_time) / double(CLOCKS_PER_SEC) * 1000
            << std::endl;

  int affinity_size = distance_1.size() * distance_2.size();

  //  std::cout << num_feat_1 * num_feat_2 << " " << num_feat_1 * num_feat_2 <<
  //  std::endl;
  //  for (int i = 0; i < num_feat_1 * num_feat_2 ; ++i) {
  //    for (int j = 0; j < num_feat_1 * num_feat_2 ; ++j) {
  //      std::cout << affinity[i * num_feat_1 * num_feat_2 + j] << "  ";
  //    }
  //    std::cout << std::endl;
  //  }
  //  std::cout << std::endl;

  /************************************************
  *           initialize eigen vector            *
  ************************************************/
  int len_eigen_vec = num_feat_1 * num_feat_2;
  h_vec_t<double> h_eigen_new(len_eigen_vec);
  fill(h_eigen_new.begin(), h_eigen_new.end(), 0);

  h_vec_t<double> h_eigen_old(len_eigen_vec);
  norm = 1.0 / sqrt(len_eigen_vec);
  fill(h_eigen_old.begin(), h_eigen_old.end(), norm);

  /************************************************
  *           computing eigen vector            *
  ************************************************/
  const clock_t begin_time2 = clock();

  for (int iter = 0; iter < num_iters; ++iter) {

    cblas_dgemv(CblasRowMajor, CblasNoTrans, len_eigen_vec, len_eigen_vec, 1,
                affinity, len_eigen_vec, raw_pointer_cast(h_eigen_old.data()),
                1, 0, raw_pointer_cast(h_eigen_new.data()), 1);

    double init = 0;
    norm = std::sqrt(transform_reduce(h_eigen_new.begin(), h_eigen_new.end(),
                                      square(), init, thrust::plus<double>()));

    transform(h_eigen_new.begin(), h_eigen_new.end(), h_eigen_old.begin(),
              division(norm));

    fill(h_eigen_new.begin(), h_eigen_new.end(), 0);
  }

  std::cout << "Eigen runtime: "
            << (clock() - begin_time2) / double(CLOCKS_PER_SEC) * 1000
            << std::endl;

//   std::cout << "eigen values" << std::endl;
//   for (int i = 0; i < h_eigen_old.size(); i++) {
//    std::cout << "eigen new value = " << h_eigen_new[i] << "  ";
//    std::cout << "eigen old value = " << h_eigen_old[i] << std::endl;
//  }

  return (0);
}
