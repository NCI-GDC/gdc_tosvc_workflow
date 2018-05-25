#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/purecn
  - class: InlineJavascriptRequirement

inputs:
  - id: sampleid
    type: string
    inputBinding:
      position: 1
      prefix: --sampleid
  - id: tumor_file
    type: File
    inputBinding:
      position: 2
      prefix: --tumor
  - id: input_vcf_file
    type: File
    inputBinding:
      position: 3
      prefix: --vcf
  - id: normaldb_file
    type: File?
    inputBinding:
      position: 4
      prefix: --normaldb
  - id: stats_file
    type: File?
    inputBinding:
      position: 5
      prefix: --statsfile
  - id: genome
    type: string
    inputBinding:
      position: 6
      prefix: --genome
  - id: interval_file
    type: File
    inputBinding:
      position: 7
      prefix: --interval
  - id: target_weight_file
    type: File
    inputBinding:
      position: 8
      prefix: --targetweightfile
  - id: outinfo
    type: string
    inputBinding:
      position: 9
      prefix: --out

outputs:
  - id: sample_info_file
    type: File
    outputBinding:
      glob: "*.csv"
  - id: dnacopy_file
    type: File
    outputBinding:
      glob: "*_dnacopy.seg"
  - id: genes_file
    type: File
    outputBinding:
      glob: "*_genes.csv"
  - id: local_optima_file
    type: File
    outputBinding:
      glob: "*_local_optima.pdf"
  - id: log_file
    type: File
    outputBinding:
      glob: "*.log"
  - id: loh_file
    type: File
    outputBinding:
      glob: "*_loh.csv"
  - id: info_pdf_file
    type: File
    outputBinding:
      glob: "*.pdf"
  - id: rds_file
    type: File
    outputBinding:
      glob: "*.rds"
  - id: segmentation_file
    type: File
    outputBinding:
      glob: "*_segmentation.pdf"
  - id: var_csv_file
    type: File
    outputBinding:
      glob: "*_variants.csv"
  - id: var_vcf_file
    type: File
    outputBinding:
      glob: "*.vcf"

arguments: ["--outvcf", "--parallel", "--force", "--postoptimize"]