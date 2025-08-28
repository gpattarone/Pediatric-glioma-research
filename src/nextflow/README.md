# Nextflow Workflows

This directory contains Nextflow workflows for automated genomic data processing pipelines in pediatric glioma research.

## Workflows

### `biopy_sra.nf`
- **Purpose**: Automated SRA data download and processing pipeline
- **Features**:
  - Downloads BioPySRA.py script from GitHub repository
  - Processes multiple SRA accession IDs from input file
  - Batch processing of SRA data
- **Input**: `accessions.txt` (one SRA accession ID per line)
- **Output**: Individual result files for each accession
- **Usage**: 
  ```bash
  nextflow run biopy_sra.nf --accessions accessions.txt --output ./results/biopy_sra
  ```

### `mutational_profile.nf`
- **Purpose**: VCF file parsing and mutational profile analysis
- **Features**:
  - Processes VCF files through Python mutational_profile.py script
  - Generates CSV output with mutational signatures
- **Input**: VCF files from variant calling
- **Output**: `mutational_profile.csv`
- **Usage**: 
  ```bash
  nextflow run mutational_profile.nf --vcf input.vcf
  ```

### `load_meta_analysis.nf`
- **Purpose**: Database loading pipeline for meta-analysis data
- **Features**:
  - Loads therapy meta-analysis data into PostgreSQL database
  - Automated table creation and data insertion
  - Handles CSV to database migration
- **Input**: CSV file with therapy data
- **Output**: Data loaded into PostgreSQL database
- **Usage**: 
  ```bash
  nextflow run load_meta_analysis.nf --meta_analysis_csv therapies.csv
  ```

## Parameters

### Global Parameters
- `params.output`: Output directory for results
- `params.accessions`: Path to SRA accessions file
- `params.vcf`: Path to VCF input file
- `params.meta_analysis_csv`: Path to meta-analysis CSV file

## Dependencies

### Nextflow
```bash
# Install Nextflow
curl -s https://get.nextflow.io | bash
```

### Required Tools
```bash
# Install via conda
conda install -c bioconda nextflow
conda install -c anaconda wget
conda install -c anaconda python
conda install -c anaconda pandas
conda install -c anaconda psycopg2
```

### Database Setup (for load_meta_analysis.nf)
```sql
-- PostgreSQL setup
CREATE DATABASE therapies_db;
-- Update connection details in the workflow
```

## Pipeline Integration

1. **SRA Processing**: `biopy_sra.nf` → Download and process SRA data
2. **Variant Analysis**: Use Python scripts to generate VCF files
3. **Mutational Profiling**: `mutational_profile.nf` → Analyze mutations
4. **Meta-Analysis Loading**: `load_meta_analysis.nf` → Store therapy data

## Configuration

Create a `nextflow.config` file in the project root:
```groovy
params {
    output = './results'
    accessions = 'data/accessions.txt'
    meta_analysis_csv = 'data/meta_analysis_therapies.csv'
}

process {
    executor = 'local'
    cpus = 2
    memory = '4 GB'
}
```

## Notes
- Ensure all Python dependencies are installed
- Update database credentials in `load_meta_analysis.nf`
- Workflows are designed for pediatric glioma research datasets
- Check Nextflow version compatibility
