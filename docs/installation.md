# Installation Guide

Complete installation guide for the Pediatric Gliomas Research Pipeline.

## Prerequisites

### System Requirements
- **Operating System**: Linux/macOS (recommended) or Windows with WSL
- **RAM**: Minimum 8GB, recommended 16GB+
- **Storage**: At least 50GB free space for data processing
- **Python**: Version 3.8 or higher
- **Java**: Version 8+ (required for Nextflow and some tools)

## Installation Steps

### 1. Clone the Repository
```bash
git clone https://github.com/gpattarone/Pediatric-gliomas_research.git
cd Pediatric-gliomas_research
```

### 2. Install Python Dependencies
```bash
# Create virtual environment (recommended)
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install Python packages
pip install biopython pandas numpy psycopg2-binary
```

### 3. Install SRA Toolkit
```bash
# Option 1: Using conda (recommended)
conda install -c bioconda sra-tools

# Option 2: Manual installation
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar -xzf sratoolkit.current-ubuntu64.tar.gz
export PATH=$PATH:$PWD/sratoolkit.3.0.0-ubuntu64/bin
```

### 4. Install Bioinformatics Tools
```bash
# Using conda (recommended)
conda install -c bioconda samtools bcftools fastqc picard

# Verify installations
samtools --version
bcftools --version
fastqc --version
```

### 5. Install Nextflow
```bash
# Install Nextflow
curl -s https://get.nextflow.io | bash
chmod +x nextflow
sudo mv nextflow /usr/local/bin/

# Verify installation
nextflow -version
```

### 6. Database Setup (Optional)
If using the meta-analysis database loading feature:

```bash
# Install PostgreSQL
sudo apt-get install postgresql postgresql-contrib

# Start PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create database
sudo -u postgres createdb therapies_db

# Create user (optional)
sudo -u postgres createuser --interactive
```

## Configuration

### 1. SRA Toolkit Configuration
```bash
# Configure SRA toolkit
vdb-config --interactive

# Test configuration
prefetch --help
```

### 2. Create Configuration File
Create `nextflow.config` in project root:
```groovy
params {
    // Input/Output directories
    output = './results'
    accessions = 'data/accessions.txt'
    meta_analysis_csv = 'data/meta_analysis_therapies.csv'
}

process {
    executor = 'local'
    cpus = 4
    memory = '8 GB'
    
    // Error handling
    errorStrategy = 'retry'
    maxRetries = 2
}

// Conda environment (if using conda)
conda.enabled = true
```

### 3. Prepare Input Data
```bash
# Create sample accessions file
echo -e "SRR123456\nSRR789012" > data/accessions.txt

# Verify data directory structure
ls -la data/
```

## Verification

### Test Installation
```bash
# Test Python scripts
python3 src/python/sra_analysis.py --help

# Test Nextflow workflows
nextflow run src/nextflow/mutational_profile.nf --help

# Test bioinformatics tools
samtools --version
bcftools --version
fastqc --version
```

### Run Sample Pipeline
```bash
# Quick test with sample data
nextflow run src/nextflow/biopy_sra.nf \
  --accessions data/sample_accessions.txt \
  --output ./test_results
```

## Troubleshooting

### Common Issues

#### 1. Permission Denied Errors
```bash
# Fix executable permissions
chmod +x src/python/*.py
chmod +x nextflow
```

#### 2. Missing Dependencies
```bash
# Install missing Python packages
pip install --upgrade pip
pip install -r requirements.txt  # If you create this file
```

#### 3. SRA Toolkit Issues
```bash
# Clear SRA cache
rm -rf ~/.ncbi
vdb-config --restore-defaults

# Reconfigure
vdb-config --interactive
```

#### 4. Memory Issues
```bash
# Reduce memory usage in nextflow.config
process.memory = '4 GB'
```

#### 5. Network Issues
```bash
# Test internet connectivity
curl -I https://www.ncbi.nlm.nih.gov/

# Configure proxy if needed
export http_proxy=http://proxy.server:port
export https_proxy=https://proxy.server:port
```

## Performance Optimization

### For Large Datasets
```groovy
// In nextflow.config
process {
    cpus = 8
    memory = '16 GB'
    executor = 'slurm'  // If using cluster
}
```

### Parallel Processing
```bash
# Use multiple cores
nextflow run workflow.nf -with-conda -resume
```

## Docker Installation (Alternative)

### Using Docker
```bash
# Pull pre-built image (when available)
docker pull gpattarone/pediatric-gliomas:latest

# Run container
docker run -v $(pwd):/data gpattarone/pediatric-gliomas:latest
```

### Build Custom Image
```dockerfile
# Dockerfile example
FROM continuumio/miniconda3

RUN conda install -c bioconda sra-tools samtools bcftools fastqc
RUN pip install biopython pandas numpy

COPY . /app
WORKDIR /app
```

## Getting Help

- **Documentation**: Check other files in `docs/` directory
- **Issues**: Report installation problems on [GitHub Issues](https://github.com/gpattarone/Pediatric-gliomas_research/issues)
- **Community**: Join discussions on GitHub Discussions

## Next Steps

After successful installation:
1. Read the [Pipeline Overview](pipeline_overview.md)
2. Follow the [Quick Start Tutorial](quick_start.md)
3. Review the [Configuration Guide](configuration.md)

