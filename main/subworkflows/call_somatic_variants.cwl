class: Workflow
cwlVersion: v1.0
id: call_somatic_variants
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
doc: |
  call somatic variants

inputs:
  fasta:
    type: File
    secondaryFiles:
      - .fai
  bam:
    type: File
    secondaryFiles:
      - ^.bai
  raw_vcf: File
  capture_kit: File
  bigwig: File
  normaldb: File
  intervalweightfile: File?
  genome: string
  sampleid: string
  thread_num: long
  seed: long
  exclude_chrM: int[]
  mintargetwidth: int?

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

  interval_bed:
    type: File
    outputSource: purecn_interval/bed

  interval_interval:
    type: File
    outputSource: purecn_interval/interval

  coverage_coverage:
    type: File
    outputSource: purecn_coverage/coverage

  coverage_loess_png:
    type: File
    outputSource: purecn_coverage/loess_png

  coverage_loess_qc_txt:
    type: File
    outputSource: purecn_coverage/loess_qc_txt

  coverage_loess_txt:
    type: File
    outputSource: purecn_coverage/loess_txt

steps:
  exclude_baits_chrM:
    run: ../tools/modify_baitsfile.cwl
    scatter: exclude_chrM
    in:
      exclude_chrM: exclude_chrM
      input_baits: capture_kit
    out: [modified_baits]

  determine_baitsfile:
    run: ../tools/determine_baitsfile.cwl
    in:
      origin: capture_kit
      modified: exclude_baits_chrM/modified_baits
    out: [baits_bed]

  purecn_interval:
    run: ../tools/purecn_intervals.cwl
    in:
      fasta: fasta
      infile: determine_baitsfile/baits_bed
      mappability: bigwig
      genome: genome
      mintargetwidth: mintargetwidth
    out: [
      bed,
      interval
    ]

  purecn_coverage:
    run: ../tools/purecn_coverage.cwl
    in:
      bam: bam
      interval: purecn_interval/interval
      threads: thread_num
    out: [
      coverage,
      loess_png,
      loess_qc_txt,
      loess_txt
    ]

  purecn:
    run: ../tools/purecn.cwl
    in:
      sampleid: sampleid
      tumor: purecn_coverage/loess_txt
      raw_vcf: raw_vcf
      intervals: purecn_interval/interval
      normaldb: normaldb
      intervalweightfile: intervalweightfile
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
