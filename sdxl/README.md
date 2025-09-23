# SDXL Scripts

# Instructions
1. Download IRPA.
    * The link to download can be found in the `benchmark-unet.sh` script for each version of the model
    * Use `wget <irpa-link>` to download and `md5sum` to validate the download
2. Compile model with `compile-unet.sh`
3. Benchmark with `benchmark-unet.sh`
    * Add `USE_TRACY=1` to profile with Tracy
