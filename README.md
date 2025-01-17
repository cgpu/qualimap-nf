# Quality control of WGS/WES/target alignment data #

[![CircleCI](https://circleci.com/gh/IARCbioinfo/qualimap-nf.svg?style=svg)](https://circleci.com/gh/IARCbioinfo/qualimap-nf/)[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://hub.docker.com/r/iarcbioinfo/qualimap-nf/)
[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/1623)
[![DOI](https://zenodo.org/badge/145996279.svg)](https://zenodo.org/badge/latestdoi/145996279)

![Image Qualimap](https://github.com/ImaneLboukili/WGS_analysis/blob/master/Qualimap/Qualimap-nf.png)

## Description ##

Perform quality control of WGS/WES/target alignment data.

## Dependencies ##

1. This pipeline is based on [nextflow](https://www.nextflow.io). As we have several nextflow pipelines, we have centralized the common information in the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository. Please read it carefully as it contains essential information for the installation, basic usage and configuration of nextflow and our pipelines.
2. samtools: see official installation [here](http://www.htslib.org). You can avoid installing all the external software by only installing Docker (not available yet). See the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository for more information.)
3. Qualimap: see official installation [here](http://qualimap.bioinfo.cipf.es). You can avoid installing all the external software by only installing Docker (not available yet). See the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository for more information.)
4. Multiqc: see official installation [here](http://multiqc.info). You can avoid installing all the external software by only installing Docker (not available yet). See the [IARC-nf](https://github.com/IARCbioinfo/IARC-nf) repository for more information.)

## Input ##

**Name**        | **Description**
--------------- | -------------
--input_folder  |  Folder containing Fasta files
--output_folder |  Path to output folder

## Parameters ##

### Optional ###

**Name**          | **Example value** | **Description**
------------------| ------------------| ------------------
--qualimap        | /usr/bin/qualimap | Path to Qualimap installation directory
--feature_file    | myfeatures.txt    | Qualimap feature file for coverage analysis
--samtools        | /usr/bin/samtools | Path to samtools installation directory
--multiqc         | /usr/bin/multiqc  | Path to MutliQC installation directory
--cpu             | INTEGER           | Number of cpus to be used

### Flags ###

Flags are special parameters without value.

**Name**      | **Description**
------------- | -------------
--help        | Display help

## Download test data set ##

`git clone https://github.com/iarcbioinfo/data_test`

## Usage ##
`nextflow run iarcbioinfo/Qualimap-nf   --qualimap /path/to/qualimap  --multiqc /path/to/multiqc --samtools /path/to/samtools --input_folder /path/to/bam  --output_folder /path/to/output`

## Output ##


**Name**        | **Description**
--------------- | -------------
HTMLs           | An html file for each analysed BAM file, and one containing the aggregated results
