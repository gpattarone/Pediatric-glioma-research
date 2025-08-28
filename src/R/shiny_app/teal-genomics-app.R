#Load required libraries
library(teal)
library(teal.data)
library(teal.modules.general)
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(ggplot2)
library(dplyr)
library(visNetwork)
library(shinycssloaders)

# Generate sample genomic data for teal_data
generate_teal_genomic_data <- function() {
  genes <- c(
    "EGFR", "TP53", "PTEN", "IDH1", "ATRX", "CIC", "FUBP1", "PIK3CA",
    "PIK3R1", "NF1", "RB1", "CDKN2A", "MDM2", "CDK4", "PDGFRA", "KIT",
    "BRAF", "H3F3A", "HIST1H3B", "TP73"
  )

  mutations_data <- data.frame(
    USUBJID = rep(sprintf("PAT_%03d", 1:50), each = 4),
    Gene = sample(genes, 200, replace = TRUE),
    Variant_Type = sample(c("CNV", "SNV", "Indel"), 200, replace = TRUE, prob = c(0.4, 0.4, 0.2)),
    Mutation_Count = sample(0:300, 200, replace = TRUE),
    VAF = runif(200, 0.05, 0.95),
    Clinical_Significance = sample(c("Pathogenic", "Likely_Pathogenic", "VUS", "Benign"), 200, replace = TRUE),
    stringsAsFactors = FALSE
  )

  clinical_data <- data.frame(
    USUBJID = sprintf("PAT_%03d", 1:50),
    AGE = sample(5:18, 50, replace = TRUE),
    SEX = sample(c("M", "F"), 50, replace = TRUE),
    TUMOR_GRADE = sample(c("Grade I", "Grade II", "Grade III", "Grade IV"), 50, replace = TRUE),
    SURVIVAL_MONTHS = sample(6:120, 50, replace = TRUE),
    TREATMENT_RESPONSE = sample(c("Complete Response", "Partial Response", "Stable Disease", "Progressive Disease"), 50, replace = TRUE),
    IDH_STATUS = sample(c("IDH-wildtype", "IDH-mutant"), 50, replace = TRUE, prob = c(0.7, 0.3)),
    MGMT_STATUS = sample(c("Methylated", "Unmethylated"), 50, replace = TRUE),
    stringsAsFactors = FALSE
  )

  pathway_data <- data.frame(
    Pathway = c(
      "IDH1/IDH2 Mutations", "CDKN2A/B Loss", "EGFR Amplification",
      "MGMT Methylation", "TERT Mutations", "5p21.3 Loss and CDKN2A Deletion"
    ),
    Key_Finding = c(
      "Increase in D-2-hydroxyglutarate (D2HG), epigenetic dysregulation, tumor progression",
      "Associated with poor prognosis and therapy resistance",
      "MAPK pathway activation, tumor proliferation",
      "Predicts better response to temozolomide",
      "Associated with lower survival in IDH-wildtype gliomas",
      "High-risk marker in IDH-mutant gliomas"
    ),
    Therapeutic_Target = c(
      "Low methylation and chromatin remodeling (e.g., SOX17, FOXM2) may drive resistance",
      "CDK4/6 inhibitors (Palbociclib, Abemaciclib)",
      "EGFR inhibitors (Cetuximab, Erlotinib, GCH18), BRAF inhibitors (Vemurafenib, Dabrafenib), MEK inhibitors (Trametinib)",
      "Temozolomide",
      "TERT inhibitor evaluation in preclinical studies",
      "CDK4/6 targeted therapies"
    ),
    stringsAsFactors = FALSE
  )

  list(
    mutations = mutations_data,
    clinical = clinical_data,
    pathways = pathway_data
  )
}

tm_mutational_profile <- function(
  label = "Mutational Profile",
  mutations_data = "mutations",
  clinical_data = "clinical"
) {
  module(
    label = label,
    server = function(id, data) {
      moduleServer(id, function(input, output, session) {
        output$mutational_plot <- renderPlotly({
          req(data())
          mutations <- data()[[mutations_data]]

          plot_data <- mutations %>%
            group_by(Gene, Variant_Type) %>%
            summarise(Total_Count = sum(Mutation_Count, na.rm = TRUE), .groups = "drop")

          p <- ggplot(plot_data, aes(x = Gene, y = Total_Count, fill = Variant_Type)) +
            geom_bar(stat = "identity", position = "stack") +
            scale_fill_manual(values = c(CNV = "#3498db", SNV = "#e74c3c", Indel = "#f39c12")) +
            labs(
              title = "Mutational Profile of Pediatric Gliomas",
              x = "Genes",
              y = "Mutation Count",
              fill = "Variant Type"
            ) +
            theme_minimal() +
            theme(
              axis.text.x = element_text(angle = 45, hjust = 1),
              plot.title = element_text(size = 14, hjust = 0.5)
            )

          ggplotly(p, tooltip = c("x", "y", "fill"))
        })

        output$clinical_summary <- renderDT({
          req(data())
          clinical <- data()[[clinical_data]]

          summary_table <- clinical %>%
            group_by(TUMOR_GRADE, IDH_STATUS) %>%
            summarise(
              Patients = n(),
              Avg_Age = round(mean(AGE, na.rm = TRUE), 1),
              Avg_Survival = round(mean(SURVIVAL_MONTHS, na.rm = TRUE), 1),
              .groups = "drop"
            )

          datatable(
            summary_table,
            options = list(pageLength = 10, scrollX = TRUE),
            caption = "Clinical Summary by Tumor Grade and IDH Status"
          )
        })
      })
    },

    ui = function(id) {
      ns <- NS(id)

      fluidPage(
        tags$head(
          tags$style(HTML("
            .findings-box {
              background: #fff3cd;
              border: 1px solid #ffeaa7;
              padding: 15px;
              border-radius: 5px;
              margin: 10px 0;
            }
            .discovery-box {
              background: #e8f4fd;
              border-left: 4px solid #3498db;
              padding: 15px;
              margin: 10px 0;
              border-radius: 5px;
            }
          "))
        ),

        h2("Pediatric Glioma Mutational Profile Analysis"),

        fluidRow(
          column(
            3,
            div(
              class = "discovery-box",
              h4("Discovery", style = "color: #27ae60;"),
              tags$ul(
                tags$li(strong("Analysis Type:"), "Mutational Profile Analysis in Pediatric Glioma"),
                tags$li(strong("Data:"), "Somatic mutations derived from VCFs"),
                tags$li(strong("Purpose:"), "Identify and analyze key genetic alterations in pediatric gliomas")
              )
            )
          ),
          column(
            9,
            withSpinner(plotlyOutput(ns("mutational_plot"), height = "400px"))
          )
        ),

        fluidRow(
          column(
            6,
            div(
              class = "findings-box",
              h4("Key Findings"),
              tags$ul(
                tags$li(strong("Genetic Variation in Groups:"), "Key mutations in TP53, TERT, and EGFR drive tumor progression and treatment resistance in pediatric gliomas."),
                tags$li(strong("TP53:"), "Essential for tumor suppression, while TERT mutations maintain proliferative capacity."),
                tags$li(strong("High mutation frequencies:"), "IDH1/IDH2 and CDKN2A/B highlight their role in metabolic reprogramming and cell cycle disruption.")
              )
            )
          ),
          column(
            6,
            withSpinner(DT::dataTableOutput(ns("clinical_summary")))
          )
        )
      )
    },

    datanames = c(mutations_data, clinical_data)
  )
}

# Teal module: Therapy Meta-Analysis
tm_therapy_analysis <- function(
  label = "Therapy Meta-Analysis",
  mutations_data = "mutations",
  pathways_data = "pathways"
) {
  module(
    label = label,
    server = function(id, data) {
      moduleServer(id, function(input, output, session) {

        output$heatmap_plot <- renderPlotly({
          req(data())
          genes <- c("TP53", "EGFR", "IDH1", "ATRX", "CDKN2A", "PTEN", "RB1", "MDM2", "CDK4", "BRAF")
          set.seed(123)
          cor_matrix <- matrix(runif(100, -1, 1), nrow = 10, ncol = 10)
          diag(cor_matrix) <- 1
          rownames(cor_matrix) <- genes
          colnames(cor_matrix) <- genes

          cor_long <- expand.grid(Gene1 = genes, Gene2 = genes)
          cor_long$Correlation <- as.vector(cor_matrix)

          p <- ggplot(cor_long, aes(x = Gene1, y = Gene2, fill = Correlation)) +
            geom_tile() +
            scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
            labs(title = "Gene Interaction Correlation Matrix") +
            theme_minimal() +
            theme(axis.text.x = element_text(angle = 45, hjust = 1))

          ggplotly(p)
        })

        output$network_plot <- renderVisNetwork({
          req(data())
          nodes <- data.frame(
            id = 1:12,
            label = c("TP53", "EGFR", "IDH1", "ATRX", "CDKN2A", "PTEN", "RB1", "MDM2", "CDK4", "PI3K", "MAPK", "Cell Cycle"),
            group = c(rep("Tumor Suppressor", 4), rep("Oncogene", 4), rep("Pathway", 4)),
            size = c(30, 25, 20, 15, 25, 20, 15, 10, 15, 20, 25, 30)
          )

          edges <- data.frame(
            from = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
            to = c(8, 11, 12, 12, 9, 10, 12, 12, 12, 11, 12),
            width = c(3, 4, 2, 2, 3, 3, 2, 2, 2, 3, 4)
          )

          visNetwork(nodes, edges) %>%
            visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
            visGroups(groupname = "Tumor Suppressor", color = "lightblue") %>%
            visGroups(groupname = "Oncogene", color = "lightcoral") %>%
            visGroups(groupname = "Pathway", color = "lightgreen") %>%
            visLegend() %>%
            visInteraction(navigationButtons = TRUE)
        })

        output$pathway_table <- renderDT({
          req(data())
          pathways <- data()[[pathways_data]]
          datatable(
            pathways,
            options = list(pageLength = 6, scrollX = TRUE),
            caption = "Therapeutic Pathways and Targets"
          )
        })
      })
    },

    ui = function(id) {
      ns <- NS(id)
      fluidPage(
        h2("Meta-analysis of Existing Treatments and Precision Oncology Therapeutic Strategy Evaluation"),

        fluidRow(
          column(
            3,
            div(
              class = "discovery-box",
              h4("Validation", style = "color: #9b59b6;"),
              tags$ul(
                tags$li(strong("Analysis Type:"), "Network and Pathway Signaling Analysis"),
                tags$li(strong("Data:"), "Mutational Profile"),
                tags$li(strong("Purpose:"), "Evaluate influence of specific gene patterns in Glioma")
              )
            )
          ),
          column(
            9,
            fluidRow(
              column(6, withSpinner(plotlyOutput(ns("heatmap_plot"), height = "350px"))),
              column(6, withSpinner(visNetworkOutput(ns("network_plot"), height = "350px")))
            )
          )
        ),

        fluidRow(
          column(12, withSpinner(DT::dataTableOutput(ns("pathway_table"))))
        ),

        fluidRow(
          column(
            12,
            div(
              class = "findings-box",
              h4("Clinical Observations"),
              tags$ul(
                tags$li(strong("Key Therapeutic Target:"), "IDH1/IDH2 alterations represent key therapeutic targets for low-grade pediatric gliomas, treatable with Ivosidenib and Enasidenib inhibitors."),
                tags$li(strong("Promising Therapeutic Advance:"), "EGFR amplification and BRAF mutations highlight targeted therapies like Cetuximab, Vemurafenib, and Trametinib, currently under clinical evaluation.")
              )
            )
          )
        )
      )
    },

    datanames = c(mutations_data, pathways_data)
  )
}

# Teal module: Integration Analysis
tm_integration_analysis <- function(
  label = "Integration Analysis",
  mutations_data = "mutations",
  clinical_data = "clinical",
  pathways_data = "pathways"
) {
  module(
    label = label,
    server = function(id, data) {
      moduleServer(id, function(input, output, session) {

        output$integration_summary <- renderDT({
          req(data())
          mutations <- data()[[mutations_data]]
          clinical <- data()[[clinical_data]]

          integrated_data <- mutations %>%
            left_join(clinical, by = "USUBJID") %>%
            group_by(Gene, TUMOR_GRADE, IDH_STATUS) %>%
            summarise(
              Mutation_Frequency = n(),
              Avg_VAF = round(mean(VAF, na.rm = TRUE), 3),
              Pathogenic_Variants = sum(Clinical_Significance %in% c("Pathogenic", "Likely_Pathogenic")),
              Avg_Survival = round(mean(SURVIVAL_MONTHS, na.rm = TRUE), 1),
              .groups = "drop"
            ) %>%
            arrange(desc(Mutation_Frequency))

          datatable(
            integrated_data,
            options = list(pageLength = 15, scrollX = TRUE),
            caption = "Integrated Genomic and Clinical Analysis"
          ) %>%
            formatStyle(
              "Pathogenic_Variants",
              backgroundColor = styleInterval(c(1, 3, 5), c("white", "#fff3cd", "#ffeaa7", "#ffcccc"))
            )
        })

        output$biomarker_plot <- renderPlotly({
          req(data())
          mutations <- data()[[mutations_data]]
          clinical <- data()[[clinical_data]]

          survival_data <- clinical %>%
            left_join(
              mutations %>%
                filter(Gene %in% c("TP53", "IDH1", "EGFR", "CDKN2A")) %>%
                group_by(USUBJID, Gene) %>%
                summarise(Has_Mutation = any(Clinical_Significance %in% c("Pathogenic", "Likely_Pathogenic")), .groups = "drop"),
              by = "USUBJID"
            ) %>%
            filter(!is.na(Gene)) %>%
            mutate(Has_Mutation = ifelse(is.na(Has_Mutation), FALSE, Has_Mutation))

          p <- ggplot(survival_data, aes(x = Gene, y = SURVIVAL_MONTHS, fill = Has_Mutation)) +
            geom_boxplot() +
            scale_fill_manual(values = c("FALSE" = "#95a5a6", "TRUE" = "#e74c3c"), labels = c("Wild Type", "Mutated")) +
            labs(
              title = "Survival by Mutation Status",
              x = "Gene",
              y = "Survival (Months)",
              fill = "Mutation Status"
            ) +
            theme_minimal()

          ggplotly(p)
        })
      })
    },

    ui = function(id) {
      ns <- NS(id)
      fluidPage(
        h2("Pathway/Mechanism Integration Analysis"),

        fluidRow(
          column(
            12,
            div(
              class = "findings-box",
              h4("Integration Summary"),
              p("This comprehensive analysis integrates mutational profiles with clinical outcomes, providing a roadmap for precision oncology in pediatric gliomas. The pathway analysis reveals key therapeutic vulnerabilities and guides treatment selection based on individual molecular profiles.")
            )
          )
        ),

        fluidRow(
          column(6, withSpinner(DT::dataTableOutput(ns("integration_summary")))),
          column(6, withSpinner(plotlyOutput(ns("biomarker_plot"), height = "400px")))
        )
      )
    },

    datanames = c(mutations_data, clinical_data, pathways_data)
  )
}

# Create the teal application
create_genomic_pipeline_app <- function() {
  genomic_data <- generate_teal_genomic_data()

  app_data <- teal_data(
    mutations = genomic_data$mutations,
    clinical  = genomic_data$clinical,
    pathways  = genomic_data$pathways
  )

  init(
    data = app_data,
    modules = modules(
      tm_front_page(
        label = "Pipeline Overview",
        header_text = c(
          "Genomic Analysis Pipeline" = 
            "Comprehensive analysis workflow for pediatric glioma genomic profiling"
        ),
        # FIX: Pass actual data.frames, not strings
        tables = list(
          mutations = genomic_data$mutations,
          clinical  = genomic_data$clinical,
          pathways  = genomic_data$pathways
        )
      ),
      tm_mutational_profile(
        label = "Mutational Profile",
        mutations_data = "mutations",
        clinical_data  = "clinical"
      ),
      tm_therapy_analysis(
        label = "Therapy Meta-Analysis",
        mutations_data = "mutations",
        pathways_data  = "pathways"
      ),
      tm_integration_analysis(
        label = "Integration",
        mutations_data = "mutations",
        clinical_data  = "clinical",
        pathways_data  = "pathways"
      )
    ),
    title  = "Genomic Analysis Pipeline for Pediatric Gliomas",
    header = tags$h1("Pediatric Glioma Genomic Analysis", 
                     style = "color: #2c3e50;"),
    footer = tags$p("Powered by teal framework", 
                    style = "text-align: center; color: #7f8c8d;")
  )
}

# Run the application
app <- create_genomic_pipeline_app()
shinyApp(app$ui, app$server)
