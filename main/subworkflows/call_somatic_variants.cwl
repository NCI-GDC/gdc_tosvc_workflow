#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  - id: fasta
    type: File
    secondaryFiles:
      - .fai
  - id: bam
    type: File
    secondaryFiles:
      - ^.bai
  - id: raw_vcf
    type: File
  - id: capture_kit
    type: File
  - id: bigwig
    type: File
  - id: normaldb
    type: File
  - id: intervalweightfile
    type: File
  - id: genome
    type: string
  - id: sampleid
    type: string
  - id: thread_num
    type: long
  - id: seed
    type: long

outputs:
  - id: chromosomes_pdf
    type: [File, "null"]
    outputSource: purecn/chromosomes_pdf

  - id: csv
    type: [File, "null"]
    outputSource: purecn/csv

  - id: dnacopy_seg
    type: [File, "null"]
    outputSource: purecn/dnacopy_seg

  - id: genes_csv
    type: [File, "null"]
    outputSource: purecn/genes_csv

  - id: local_optima_pdf
    type: [File, "null"]
    outputSource: purecn/local_optima_pdf

  - id: log
    type: [File, "null"]
    outputSource: purecn/log

  - id: loh_csv
    type: [File, "null"]
    outputSource: purecn/loh_csv

  - id: pdf
    type: [File, "null"]
    outputSource: purecn/pdf

  - id: rds
    type: [File, "null"]
    outputSource: purecn/rds

  - id: segmentation_pdf
    type: [File, "null"]
    outputSource: purecn/segmentation_pdf

  - id: variants_csv
    type: [File, "null"]
    outputSource: purecn/variants_csv

  - id: purecn_vcf
    type: [File, "null"]
    outputSource: purecn/out_vcf

  - id: interval_bed
    type: File
    outputSource: purecn_interval/bed

  - id: interval_interval
    type: File
    outputSource: purecn_interval/interval

  - id: coverage_coverage
    type: File
    outputSource: purecn_coverage/coverage

  - id: coverage_loess_png
    type: File
    outputSource: purecn_coverage/loess_png

  - id: coverage_loess_qc_txt
    type: File
    outputSource: purecn_coverage/loess_qc_txt

  - id: coverage_loess_txt
    type: File
    outputSource: purecn_coverage/loess_txt

steps:
  - id: purecn_interval
    run: tools/purecn_intervals.cwl
    in:
      - id: fasta
        source: fasta
      - id: infile
        source: capture_kit
      - id: mappability
        source: bigwig
      - id: genome
        source: genome
    out:
      - id: bed
      - id: interval

  - id: purecn_coverage
    run: tools/purecn_coverage.cwl
    in:
      - id: bam
        source: bam
      - id: interval
        source: purecn_interval/interval
      - id: threads
        source: thread_num
    out:
      - id: coverage
      - id: loess_png
      - id: loess_qc_txt
      - id: loess_txt

  - id: purecn
    run: tools/purecn.cwl
    in:
      - id: genome
        source: genome
      - id: intervals
        source: purecn_interval/interval
      - id: normaldb
        source: normaldb
      - id: tumor
        source: purecn_coverage/loess_txt
      - id: sampleid
        source: sampleid
      - id: raw_vcf
        source: raw_vcf
      - id: cores
        source: thread_num
      - id: seed
        source: seed
    out:
      - id: chromosomes_pdf
      - id: csv
      - id: dnacopy_seg
      - id: genes_csv
      - id: local_optima_pdf
      - id: log
      - id: loh_csv
      - id: pdf
      - id: rds
      - id: segmentation_pdf
      - id: variants_csv
      - id: out_vcf
