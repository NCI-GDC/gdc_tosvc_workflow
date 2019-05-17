#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
    
inputs:
  - id: bams
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
  - id: bed
    type: File
    secondaryFiles:
      - .tbi
  - id: fasta
    type: File
    secondaryFiles:
      - .fai
  - id: bigwig
    type: File

outputs:
  - id: output
    type: File
    outputSource: purecn_intervals/output
  
steps:
  - id: purecn_intervals
    run: tools/purecn_intervals.cwl
    in:
      - id: bed
        source: bed
      - id: fasta
        source: fasta
      - id: bigwig
        source: bigwig
    out:
      - id: output
  
  - id: purecn_coverage
    run: tools/purecn_coverage.cwl
    in:
      - id: bam
        source: bams
      - id: interval
        source: purecn_intervals/output
    out:
      - id: coverage
      - id: loess_txt
      - id: loess_png
      - id: loess_qc_txt
