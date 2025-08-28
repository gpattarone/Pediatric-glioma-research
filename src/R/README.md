# R Applications

This directory contains R-based applications and analysis tools for pediatric glioma research.

## Applications

### `shiny_app/` - Genomic Analysis Pipeline Teal Application

#### Overview
Interactive web application built with the `teal` framework for comprehensive genomic analysis of pediatric glioma samples. Provides integrated visualization and analysis of mutational profiles, clinical data, and therapeutic pathways.

#### Features
- **Mutational Profile Analysis**: Interactive visualization of genetic variants (CNV, SNV, Indel)
- **Clinical Integration**: Patient data correlation with genomic findings
- **Therapy Meta-Analysis**: Network analysis and therapeutic target identification
- **Pathway Integration**: Comprehensive biomarker and survival analysis

#### Key Modules
1. **Pipeline Overview**: Project summary and data tables
2. **Mutational Profile**: Gene mutation visualization and clinical summaries
3. **Therapy Meta-Analysis**: Gene interaction networks and pathway analysis
4. **Integration Analysis**: Combined genomic-clinical outcome analysis

#### Technologies Used
- **teal**: Modular Shiny application framework
- **plotly**: Interactive visualizations
- **visNetwork**: Network graph visualizations
- **DT**: Interactive data tables
- **ggplot2**: Statistical graphics

#### Sample Data
- **50 simulated patients** with pediatric glioma profiles
- **20 key genes** including TP53, EGFR, IDH1, ATRX, CDKN2A
- **Clinical variables**: Age, tumor grade, survival, treatment response
- **Therapeutic pathways**: Evidence-based treatment targets

#### Usage
```r
# Install dependencies
install.packages(c("teal", "teal.data", "teal.modules.general", 
                   "shiny", "shinydashboard", "DT", "plotly", 
                   "ggplot2", "dplyr", "visNetwork", "shinycssloaders"))

# Run application
source("shiny_app/teal-genomics-app.R")
```

#### Deployment
- **Local**: Run directly in RStudio or R console
- **shinyapps.io**: Deploy for web access
- **Docker**: Containerized deployment available

## Dependencies

### Required R Packages
```r
# Core teal framework
install.packages(c("teal", "teal.data", "teal.modules.general"))

# Shiny ecosystem
install.packages(c("shiny", "shinydashboard", "shinycssloaders"))

# Data visualization
install.packages(c("plotly", "ggplot2", "visNetwork", "DT"))

# Data manipulation
install.packages(c("dplyr"))
```

### System Requirements
- **R**: Version 4.0+ recommended
- **Memory**: Minimum 4GB RAM
- **Browser**: Modern web browser for optimal experience

## Data Structure

### Input Data Format
The application expects three main datasets:

#### Mutations Data
```r
mutations_data <- data.frame(
  USUBJID = "Patient ID",
  Gene = "Gene symbol",
  Variant_Type = "CNV/SNV/Indel",
  Mutation_Count = "Integer count",
  VAF = "Variant allele frequency",
  Clinical_Significance = "Pathogenic/Benign/VUS"
)
```

#### Clinical Data
```r
clinical_data <- data.frame(
  USUBJID = "Patient ID",
  AGE = "Age in years",
  SEX = "M/F",
  TUMOR_GRADE = "Grade I-IV",
  SURVIVAL_MONTHS = "Integer",
  TREATMENT_RESPONSE = "Response category",
  IDH_STATUS = "IDH-wildtype/IDH-mutant",
  MGMT_STATUS = "Methylated/Unmethylated"
)
```

#### Pathways Data
```r
pathways_data <- data.frame(
  Pathway = "Pathway name",
  Key_Finding = "Scientific finding",
  Therapeutic_Target = "Treatment approach"
)
```

## Customization

### Adding New Modules
```r
# Create custom teal module
tm_custom_analysis <- function(label = "Custom Analysis") {
  module(
    label = label,
    server = function(id, data) {
      # Module server logic
    },
    ui = function(id) {
      # Module UI definition
    }
  )
}
```

### Modifying Visualizations
- Edit plot functions in each module's server function
- Customize themes and colors in ggplot2 calls
- Adjust network layouts in visNetwork configurations

### Data Integration
- Replace sample data generation with real data loading
- Modify data validation and preprocessing steps
- Add new clinical variables as needed

## Performance Optimization

### For Large Datasets
- Implement data sampling for initial loading
- Use reactive expressions for expensive computations
- Consider database backends for very large datasets

### UI Responsiveness
- Use `withSpinner()` for loading indicators
- Implement progressive disclosure for complex analyses
- Optimize plot rendering with appropriate sizes

## Deployment Options

### Local Development
```r
# Run in RStudio
source("teal-genomics-app.R")

# Run from command line
Rscript teal-genomics-app.R
```

### Web Deployment
```r
# Deploy to shinyapps.io
library(rsconnect)
deployApp("shiny_app/", appName = "pediatric-glioma-analysis")
```

### Docker Deployment
```dockerfile
FROM rocker/shiny:latest
RUN R -e "install.packages(c('teal', 'plotly', 'visNetwork'))"
COPY shiny_app/ /srv/shiny-server/
```

## Integration with Pipeline

This Shiny application integrates with the broader genomic pipeline:

1. **Input**: VCF files from `variant_analysis.py`
2. **Processing**: Mutation profiles from `mutational_profile.py`
3. **Output**: Interactive visualizations and analysis reports
4. **Database**: Clinical data from `load_meta_analysis.nf`

## Future Enhancements

- Real-time data loading from pipeline outputs
- Export functionality for plots and tables
- Advanced statistical analysis modules
- Integration with external genomic databases
- Multi-omics data support

## Troubleshooting

### Common Issues
- **Package installation**: Ensure all dependencies are installed
- **Memory issues**: Increase R memory limit or use data sampling
- **Display problems**: Update web browser or try different browser

### Performance Tips
- Use `options(shiny.maxRequestSize = 30*1024^2)` for large file uploads
- Implement caching for expensive computations
- Use `reactiveFileReader()` for dynamic data loading

## Contributing

When contributing to the Shiny application:
1. Follow teal module conventions
2. Test with sample data before real data integration
3. Document new features and visualizations
4. Ensure responsive design across devices

**¿Ya creaste el README de la carpeta R?** Ahora te paso el README específico para la carpeta `shiny_app/`.
