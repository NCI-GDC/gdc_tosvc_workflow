#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn:1.14.3

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

  - id: cores
    type: long
    inputBinding:
      prefix: --cores

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
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_chromosomes.pdf")

  - id: csv
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + ".csv")

  - id: dnacopy_seg
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_dnacopy.seg")

  - id: genes_csv
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_genes.csv")

  - id: local_optima_pdf
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_local_optima.pdf")

  - id: log
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + ".log")

  - id: loh_csv
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_loh.csv")

  - id: pdf
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + ".pdf")

  - id: rds
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + ".rds")

  - id: segmentation_pdf
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_segmentation.pdf")

  - id: variants_csv
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_variants.csv")

  - id: vcf
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + ".vcf")

baseCommand: [Rscript, /usr/local/lib/R/site-library/PureCN/extdata/PureCN.R]
