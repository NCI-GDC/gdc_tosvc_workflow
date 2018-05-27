#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  ref_file:
    type: File
    secondaryFiles:
      ".fai"
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
  thread_num:
    type: int

outputs:
  sample_info_file:
    type: File
    outputSource: var_call/sample_info_file
  dnacopy_file:
    type: File
    outputSource: var_call/dnacopy_file
  genes_file:
    type: File
    outputSource: var_call/genes_file
  log_file:
    type: File
    outputSource: var_call/log_file
  loh_file:
    type: File
    outputSource: var_call/loh_file
  info_pdf_file:
    type: File
    outputSource: var_call/info_pdf_file
  rds_file:
    type: File
    outputSource: var_call/rds_file
  segmentation_file:
    type: File
    outputSource: var_call/segmentation_file
  chrome_file:
    type: File
    outputSource: var_call/chrome_file
  local_optima_file:
    type: File
    outputSource: var_call/local_optima_file
  var_csv_file:
    type: File
    outputSource: var_call/var_csv_file
  var_vcf_file:
    type: File
    outputSource: var_call/var_vcf_file

steps:
  interval:
    run: PureCNIntervalFile.cwl
    in:
      ref_file:
        source: ref_file
      capture_file:
        source: capture_file
      map_file:
        source: map_file
      genome:
        source: genome
      out_file:
        source: ref_file
        valueFrom: $(self.nameroot + ".capture_baits_hg38_gcgene.txt")
      export_file:
        source: ref_file
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
      outdir:
        valueFrom: "."
    out: [cov_file, loess_file, loess_png_file, loess_qc_file]

  var_call:
    run: PureCN.cwl
    in:
      sampleid:
        source: tumor_bam_file
        valueFrom: $(self.nameroot.split("_")[0])
      tumor_file:
        source: coverage/cov_file
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
      outinfo:
        valueFrom: "."
    out: [sample_info_file, chrome_file, dnacopy_file, genes_file, local_optima_file, log_file, loh_file, info_pdf_file, rds_file, segmentation_file, var_csv_file, var_vcf_file]
