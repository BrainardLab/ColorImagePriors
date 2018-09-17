# Color Image Priors
Thinking about priors for color images that go beyond Gaussian.

1. Gaussian Scale Mixture Model
    - #TODO: To be implemented
    - #TODO: Compare with Sparse and PCA model (for grayscale images)

2. Sparse Coding Based Model (Basic Pipeline under /Sparse-Coding)
    - Basis set learning with **reconICA.m** (#TODO: property of the basis as function of **set size** and **image size**)
    - **Core functions:**
    PCA based reconstruction with **pcaRecon.m** (we have a relatively good understanding of this); Sparse coding based reconsturction with **lassoRecon.m**    
    - Basic testing (debug and so on): **testPCA.m** and **testSparse.m**
    - Out-of-sample test: **imgReconFun.m** (Patch-by-patch reconsturction of an entire exemplar image)
    - #TODO: replace Render Matrix with more generic Forward Model (likelihood function)
