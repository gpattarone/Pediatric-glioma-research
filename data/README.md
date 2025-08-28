# Data Directory

This directory contains sample data, database schemas, and configuration files used in the pediatric glioma research pipeline.

## Files

### `meta_analysis_therapies.csv`
- **Purpose**: Meta-analysis data of therapeutic approaches for pediatric gliomas
- **Format**: CSV with columns for Therapy, Target_Group, Evidence, Comments
- **Usage**: Input for `load_meta_analysis.nf` workflow
- **Description**: Comprehensive therapy database for research analysis

### `genetic_alterations.json`
- **Purpose**: JSON database of genetic alterations in pediatric glioma samples
- **Format**: Structured JSON with mutation data
- **Usage**: Reference data for mutational profile analysis
- **Description**: Catalogued genetic variants and alterations

### `TF_BD.sql`
- **Purpose**: Database schema definitions for various research domains
- **Features**:
  - Multiple table schemas (Library, Medical, Business, Tourism, Sports)
  - Complex relational structures with foreign keys
  - Sample queries for data analysis
- **Tables Include**:
  - **Library System**: Alumno, Libro, Prestamo, Revista, Articulo
  - **Medical System**: Doctor, Practica, PracticaRealizada, Cliente, Accidente
  - **Business System**: Proveedor, Ingrediente, Producto, Proyecto, Gerencia
  - **Tourism System**: Guia, Tour, Pasajero, TourPasajero
  - **Sports System**: Equipo, Partido
- **Sample Queries**: 10+ complex SQL queries demonstrating various analytical approaches

## Sample Data Structure

### Expected CSV Format (meta_analysis_therapies.csv)
```csv
Therapy,Target_Group,Evidence,Comments
Temozolomide,Pediatric HGG,Phase II,Standard chemotherapy
Bevacizumab,Recurrent tumors,Phase I/II,Anti-angiogenic therapy
```

### Expected JSON Format (genetic_alterations.json)
```json
{
  "mutations": [
    {
      "gene": "TP53",
      "variant": "p.R273H",
      "frequency": 0.12,
      "significance": "pathogenic"
    }
  ]
}
```

## Data Requirements

### For SRA Analysis
- **Input**: Text file with SRA accession numbers (one per line)
- **Example**: 
  ```
  SRR123456
  SRR789012
  SRR345678
  ```

### For Variant Analysis
- **Input**: BAM files from RNA-seq or WGS data
- **Format**: Sorted and indexed BAM files
- **Reference**: Human genome reference (GRCh38/hg38)

### For Database Loading
- **PostgreSQL**: Compatible with schemas in `TF_BD.sql`
- **CSV Files**: UTF-8 encoded, comma-separated
- **JSON Files**: Valid JSON format with proper structure

## Usage Notes

- Ensure data files are properly formatted before pipeline execution
- Check file permissions and accessibility
- Validate CSV headers match expected column names
- JSON files should be validated before processing
- SQL schemas can be adapted for specific research needs

## Data Privacy

- All sample data should be de-identified
- Follow institutional guidelines for genomic data handling
- Ensure compliance with data sharing agreements
- Remove personal identifiers from clinical data

## File Formats Supported

- **CSV**: Comma-separated values (UTF-8)
- **JSON**: JavaScript Object Notation
- **SQL**: PostgreSQL compatible syntax
- **TXT**: Plain text files (accession lists)
- **VCF**: Variant Call Format (from upstream analysis)
- **BAM**: Binary Alignment Map (from alignment tools)
```


**¿Ya creaste el README de data?** Siguiente paso será crear la carpeta `docs/` con documentación general del proyecto.
