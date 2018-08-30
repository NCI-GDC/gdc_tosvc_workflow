#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/purecn:latest
  - class: InlineJavascriptRequirement
successCodes:
  - 0
  - 1

inputs:
  - id: sample_id
    type: string?
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
    type: File
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
      prefix: --intervals
  - id: target_weight_file
    type: File
    inputBinding:
      position: 8
      prefix: --targetweightfile
  - id: seed
    type: int
    default: 123
    inputBinding:
      position: 9
      prefix: --seed
  - id: output_dir
    type: string
    default: "."
    inputBinding:
      position: 10
      prefix: --out

outputs:
  - id: var_vcf_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + ".vcf")
  - id: var_csv_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + "_variants.csv")
  - id: metric_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + ".csv")
  - id: dnacopy_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + "_dnacopy.seg")
  - id: segmentation_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + "_segmentation.pdf")
  - id: loh_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + "_loh.csv")
  - id: chrome_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + "_chromosomes.pdf")
  - id: genes_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + "_genes.csv")
  - id: local_optima_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + "_local_optima.pdf")
  - id: rds_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + ".rds")
  - id: info_pdf_file
    type: File?
    outputBinding:
      glob: $(inputs.sample_id + ".pdf")
  - id: log_file
    type: File
    outputBinding:
      glob: $(inputs.sample_id + ".log")

arguments: ["--outvcf", "--parallel", "--force", "--postoptimize"]