#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn:develop

inputs:
  - id: bam
    type: File
    inputBinding:
      prefix: --bam
    secondaryFiles:
      - ^.bai

  - id: force
    type: boolean
    default: true
    inputBinding:
      prefix: --force

  - id: interval
    type: File
    inputBinding:
      prefix: --interval

  - id: outdir
    type: string
    default: "."
    inputBinding:
      prefix: --outdir

  - id: threads
    type: long
    default: 24
    inputBinding:
      prefix: --cores

outputs:
  - id: coverage
    type: File
    outputBinding:
      glob: "*coverage.txt"

  - id: loess_txt
    type: File
    outputBinding:
      glob: "*coverage_loess.txt"

  - id: loess_png
    type: File
    outputBinding:
      glob: "*coverage_loess.png"

  - id: loess_qc_txt
    type: File
    outputBinding:
      glob: "*coverage_loess_qc.txt"

baseCommand: [Rscript, /usr/local/lib/R/site-library/PureCN/extdata/Coverage.R]
