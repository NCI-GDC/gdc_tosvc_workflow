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
  - id: vcf
    type: File
  - id: capture_kit
    type: File
  - id: bigwig
    type: File
  - id: normaldb
    type: File
  # - id: intervalweightfile
  #   type: File
  - id: genome
    type: string
  - id: sampleid
    type: string
  - id: thread_num
    type: long

outputs:
  []
  # - id: var_vcf_file
  #   type: [File, "null"]
  #   outputSource: var_call/var_vcf_file

  # - id: var_csv_file
  #   type: [File, "null"]
  #   outputSource: var_call/var_csv_file

  # - id: metric_file
  #   type: [File, "null"]
  #   outputSource: var_call/metric_file

  # - id: dnacopy_file
  #   type: [File, "null"]
  #   outputSource: var_call/dnacopy_file

  # - id: segmentation_file
  #   type: [File, "null"]
  #   outputSource: var_call/segmentation_file

  # - id: loh_file
  #   type: [File, "null"]
  #   outputSource: var_call/loh_file

  # - id: chrome_file
  #   type: [File, "null"]
  #   outputSource: var_call/chrome_file

  # - id: genes_file
  #   type: [File, "null"]
  #   outputSource: var_call/genes_file

  # - id: local_optima_file
  #   type: [File, "null"]
  #   outputSource: var_call/local_optima_file

  # - id: rds_file
  #   type: [File, "null"]
  #   outputSource: var_call/rds_file

  # - id: info_pdf_file
  #   type: [File, "null"]
  #   outputSource: var_call/info_pdf_file

  # - id: log_file
  #   type: [File, "null"]
  #   outputSource: var_call/log_file

  # - id: interval_file
  #   type: File
  #   outputSource: interval/interval_file

  # - id: interval_bed_file
  #   type: File
  #   outputSource: interval/interval_bed_file

  # - id: cov_file
  #   type: File
  #   outputSource: coverage/cov_file

  # - id: loess_file
  #   type: File
  #   outputSource: coverage/loess_file

  # - id: loess_png_file
  #   type: File
  #   outputSource: coverage/loess_png_file

  # - id: loess_qc_file
  #   type: File
  #   outputSource: coverage/loess_qc_file

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
      - id: interval
      - id: bed

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
      - id: loess_txt
      - id: loess_png
      - id: loess_qc_txt

  - id: purecn
    run: tools/purecn.cwl
    in:
      - id: coveragefiles
        source: purecn_coverage/coverage
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
      - id: vcf
        source: vcf
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
      - id: vcf
