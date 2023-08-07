class: Workflow
cwlVersion: v1.0
id: run_purecn
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
doc: |
  run purecn

inputs:
  bam:
    type: File
    secondaryFiles:
      - ^.bai
  raw_vcf: File
  capture_interval: File
  normaldb: File
  genome: string
  sampleid: string
  thread_num: long
  seed: long
  wgs: boolean
  chunks: long

outputs:
  chromosomes_pdf:
    type: File?
    outputSource: purecn/chromosomes_pdf

  csv:
    type: File?
    outputSource: purecn/csv

  dnacopy_seg:
    type: File?
    outputSource: purecn/dnacopy_seg

  genes_csv:
    type: File?
    outputSource: purecn/genes_csv

  local_optima_pdf:
    type: File?
    outputSource: purecn/local_optima_pdf

  log:
    type: File?
    outputSource: purecn/log

  loh_csv:
    type: File?
    outputSource: purecn/loh_csv

  pdf:
    type: File?
    outputSource: purecn/pdf

  rds:
    type: File?
    outputSource: purecn/rds

  segmentation_pdf:
    type: File?
    outputSource: purecn/segmentation_pdf

  variants_csv:
    type: File?
    outputSource: purecn/variants_csv

  purecn_vcf:
    type: File?
    outputSource: purecn/out_vcf

  coverage_coverage:
    type: File
    outputSource: determine_coverage_file/purecn_coverage

  coverage_loess_png:
    type: File?
    outputSource: purecn_coverage/loess_png

  coverage_loess_qc_txt:
    type: File?
    outputSource: purecn_coverage/loess_qc_txt

  coverage_loess_txt:
    type: File?
    outputSource: purecn_coverage/loess_txt

steps:
  purecn_coverage:
    run: ../tools/purecn_coverage.cwl
    in:
      bam: bam
      interval: capture_interval
      threads: thread_num
      chunks: chunks
      wgs: wgs
    out: [
      coverage,
      loess_png,
      loess_qc_txt,
      loess_txt
    ]

  determine_coverage_file:
    run: ../tools/determine_coverage_file.cwl
    in:
      coverage: purecn_coverage/coverage
      coverage_loess: purecn_coverage/loess_txt
    out: [purecn_coverage]

  purecn:
    run: ../tools/purecn.cwl
    in:
      sampleid: sampleid
      tumor: determine_coverage_file/purecn_coverage
      raw_vcf: raw_vcf
      intervals: capture_interval
      normaldb: normaldb
      genome: genome
      cores: thread_num
      seed: seed
    out: [
      chromosomes_pdf,
      csv,
      dnacopy_seg,
      genes_csv,
      local_optima_pdf,
      log,
      loh_csv,
      pdf,
      rds,
      segmentation_pdf,
      variants_csv,
      out_vcf
    ]
