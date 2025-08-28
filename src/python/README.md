# Python Scripts

This directory contains Python scripts for genomic data analysis and processing.

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

## Requirements

```bash
pip install biopython
pip install pandas
pip install numpy
```

## Notes
Ensure SRA Toolkit is installed and configured
Scripts are optimized for pediatric glioma research workflows
