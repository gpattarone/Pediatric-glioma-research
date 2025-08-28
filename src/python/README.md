# Python Scripts

This directory contains Python scripts for genomic data analysis and processing of pediatric glioma samples.

## Scripts

### `BioPySRA.py`
- **Purpose**: Download and process SRA data for pediatric glioma samples
- **Dependencies**: BioPython, SRA Toolkit
- **Usage**: `python BioPySRA.py [parameters]`

### `mutational_profile.py`
- **Purpose**: Analyze mutational profiles in pediatric glioma samples
- **Input**: Genomic variant files
- **Output**: Mutational signature analysis
- **Usage**: `python mutational_profile.py [input_file]`

### `sra_analysis.py`
- **Purpose**: Complete SRA data pipeline - download, convert to FASTQ, and quality analysis
- **Features**: 
  - Downloads SRA files using prefetch
  - Converts to FASTQ format with fastq-dump
  - Performs quality control with FastQC
  - Generates HTML reports
- **Dependencies**: SRA Toolkit, FastQC
- **Usage**: `python sra_analysis.py` (interactive mode)

### `variant_analysis.py`
- **Purpose**: Comprehensive variant calling pipeline from BAM files
- **Features**:
  - BAM file preprocessing (sorting, indexing, duplicate marking)
  - Variant calling using bcftools
  - VCF file generation and indexing
- **Dependencies**: samtools, bcftools, Picard
- **Usage**: `python variant_analysis.py --bam file1.bam file2.bam --reference genome.fa --output results/`

## Dependencies

### SRA Toolkit
```bash
# Install SRA Toolkit
conda install -c bioconda sra-tools
```
### Python packages
```bash
pip install biopython
pip install pandas
pip install numpy
```
### Bioinformatics tools
# Install via conda
```bash
conda install -c bioconda samtools bcftools fastqc picard
```

### Pipeline Workflow

Data Download: Use sra_analysis.py to download and convert SRA data
Quality Control: Automatic FastQC analysis with HTML reports
Variant Calling: Process BAM files with variant_analysis.py
Profile Analysis: Analyze mutations with mutational_profile.py

#### Notes

Ensure all bioinformatics tools are properly installed and in PATH
Scripts are optimized for pediatric glioma research workflows
Check dependency versions for compatibility
