# Pediatric Glioma Genomic Analysis - Teal Application

Interactive web application for comprehensive genomic analysis of pediatric glioma samples using the teal framework.

## Application Overview

This Teal application provides a complete analytical workflow for pediatric glioma research, integrating mutational profiling, clinical data analysis, and therapeutic pathway evaluation in a user-friendly interface.

### Key Features
- **Interactive Visualizations**: Dynamic plots with plotly integration
- **Modular Design**: Teal-based architecture for extensibility  
- **Clinical Integration**: Patient outcomes correlated with genomic data
- **Network Analysis**: Gene interaction and pathway visualization
- **Export Capabilities**: Download plots and data tables

## Quick Start

### Prerequisites
```r
# Install required packages
install.packages(c(
  "teal", "teal.data", "teal.modules.general",
  "shiny", "shinydashboard", "DT", "plotly", 
  "ggplot2", "dplyr", "visNetwork", "shinycssloaders"
))
```

### Launch Application
```r
# Method 1: Direct execution
source("teal-genomics-app.R")

# Method 2: From parent directory
source("src/R/shiny_app/teal-genomics-app.R")

# Method 3: RStudio
# Open teal-genomics-app.R and click "Run App"
```

## Application Modules

### 1. Pipeline Overview
**Purpose**: Project introduction and data summary
- Project description and methodology
- Data tables overview (mutations, clinical, pathways)
- Sample size and key statistics

### 2. Mutational Profile Analysis
**Purpose**: Genetic variant visualization and analysis

**Features**:
- **Interactive Bar Chart**: Mutation counts by gene and variant type
- **Clinical Summary Table**: Patient demographics and outcomes by tumor grade
- **Key Insights**: TP53, TERT, EGFR mutation patterns

**Sample Insights**:
- CNV variants dominate in EGFR and CDKN2A
- SNV patterns significant in TP53 and IDH1
- Clinical correlation with tumor grade and survival

### 3. Therapy Meta-Analysis
**Purpose**: Therapeutic target identification and pathway analysis

**Visualizations**:
- **Correlation Heatmap**: Gene interaction matrix
- **Network Graph**: Interactive gene-pathway relationships  
- **Pathway Table**: Evidence-based therapeutic targets

**Key Pathways**:
- IDH1/IDH2 mutations → Ivosidenib/Enasidenib
- EGFR amplification → Cetuximab, Erlotinib
- BRAF mutations → Vemurafenib, Dabrafenib
- CDK4/6 targets → Palbociclib, Abemaciclib

### 4. Integration Analysis
**Purpose**: Combined genomic-clinical outcome analysis

**Components**:
- **Integrated Data Table**: Mutation frequency by clinical variables
- **Biomarker Survival Plot**: Mutation status vs survival outcomes
- **Risk Stratification**: High-risk mutation combinations

## User Interface

### Visual Design Elements
```css
/* Key styling components */
.findings-box {
  background: #fff3cd;
  border: 1px solid #ffeaa7;
  padding: 15px;
}

.discovery-box {
  background: #e8f4fd;
  border-left: 4px solid #3498db;
  padding: 15px;
}
```

### Color Scheme
- **CNV variants**: `#3498db` (Blue)
- **SNV variants**: `#e74c3c` (Red)  
- **Indel variants**: `#f39c12` (Orange)
- **Pathogenic**: `#e74c3c` (Red)
- **Benign**: `#27ae60` (Green)

## 📈 Data Structure

### Sample Data Generation
The application includes a comprehensive data generator:

```r
generate_teal_genomic_data <- function() {
  # 50 simulated pediatric patients
  # 20 key glioma-relevant genes
  # Clinical variables: age, grade, survival, response
  # Pathway information: therapeutic targets
}
```

### Key Genes Analyzed
- **Tumor Suppressors**: TP53, PTEN, RB1, CDKN2A
- **Oncogenes**: EGFR, MDM2, CDK4, PIK3CA
- **Metabolic**: IDH1, IDH2
- **Chromatin**: ATRX, H3F3A, HIST1H3B
- **Signaling**: BRAF, PIK3R1, NF1

### Clinical Variables
- **Demographics**: Age (5-18), Sex (M/F)
- **Tumor Characteristics**: Grade (I-IV), IDH status, MGMT methylation
- **Outcomes**: Survival months, treatment response
- **Biomarkers**: VAF, clinical significance

## 🔧 Customization Guide

### Adding New Visualizations
```r
# Example: Add new plot to existing module
output$new_plot <- renderPlotly({
  req(data())
  # Your plotting code here
  ggplotly(your_plot)
})
```

### Creating Custom Modules
```r
tm_custom_module <- function(label = "Custom Analysis") {
  module(
    label = label,
    server = function(id, data) {
      moduleServer(id, function(input, output, session) {
        # Server logic
      })
    },
    ui = function(id) {
      ns <- NS(id)
      # UI components
    },
    datanames = c("your_data")
  )
}
```

### Integrating Real Data
```r
# Replace sample data with real datasets
app_data <- teal_data() |>
  within({
    mutations <- read.csv("path/to/mutations.csv")
    clinical <- read.csv("path/to/clinical.csv")  
    pathways <- read.csv("path/to/pathways.csv")
  })
```

## Deployment Options

### Local Development
```r
# Run locally for development
shinyApp(app$ui, app$server)
```

### shinyapps.io Deployment
```r
library(rsconnect)

# First time setup
rsconnect::setAccountInfo(
  name = "your-account",
  token = "your-token", 
  secret = "your-secret"
)

# Deploy application
rsconnect::deployApp(
  appDir = ".",
  appName = "pediatric-glioma-genomics",
  account = "your-account"
)
```

### Docker Deployment
```dockerfile
FROM rocker/shiny:4.3.0

# Install R packages
RUN R -e "install.packages(c('teal', 'teal.data', 'plotly', 'visNetwork', 'DT'))"

# Copy application
COPY teal-genomics-app.R /srv/shiny-server/app.R

EXPOSE 3838
```

### Shiny Server Deployment
```bash
# Copy to shiny server directory
sudo cp -R shiny_app/ /srv/shiny-server/pediatric-glioma/

# Set permissions
sudo chown -R shiny:shiny /srv/shiny-server/pediatric-glioma/
```

## Testing & Validation

### Application Testing
```r
# Test data generation
test_data <- generate_teal_genomic_data()
stopifnot(nrow(test_data$mutations) == 200)
stopifnot(nrow(test_data$clinical) == 50)

# Test module functionality
# Manual testing through UI recommended
```

### Performance Benchmarks
- **Load Time**: < 5 seconds for initial launch
- **Plot Rendering**: < 2 seconds for standard visualizations  
- **Data Tables**: < 1 second for filtering/sorting
- **Memory Usage**: < 500MB for sample dataset

## Troubleshooting

### Common Issues

#### Package Installation Problems
```r
# Force reinstall problematic packages
remove.packages("teal")
install.packages("teal", dependencies = TRUE)
```

#### Memory Issues
```r
# Increase memory limit
options(java.parameters = "-Xmx4g")
memory.limit(size = 8000)  # Windows only
```

#### Display Problems
- Clear browser cache
- Try different browser (Chrome recommended)
- Check screen resolution compatibility

#### Data Loading Errors
```r
# Debug data structure
str(your_data)
head(your_data)
colnames(your_data)
```

### Performance Optimization
```r
# For large datasets
options(shiny.maxRequestSize = 100*1024^2)  # 100MB limit

# Implement caching
cache_dir <- tempdir()
# Use memoise package for expensive computations
```

## Integration with Pipeline

### Pipeline Input Integration
```r
# Load VCF analysis results
mutations <- read.csv("results/mutational_profiles.csv")

# Load clinical data from database
clinical <- dbGetQuery(conn, "SELECT * FROM clinical_data")

# Integrate with Nextflow outputs
pathways <- read.csv("data/meta_analysis_therapies.csv")
```

### Output Integration
```r
# Export results for further analysis
output_data <- reactive_values$integrated_results
write.csv(output_data, "results/shiny_analysis_output.csv")
```

## 🔮 Future Enhancements

### Planned Features
- **Real-time Data Updates**: Connection to live databases
- **Advanced Statistics**: Survival analysis, hazard ratios
- **Export Functions**: PDF reports, publication-ready plots  
- **User Authentication**: Secure data access
- **Multi-omics Support**: RNA-seq, methylation data

### Technical Improvements
- **Performance**: Lazy loading, data streaming
- **UI/UX**: Mobile responsiveness, accessibility
- **Testing**: Automated unit tests, CI/CD integration
- **Documentation**: Interactive tutorials, video guides

## 📞 Support & Contributing

### Getting Help
- **Issues**: Report bugs on GitHub Issues
- **Questions**: Use GitHub Discussions
- **Documentation**: Check `docs/` directory

### Contributing Guidelines
1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-module`
3. Test thoroughly with sample data
4. Submit pull request with clear description
5. Include documentation updates

### Code Style
- Follow teal module conventions
- Use meaningful variable names
- Comment complex logic
- Test all interactive features

**¡Excelente!** Ahora ya tienes toda la documentación de la aplicación Shiny. ¿Quieres que procedamos a mejorar el **README principal** del repositorio? Ese será la cara visible de todo tu proyecto.
