#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement

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
  - id: purecn_bed
    type: File
    outputSource: purecn_intervals/bed
  - id: purecn_png
    type: File
    outputSource: purecn_intervals/png
  - id: purecn_rds
    type: File
    outputSource: purecn_intervals/rds
  - id: purecn_txt
    type: File
    outputSource: purecn_intervals/txt

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
    scatter: [bam]
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

  - id: listloess
    run: tools/listfiles.cwl
    in:
      - id: files
        source: purecn_coverage/loess_txt
      - id: outname
        valueFrom: purecn_loess.lst
    out:
      - id: output

  - id: tools/purecn_normaldb.cwl
    in:
      - id: inputcoveragefiles
        source: purecn_coverage/loess_txt
      - id: coveragefiles
        source: listloess/output
    out:
      - id: bed
      - id: png
      - id: rds
      - id: txt
