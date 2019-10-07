#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn:latest

inputs:
  - id: force
    type: boolean
    default: true
    inputBinding:
      prefix: --force

  - id: genome
    type: string
    default: hg38
    inputBinding:
      prefix: --genome

  - id: intervals
    type: File
    inputBinding:
      prefix: --intervals

  - id: intervalweightfile
    type: [File, "null"]
    inputBinding:
      prefix: --intervalweightfile

  - id: normal
    type: [File, "null"]
    inputBinding:
      prefix: --normal

  - id: normal_panel
    type: [File, "null"]
    inputBinding:
      prefix: --normal_panel

  - id: normaldb
    type: File
    inputBinding:
      prefix: --normaldb

  - id: out
    type: string
    default: .
    inputBinding:
      prefix: --out

  - id: outvcf
    type: boolean
    default: true
    inputBinding:
      prefix: --outvcf

  - id: parallel
    type: boolean
    default: true
    inputBinding:
      prefix: --parallel

  - id: postoptimize
    type: boolean
    default: true
    inputBinding:
      prefix: --postoptimize

  - id: sampleid
    type: string
    inputBinding:
      prefix: --sampleid

  - id: statsfile
    type: [File, "null"]
    inputBinding:
      prefix: --statsfile

  - id: tumor
    type: File
    inputBinding:
      prefix: --tumor

  - id: vcf
    type: File
    inputBinding:
      prefix: --vcf

outputs:
  - id: chromosomes_pdf
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id)_chromosomes.pdf

  - id: csv
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id).csv

  - id: dnacopy_seg
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id)_dnacopy.seg

  - id: genes_csv
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id)_genes.csv

  - id: local_optima_pdf
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id)_local_optima.pdf

  - id: log
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id).log

  - id: loh_csv
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id)_loh.csv

  - id: pdf
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id).pdf

  - id: rds
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id).rds

  - id: segmentation_pdf
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id)_segmentation.pdf

  - id: variants_csv
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id)_variants.csv

  - id: vcf
    type: [File, "null"]
    outputBinding:
      glob: $(inputs.sample_id).vcf

baseCommand: [Rscript, /usr/local/lib/R/site-library/PureCN/extdata/PureCN.R]
