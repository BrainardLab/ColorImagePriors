# Color Image Priors
Thinking about priors for color images that go beyond Gaussian.

1. Gaussian Scale Mixture Model
    - #TODO: To be implemented

2. Sparse Coding Based Model
    - Basis set learning with **reconICA.m** (#TODO: property of the basis as function of set size and image size)
    - PCA based reconstruction with **pcaRecon.m** (we have a relatively good understanding of this)
    - Sparse coding based reconsturction with **lassoRecon.m**
    - Basic testing (debug and so on): **testPCA.m** **testSparse.m**
    - Out-of-sample test: **imgReconFun.m** (Patch-by-patch reconsturction of an entire image)
    - #TODO: replace Render Matrix with more generic Forward Model (likelihood function)
