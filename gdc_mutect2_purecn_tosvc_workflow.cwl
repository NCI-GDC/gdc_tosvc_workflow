#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  #input ref data
  - id: bioclient_config
    type: File
  - id: bioclient_upload_bucket
    type: string
  - id: job_uuid
    type: string
  - id: fa_uuid
    type: string
  - id: fa_filesize
    type: long
  - id: fai_uuid
    type: string
  - id: fai_filesize
    type: long
  - id: bigwig_uuid
    type: string
  - id: bigwig_filesize
    type: long
  - id: gemindex_uuid
    type: string
  - id: gemindex_filesize
    type: long

  #input parameters
  - id: fa_version
    type: string
  - id: thread_num
    type: int
  - id: gem_max_mismatch
    type: int
    default: 2
  - id: gem_max_edit
    type: int
    default: 2
  - id: var_prob_thres
    type: float
    default: 0.2

  #input data for pipeline
  - id: bam_uuid
    type: string
  - id: bam_filesize
    type: long
  - id: bai_uuid
    type: string
  - id: bai_filesize
    type: long
  - id: input_vcf_file
    type: File
  - id: capture_file
    type: File?
  - id: normaldb_file
    type: File?
  - id: target_weight_file
    type: File?

outputs:
  - id: var_vcf_file_uuid
    type: string
    outputSource: upload_outputs/var_vcf_file_uuid
  - id: sample_info_file_uuid
    type: string
    outputSource: upload_outputs/sample_info_file_uuid
  - id: dnacopy_file_uuid
    type: string
    outputSource: upload_outputs/dnacopy_seg_file_uuid
  - id: other_files_uuid
    type: string
    outputSource: upload_outputs/other_files_uuid

steps:
  - id: get_inputs
    run: inout/get_inputs.cwl
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: bam_uuid
        source: bam_uuid
      - id: bam_filesize
        source: bam_filesize
      - id: bai_uuid
        source: bai_uuid
      - id: bai_filesize
        source: bai_filesize
      - id: fa_uuid
        source: fa_uuid
      - id: fa_filesize
        source: fa_filesize
      - id: fai_uuid
        source: fai_uuid
      - id: fai_filesize
        source: fai_filesize
      - id: bigwig_uuid
        source: bigwig_uuid
      - id: bigwig_filesize
        source: bigwig_filesize
      - id: gemindex_uuid
        source: gemindex_uuid
      - id: gemindex_filesize
        source: gemindex_filesize
    out: [fa_file, fai_file, bam_file, bai_file, bigwig_file, gemindex_file]
  
  - id: call_variants
    run: purecn/variant-data-gen.cwl
    in:
      fa_file:
        source: get_inputs/fa_file
      fai_file:
        source: get_inputs/fai_file
      genome:
        source: fa_version
      map_file:
        source: get_inputs/bigwig_file
      tumor_bam_file:
        source: get_inputs/bam_file
      tumor_bai_file:
        source: get_inputs/bai_file
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
      sample_id:
        source: job_uuid
      outinfo:
        valueFrom: "."
    out: [sample_info_file, chrome_file, dnacopy_file, genes_file, local_optima_file, log_file, loh_file, info_pdf_file, rds_file, segmentation_file, var_csv_file, var_vcf_file, interval_file, interval_bed_file, cov_file, loess_file, loess_png_file, loess_qc_file]

  - id: tar_outputs
    run: inout/tar_outputs.cwl
    in:
      var_vcf_file:
        source: call_variants/var_vcf_file
      genes_file:
        source: call_variants/genes_file
      log_file:
        source: call_variants/log_file
      loh_file:
        source: call_variants/loh_file
      info_pdf_file:
        source: call_variants/info_pdf_file
      segmentation_file:
        source: call_variants/segmentation_file
      chrome_file:
        source: call_variants/chrome_file
      local_optima_file:
        source: call_variants/local_optima_file
      interval_file:
        source: call_variants/interval_file
      interval_bed_file:
        source: call_variants/interval_bed_file
      cov_file:
        source: call_variants/cov_file
      loess_file:
        source: call_variants/loess_file
      loess_png_file:
        source: call_variants/loess_png_file
      loess_qc_file:
        source: call_variants/loess_qc_file
      compress_file_name:
        source: job_uuid
        valueFrom: $(self + ".purecn.tar.gz")
    out: [outfile]

  - id: variant_filtering_reannotation
    run: filtering/variant_filtering_reannotation.cwl
    in:
      sample_id:
        source: job_uuid
      fa_file:
        source: get_inputs/fa_file
      fai_file:
        source: get_inputs/fai_file
      mutect_vcf_file:
        source: input_vcf_file
      purecn_vcf_file:
        source: call_variants/var_vcf_file
      sample_info_file:
        source: call_variants/sample_info_file
      dnacopy_seg_file:
        source: call_variants/dnacopy_file
      var_prob_thres:
        source: var_prob_thres
    out: [gdc_vcf_file, gdc_sample_info_file, gdc_dnacopy_seg_file]

  - id: upload_outputs
    run: inout/upload_outputs.cwl
    in:
      bioclient_config:
        source: bioclient_config
      bioclient_upload_bucket:
        source: bioclient_upload_bucket
      job_uuid:
        source: job_uuid
      var_vcf_file:
        source: variant_filtering_reannotation/gdc_vcf_file
      sample_info_file:
        source: variant_filtering_reannotation/gdc_sample_info_file
      dnacopy_seg_file:
        source: variant_filtering_reannotation/gdc_dnacopy_seg_file
      other_files:
        source: tar_outputs/outfile
    out: [var_vcf_file_uuid, sample_info_file_uuid, dnacopy_seg_file_uuid, other_files_uuid]
