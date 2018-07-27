#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  fa_file:
    type: File
  fai_file:
    type: File
  tumor_bam_file:
    type: File
  tumor_bai_file:
    type: File
  input_vcf_file:
    type: File
  capture_file:
    type: File
  map_file:
    type: File
  normaldb_file:
    type: File
  target_weight_file:
    type: File
  genome:
    type: string
  sample_id:
    type: string
  thread_num:
    type: int

outputs:
  var_vcf_file:
    type: File
    outputSource: var_call/var_vcf_file
  var_csv_file:
    type: File
    outputSource: var_call/var_csv_file
  metric_file:
    type: File
    outputSource: var_call/metric_file
  dnacopy_file:
    type: File
    outputSource: var_call/dnacopy_file
  segmentation_file:
    type: File
    outputSource: var_call/segmentation_file
  loh_file:
    type: File
    outputSource: var_call/loh_file
  chrome_file:
    type: File
    outputSource: var_call/chrome_file
  genes_file:
    type: File
    outputSource: var_call/genes_file
  local_optima_file:
    type: File
    outputSource: var_call/local_optima_file
  rds_file:
    type: File
    outputSource: var_call/rds_file
  info_pdf_file:
    type: File
    outputSource: var_call/info_pdf_file
  log_file:
    type: File
    outputSource: var_call/log_file
  interval_file:
    type: File
    outputSource: interval/interval_file
  interval_bed_file:
    type: File
    outputSource: interval/interval_bed_file
  cov_file:
    type: File
    outputSource: coverage/cov_file
  loess_file:
    type: File
    outputSource: coverage/loess_file
  loess_png_file:
    type: File
    outputSource: coverage/loess_png_file
  loess_qc_file:
    type: File
    outputSource: coverage/loess_qc_file

steps:
  interval:
    run: PureCNIntervalFile.cwl
    in:
      fa_file:
        source: fa_file
      fai_file:
        source: fai_file
      capture_file:
        source: capture_file
      map_file:
        source: map_file
      genome:
        source: genome
      out_file:
        source: fa_file
        valueFrom: $(self.nameroot + ".capture_baits_hg38_gcgene.txt")
      export_file:
        source: fa_file
        valueFrom: $(self.nameroot + ".capture_baits_optimized_hg38.bed")
    out: [interval_file, interval_bed_file]

  coverage:
    run: PureCNCoverage.cwl
    in:
      bam_file:
        source: tumor_bam_file
      bai_file:
        source: tumor_bai_file
      interval_file:
        source: interval/interval_file
      thread_num:
        source: thread_num
    out: [cov_file, loess_file, loess_png_file, loess_qc_file]

  var_call:
    run: PureCN.cwl
    in:
      sample_id:
        source: sample_id
      tumor_file:
        source: coverage/loess_file
      input_vcf_file:
        source: input_vcf_file
      interval_file:
        source: interval/interval_file
      normaldb_file:
        source: normaldb_file
      target_weight_file:
        source: target_weight_file
      genome:
        source: genome
    out: [var_vcf_file, var_csv_file, metric_file, dnacopy_file, segmentation_file, loh_file, chrome_file, genes_file, local_optima_file, rds_file, info_pdf_file, log_file]
