#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  ref_file:
    type: File
    secondaryFiles:
      ".fai"
  ref_version:
    type: string
  thread_num:
    type: int
  gem_index_file:
      type: File
  gem_max_mismatch:
    type: int
    default: 2
  gem_max_edit:
    type: int
    default: 2
  tumor_bam_file:
    type: File
    secondaryFiles:
      - '.bai'
  tumor_bai_file:
    type: File
  input_vcf_file:
    type: File
  capture_file:
    type: File
  normaldb_file:
    type: File
  target_weight_file:
    type: File

outputs:
  sample_info_file:
    type: File
    outputSource: call_variants/sample_info_file
  dnacopy_file:
    type: File
    outputSource: call_variants/dnacopy_file
  genes_file:
    type: File
    outputSource: call_variants/genes_file
  log_file:
    type: File
    outputSource: call_variants/log_file
  loh_file:
    type: File
    outputSource: call_variants/loh_file
  info_pdf_file:
    type: File
    outputSource: call_variants/info_pdf_file
  rds_file:
    type: File
    outputSource: call_variants/rds_file
  segmentation_file:
    type: File
    outputSource: call_variants/segmentation_file
  chrome_file:
    type: File
    outputSource: call_variants/chrome_file
  local_optima_file:
    type: File
    outputSource: call_variants/local_optima_file
  var_csv_file:
    type: File
    outputSource: call_variants/var_csv_file
  var_vcf_file:
    type: File
    outputSource: call_variants/var_vcf_file

  interval_file:
    type: File
    outputSource: call_variants/interval_file
  interval_bed_file:
    type: File
    outputSource: call_variants/interval_bed_file
  cov_file:
    type: File
    outputSource: call_variants/cov_file
  loess_file:
    type: File
    outputSource: call_variants/loess_file
  loess_png_file:
    type: File
    outputSource: call_variants/loess_png_file
  loess_qc_file:
    type: File
    outputSource: call_variants/loess_qc_file

  bigwig_file:
    type: File
    outputSource: gen_track_data/bigwig_file
  extracted_wig_file:
    type: File
    outputSource: gen_track_data/extracted_wig_file
  extracted_size_file:
    type: File
    outputSource: gen_track_data/extracted_size_file
  wig_file:
    type: File
    outputSource: gen_track_data/wig_file
  size_file:
    type: File
    outputSource: gen_track_data/size_file
  map_file:
    type: File
    outputSource: gen_track_data/map_file

steps:
  gen_track_data:
    run: gem/track-data-gen.cwl
    in:
      tumor_bam:
        source: tumor_bam_file
      gem_index:
        source: gem_index_file
      gem_thread_num:
        source: thread_num
      gem_max_mismatch:
        source: gem_max_mismatch
      gem_max_edit:
        source: gem_max_edit
    out: [bigwig_file, extracted_wig_file, extracted_size_file, wig_file, size_file, map_file]

  call_variants:
    run: purecn/variant-data-gen.cwl
    in:
      ref_file:
        source: ref_file
      genome:
        source: ref_version
      map_file:
        source: gen_track_data/bigwig_file
      tumor_bam_file:
        source: tumor_bam_file
      tumor_bai_file:
        source: tumor_bai_file
      capture_file:
        source: capture_file
      input_vcf_file:
        source: input_vcf_file
      normaldb_file:
        source: normaldb_file
      target_weight_file:
        source: target_weight_file
      thread_num:
        source: thread_num
      outinfo:
        valueFrom: "."
    out: [sample_info_file, chrome_file, dnacopy_file, genes_file, local_optima_file, log_file, loh_file, info_pdf_file, rds_file, segmentation_file, var_csv_file, var_vcf_file, interval_file, interval_bed_file, cov_file, loess_file, loess_png_file, loess_qc_file]
