# Quick Start Tutorial

Get up and running with the Pediatric Gliomas Research Pipeline in 15 minutes.

## Prerequisites Checklist

Before starting, ensure you have:
- [ ] Python 3.8+ installed
- [ ] Git installed
- [ ] SRA Toolkit configured
- [ ] Basic bioinformatics tools (samtools, bcftools, fastqc)
- [ ] Nextflow installed

> **Need help with installation?** See the [Installation Guide](installation.md).

## Step 1: Clone and Setup

```bash
# Clone the repository
git clone https://github.com/gpattarone/Pediatric-gliomas_research.git
cd Pediatric-gliomas_research

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install Python dependencies
pip install biopython pandas numpy psycopg2-binary
```

## Step 2: Prepare Sample Data

### Create Sample Input Files

```bash
# Create a sample SRA accessions file
mkdir -p data/
echo -e "SRR8615409\nSRR8615410" > data/sample_accessions.txt

# Verify the file
cat data/sample_accessions.txt
```

### Download Sample Data (Optional)
```bash
# For testing - download a small sample
python3 src/python/sra_analysis.py
# When prompted, enter: SRR8615409
```

## Step 3: Basic Usage Examples

### Example 1: SRA Data Analysis

**Interactive Mode:**
```bash
# Run the interactive SRA analysis script
python3 src/python/sra_analysis.py

# Follow the prompts:
# Enter the SRA accession number: SRR8615409
```

**Expected Output:**
```
Downloading SRA files...
Converting SRA files to FastQ format...
Analyzing FastQ files with FastQC...
Generating HTML report...
HTML report generated in the 'reports' directory.
```

### Example 2: Batch Processing with Nextflow

**Run SRA Batch Processing:**
```bash
# Process multiple SRA accessions
nextflow run src/nextflow/biopy_sra.nf \
  --accessions data/sample_accessions.txt \
  --output ./results/sra_batch
```

**Monitor Progress:**
```
N E X T F L O W  ~  version 21.04.0
Launching `src/nextflow/biopy_sra.nf` [nostalgic_lovelace] - revision: a1b2c3d

executor >  local (2)
[12/34abc5] process > run_biopy_sra (SRR8615409) [100%] 2 of 2 ✓

Completed at: 28-Aug-2025 10:30:45
Duration    : 5m 23s
CPU hours   : 0.2
Succeeded   : 2
```

### Example 3: Variant Analysis

**Process BAM Files:**
```bash
# Example with sample BAM files
python3 src/python/variant_analysis.py \
  --bam sample1.bam sample2.bam \
  --reference GRCh38.fa \
  --output ./results/variants
```

**Expected Files:**
```
results/variants/
├── sample1.vcf
├── sample1.vcf.gz
├── sample2.vcf
└── sample2.vcf.gz
```

## Step 4: Results Exploration

### Check Output Structure
```bash
# View results directory
ls -la results/

# Check specific outputs
ls -la results/sra_batch/
ls -la reports/
```

### Sample Results
```
results/
├── sra_batch/
│   ├── SRR8615409.results/
│   │   ├── SRR8615409.fastq
│   │   └── SRR8615409_fastqc.html
│   └── SRR8615410.results/
└── variants/
    ├── sample1.vcf
    └── sample2.vcf
```

## Step 5: Advanced Workflows

### Mutational Profile Analysis
```bash
# Analyze VCF files for mutational signatures
nextflow run src/nextflow/mutational_profile.nf \
  --vcf results/variants/sample1.vcf
```

### Meta-analysis Data Loading
```bash
# Load therapy data into database
nextflow run src/nextflow/load_meta_analysis.nf \
  --meta_analysis_csv data/meta_analysis_therapies.csv
```

## Common Workflows

### Workflow 1: Complete SRA-to-Analysis Pipeline
```bash
# Step 1: Download SRA data
python3 src/python/sra_analysis.py

# Step 2: Process FASTQ (if you have alignment pipeline)
# [Alignment steps would go here]

# Step 3: Variant calling
python3 src/python/variant_analysis.py \
  --bam aligned.bam \
  --reference genome.fa \
  --output variants/

# Step 4: Mutational profiling
nextflow run src/nextflow/mutational_profile.nf \
  --vcf variants/sample.vcf
```

### Workflow 2: Batch Analysis
```bash
# Process multiple samples with Nextflow
nextflow run src/nextflow/biopy_sra.nf \
  --accessions data/accessions_list.txt \
  --output results/batch_$(date +%Y%m%d)
```

## Configuration Quick Setup

### Create Basic Configuration
```bash
# Create nextflow.config
cat > nextflow.config << 'EOF'
params {
    output = './results'
    accessions = 'data/sample_accessions.txt'
    meta_analysis_csv = 'data/meta_analysis_therapies.csv'
}

process {
    executor = 'local'
    cpus = 2
    memory = '4 GB'
}
EOF
```

### Test Configuration
```bash
# Test with configuration
nextflow run src/nextflow/biopy_sra.nf -c nextflow.config
```

## Troubleshooting Quick Fixes

### Issue 1: Permission Denied
```bash
# Fix permissions
chmod +x src/python/*.py
chmod +x nextflow
```

### Issue 2: SRA Download Fails
```bash
# Check SRA toolkit configuration
vdb-config --interactive

# Test connection
prefetch --help
```

### Issue 3: Missing Dependencies
```bash
# Reinstall dependencies
pip install --upgrade biopython pandas numpy

# Check tool availability
which samtools
which bcftools
which fastqc
```

### Issue 4: Nextflow Errors
```bash
# Clean work directory
rm -rf work/

# Resume from checkpoint
nextflow run workflow.nf -resume
```

## Performance Tips

### For Small Datasets (< 1GB)
```groovy
// In nextflow.config
process {
    cpus = 2
    memory = '4 GB'
}
```

### For Large Datasets (> 10GB)
```groovy
// In nextflow.config
process {
    cpus = 8
    memory = '16 GB'
    executor = 'slurm'  // If using cluster
}
```

## Quick Commands Reference

### Essential Commands
```bash
# Clone repository
git clone https://github.com/gpattarone/Pediatric-gliomas_research.git

# Interactive SRA analysis
python3 src/python/sra_analysis.py

# Batch SRA processing
nextflow run src/nextflow/biopy_sra.nf --accessions data/accessions.txt

# Variant analysis
python3 src/python/variant_analysis.py --bam file.bam --reference ref.fa --output results/

# Mutational profiling
nextflow run src/nextflow/mutational_profile.nf --vcf file.vcf

# Check results
ls -la results/
```

### File Structure Check
```bash
# Verify repository structure
tree -L 3
# or
find . -type d -name "src" -o -name "data" -o -name "docs"
```

## Next Steps

Now that you've completed the quick start:

1. **Explore Advanced Features**: 
   - Read [Pipeline Overview](pipeline_overview.md) for detailed workflow
   - Check [Configuration Guide](configuration.md) for optimization

2. **Customize for Your Data**:
   - Modify parameters in `nextflow.config`
   - Add your own SRA accessions to `data/accessions.txt`

3. **Integration**:
   - Set up database connections for meta-analysis
   - Configure cluster computing if available

4. **Visualization**:
   - Explore the Shiny application (coming soon)
   - Generate custom reports

## Getting Help

- **Documentation**: Browse other files in `docs/` directory
- **Issues**: Report problems on [GitHub Issues](https://github.com/gpattarone/Pediatric-gliomas_research/issues)
- **Questions**: Use [GitHub Discussions](https://github.com/gpattarone/Pediatric-gliomas_research/discussions)

## Success Indicators

You've successfully completed the quick start if you can:
- [ ] Download SRA data using the Python scripts
- [ ] Run a Nextflow workflow without errors
- [ ] Generate FastQC reports
- [ ] Process VCF files for mutational analysis
- [ ] Navigate the results directory structure

You're now ready to analyze pediatric glioma genomic data with this pipeline.
archivo que la gente ve primero cuando llega a tu repo, así que debería ser impactante y profesional.
