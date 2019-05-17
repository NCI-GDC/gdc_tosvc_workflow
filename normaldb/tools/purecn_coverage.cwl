#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn_coverage:1.11.11

inputs:
  - id: bam
    type:
      type: array
      items: File
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
      prefix: --cpu

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

