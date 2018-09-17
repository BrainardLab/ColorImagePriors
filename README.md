# Color Image Priors
Thinking about priors for color images that go beyond Gaussian.

1. Gaussian Scale Mixture Model
    - #TODO: To be implemented

2. Sparse Coding Based Model

Basic pipeline for reconstruction method: 
    - Basis set learning with reconICA.m #TODO: property of the basis as function of set size and image size
    - PCA based reconstruction with pcaRecon.m (we have a relatively good understanding of this)
    - Sparse coding based reconsturction with lassoRecon.m 
    - Out-of-sample test: imgReconFun.m (Patch-by-patch reconsturction of an entire image)
    - #TODO: replace Render Matrix with more generic Forward Model (likelihood function)
