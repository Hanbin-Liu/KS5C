#include "mex.h" /* Always include this */
#include "matrix.h"
#include <stdlib.h>
#include <string.h>

#include <stdint.h>

void do_iter(double *w, /* output */
             const double *K, const mwSize Krows, const mwSize Kcols, 
             const int i, const double *w_orig, const int64_t *rand_idx, 
             mwSize num_rand_idx, const double *shrinkfactor, 
             const double threshold, mwSize num_S,const int64_t *S,const double *KI) /* input */
{
 
  memcpy((void *)w, (const void *)w_orig, (size_t)Kcols * sizeof(double));
  
  mwSize j_iter, j, k,u,v;
  double wjnew, temp;

  for (j_iter = 0; j_iter < num_rand_idx; j_iter++) {
    j = rand_idx[j_iter] - 1;

    wjnew = 0.0;
    temp = 0.0;
    
    for (k=0; k < Krows; k++) {
        temp += w[k] * K[k+Krows*j];         
    }
    wjnew = KI[j]- temp + w[j]*K[j+Krows*j];

    /* soft thresholding */
    if (wjnew >= 0)
      wjnew = (wjnew - threshold > 0) ? (wjnew - threshold) / shrinkfactor[j] : 0;
    else
      wjnew = (-wjnew - threshold > 0) ? (wjnew + threshold) / shrinkfactor[j] : 0;
      
    w[j] = wjnew;
  }
}


void mexFunction(int nlhs, mxArray *plhs[],       /* Output variables */
                 int nrhs, const mxArray *prhs[]) /* Input variables */
{

  if (nlhs > 4)
  {
    mexErrMsgTxt("Too many outputs");
  }
  if (nrhs != 8)
  {
    mexErrMsgTxt("Need exactly 8 inputs");
  }
  

  double *K;
  mwSize Krows,Kcols;
  
  K = mxGetPr(prhs[0]);
  Krows = mxGetM(prhs[0]);
  Kcols = mxGetN(prhs[0]);
  if( !mxIsDouble(prhs[0]) || mxIsSparse(prhs[0]) || mxIsComplex(prhs[0]) ||
      mxGetNumberOfDimensions(prhs[0])!=2 ) {
    mexErrMsgTxt("K(1st argument) must be real double full matrix");
  }  


  int i;
  double *w;
  i = mxGetScalar(prhs[1]);
  

  w = mxGetPr(prhs[2]);
  if (!mxIsDouble(prhs[2]) || mxIsSparse(prhs[2]) || mxIsComplex(prhs[2]) || mxGetN(prhs[2]) != 1)
  {
    mexErrMsgTxt("w (3rd argument) must be real double column vector");
  }
  if (Kcols != mxGetM(prhs[2]))
  {
    mexPrintf("num col of K=%d and dim of w=%d ", Kcols, mxGetM(prhs[2]));
    mexErrMsgTxt("Inner dimensions of matrix multiply do not match. (num col of K and dim of w ");
  }

  
  int64_t *rand_idx;
  mwSize num_rand_idx;
  double *shrinkfactor;
  double threshold;
  rand_idx = (int64_t *)mxGetData(prhs[3]);
  if (!mxIsInt64(prhs[3]) || mxIsSparse(prhs[3]) || mxIsComplex(prhs[3]) || mxGetM(prhs[3]) != 1)
  {
    mexPrintf("size of rand_idx = %d %d ", mxGetM(prhs[3]), mxGetN(prhs[3]));
    mexErrMsgTxt("rand_idx must be a dense row int64 vector.");
  }
  num_rand_idx = mxGetN(prhs[3]);
 
  shrinkfactor = mxGetPr(prhs[4]);
  if (!mxIsDouble(prhs[4]) || mxIsSparse(prhs[4]) || mxIsComplex(prhs[4]))
  {
    mexErrMsgTxt("shrinkFactor (5th argument) must be real double vector");
  }
  if (!(1 == mxGetN(prhs[4]) && Kcols == mxGetM(prhs[4])) && !(Kcols == mxGetN(prhs[4]) && 1 == mxGetM(prhs[4])))
  {
    mexPrintf("num col of K=%d and dim of shrinkFactor=%d %d", Kcols, mxGetN(prhs[4]), mxGetM(prhs[4]));
    mexErrMsgTxt("Inner dimensions of matrix multiply do not match. (num col of K and dim of shrinkFactor ");
  }

  if (!mxIsDouble(prhs[5]) || mxIsComplex(prhs[5]))
    mexErrMsgTxt("threshold is not real double");
  threshold = mxGetScalar(prhs[5]);

  
  int64_t *S;
  mwSize num_S;
  S = (int64_t *)mxGetData(prhs[6]);
  num_S = mxGetN(prhs[6]);
  
  
  double *KI;
  KI = mxGetPr(prhs[7]);
  
  
  double *retw;
  plhs[0] = mxCreateDoubleMatrix((mwSize)Kcols, 1, mxREAL);
  retw = mxGetPr(plhs[0]);
  

  
  do_iter(retw,K, Krows, Kcols, i, w, rand_idx, num_rand_idx, shrinkfactor, threshold, num_S, S,KI);

  return;
}
