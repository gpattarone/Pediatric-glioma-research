# Pipeline Overview

Comprehensive overview of the Pediatric Gliomas Research Pipeline architecture, workflows, and data flow.

## Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Data Input    │    │   Processing    │    │    Analysis     │
│                 │    │                 │    │                 │
│ • SRA Files     │───▶│ • Quality Check │───▶│ • Mutational    │
│ • FASTQ Files   │    │ • Alignment     │    │   Profiling     │
│ • BAM Files     │    │ • Variant Call  │    │ • Meta-analysis │
│ • CSV Data      │    │ • Preprocessing │    │ • Visualization │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Workflow Components

### 1. Data Acquisition Layer

#### SRA Data Pipeline
```
SRA Accession ──▶ prefetch ──▶ fastq-dump ──▶ FastQC ──▶ Quality Reports
     │                                                        │
     └── biopy_sra.nf ────────────────────────────────────────┘
```

**Key Components:**
- **`sra_analysis.py`**: Interactive SRA download and quality control
- **`biopy_sra.nf`**: Nextflow workflow for batch SRA processing
- **`BioPySRA.py`**: Core SRA processing functions

#### Input Data Types
- **SRA Accessions**: NCBI Sequence Read Archive identifiers
- **FASTQ Files**: Raw sequencing data
- **BAM Files**: Aligned sequencing data
- **Meta-analysis Data**: Therapy and clinical information

### 2. Processing Layer

#### Variant Analysis Pipeline
```
BAM Files ──▶ Preprocessing ──▶ Variant Calling ──▶ VCF Files
    │              │                   │              │
    │              ▼                   ▼              ▼
    │         • Sorting           • bcftools      • Indexing
    │         • Indexing          • mpileup       • Filtering
    │         • Deduplication     • call          • Annotation
    │
    └── variant_analysis.py ─────────────────────────────────┘
```

**Processing Steps:**
1. **BAM Preprocessing**:
   - Sorting with samtools
   - Indexing for rapid access
   - Duplicate marking with Picard

2. **Variant Calling**:
   - SNP/INDEL detection with bcftools
   - Quality filtering
   - VCF format output

3. **Quality Control**:
   - FastQC analysis
   - HTML report generation
   - Metrics collection

### 3. Analysis Layer

#### Mutational Profiling
```
VCF Files ──▶ mutational_profile.py ──▶ CSV Results ──▶ Visualization
    │                                        │              │
    │                                        ▼              ▼
    └── mutational_profile.nf ──▶ Mutation Signatures ──▶ Reports
```

**Analysis Components:**
- **Mutation Detection**: Identification of genetic variants
- **Signature Analysis**: Mutational pattern recognition
- **Profile Generation**: Statistical summaries
- **Comparative Analysis**: Cross-sample comparisons

#### Meta-analysis Integration
```
CSV Data ──▶ PostgreSQL ──▶ load_meta_analysis.nf ──▶ Database
    │            │                                      │
    │            ▼                                      ▼
    │       Therapy Data                          Query Interface
    │                                                   │
    └── Integration with Genomic Data ◀─────────────────┘
```

## Data Flow Diagram

### Complete Pipeline Flow
```
┌─────────────┐
│ SRA/FASTQ   │
│ Data Input  │
└──────┬──────┘
       │
       ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Quality   │    │ Alignment & │    │  Variant    │
│   Control   │───▶│ Processing  │───▶│  Calling    │
│  (FastQC)   │    │ (samtools)  │    │ (bcftools)  │
└─────────────┘    └─────────────┘    └──────┬──────┘
                                              │
                                              ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Results   │    │  Analysis   │    │   VCF       │
│   Export    │◀───│ & Profiling │◀───│  Output     │
│             │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │
       ▼                   ▼
┌─────────────┐    ┌─────────────┐
│ Shiny App   │    │   Database  │
│Visualization│    │   Storage   │
└─────────────┘    └─────────────┘
```

## Nextflow Workflows

### 1. `biopy_sra.nf`
**Purpose**: Automated SRA data processing
```nextflow
Input: accessions.txt → Process: BioPySRA.py → Output: Individual results
```

**Features:**
- Batch processing of multiple SRA accessions
- Automatic script download from GitHub
- Parallel execution
- Error handling and retry logic

### 2. `mutational_profile.nf`
**Purpose**: VCF analysis and profiling
```nextflow
Input: VCF files → Process: mutational_profile.py → Output: CSV profiles
```

**Features:**
- Mutation signature analysis
- Statistical profiling
- Automated report generation

### 3. `load_meta_analysis.nf`
**Purpose**: Database integration
```nextflow
Input: CSV data → Process: PostgreSQL loading → Output: Structured database
```

**Features:**
- Automatic table creation
- Data validation
- Bulk loading operations

## Configuration Management

### Nextflow Configuration
```groovy
// Global parameters
params {
    output = './results'
    accessions = 'data/accessions.txt'
    meta_analysis_csv = 'data/meta_analysis_therapies.csv'
}

// Process configuration
process {
    executor = 'local'
    cpus = 4
    memory = '8 GB'
    errorStrategy = 'retry'
    maxRetries = 2
}
```

### Resource Management
- **CPU Allocation**: Configurable per process
- **Memory Management**: Adaptive based on data size
- **Storage**: Automatic cleanup of intermediate files
- **Error Handling**: Retry mechanisms and logging

## Integration Points

### External Tools Integration
- **SRA Toolkit**: Data download and conversion
- **samtools/bcftools**: Alignment and variant calling
- **FastQC**: Quality control
- **Picard**: BAM processing
- **PostgreSQL**: Data storage

### API Endpoints
- **NCBI SRA**: Automated data retrieval
- **Reference Genomes**: Automatic download
- **Annotation Databases**: Variant annotation

## Performance Characteristics

### Scalability
- **Parallel Processing**: Multiple samples simultaneously
- **Memory Optimization**: Streaming for large files
- **Cluster Support**: SLURM/PBS integration available
- **Cloud Ready**: AWS/GCP deployment possible

### Typical Processing Times
- **SRA Download**: 10-30 minutes per sample
- **Quality Control**: 5-10 minutes per sample
- **Variant Calling**: 30-60 minutes per sample
- **Analysis**: 5-15 minutes per sample

## Output Structure

### Results Directory
```
results/
├── sra_data/
│   ├── sample1/
│   │   ├── sample1.fastq
│   │   └── sample1_fastqc.html
│   └── sample2/
├── variants/
│   ├── sample1.vcf
│   └── sample2.vcf
├── profiles/
│   ├── mutational_profiles.csv
│   └── summary_statistics.json
└── reports/
    ├── quality_report.html
    └── analysis_summary.pdf
```

## Quality Control

### Data Validation
- **Input Validation**: File format checking
- **Process Monitoring**: Real-time status tracking
- **Output Verification**: Result integrity checks
- **Error Reporting**: Comprehensive logging

### Reproducibility
- **Version Control**: All scripts versioned
- **Parameter Tracking**: Complete parameter logs
- **Environment Recording**: Conda/Docker environments
- **Seed Management**: Random seed control

## Next Steps

After understanding the pipeline:
1. Follow the [Quick Start Tutorial](quick_start.md)
2. Review [Configuration Guide](configuration.md)
3. Check [Troubleshooting](troubleshooting.md) for common issues
4. Explore [Results Interpretation](results_interpretation.md)

## Pipeline Customization

The pipeline is designed to be modular and extensible:
- **Custom Scripts**: Add new analysis modules
- **Parameter Tuning**: Optimize for specific datasets
- **Workflow Modification**: Adapt Nextflow processes
- **Integration**: Connect with existing pipelines
