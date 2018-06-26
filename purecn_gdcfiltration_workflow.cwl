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
  - id: job_uuid
    type: string
  - id: fa_file
    type: File
  - id: fai_file
    type: File
  - id: fa_version
    type: string
  - id: bigwig_file
    type: File
  - id: capture_file
    type: File
  - id: normaldb_file
    type: File
  - id: target_weight_file
    type: File

  #input parameters
  - id: thread_num
    type: int
    default: 8
  - id: var_prob_thres
    type: float
    default: 0.2

  #input data for pipeline
  - id: bam_file
    type: File
  - id: bai_file
    type: File
  - id: input_vcf_file
    type: File

outputs:
  - id: output_vcf_file
    type: File
    outputSource: variant_filtering_reannotation/output_vcf_file
  - id: sample_info_file
    type: File
    outputSource: modify_outputs/output_sample_info_file
  - id: dnacopy_seg_file
    type: File
    outputSource: modify_outputs/output_dnacopy_seg_file
  - id: other_files
    type: File
    outputSource: tar_outputs/outfile

steps:
  - id: call_variants
    run: purecn/variant-data-gen.cwl
    in:
      fa_file:
        source: fa_file
      fai_file:
        source: fai_file
      genome:
        source: fa_version
      map_file:
        source: bigwig_file
      tumor_bam_file:
        source: bam_file
      tumor_bai_file:
        source: bai_file
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

  - id: modify_outputs
    run: auxiliary/modify_outputs.cwl
    in:
      sample_info_file:
        source: call_variants/sample_info_file
      dnacopy_seg_file:
        source: call_variants/dnacopy_file
      modified_info_file:
        source: job_uuid
        valueFrom: $(self + ".info.csv")
      modified_seg_file:
        source: job_uuid
        valueFrom: $(self + ".dnacopy_seg.csv")
    out: [output_sample_info_file, output_dnacopy_seg_file]

  - id: tar_outputs
    run: auxiliary/tar_outputs.cwl
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
    run: gdc_filtering/variant_filtering_reannotation.cwl
    in:
      sample_id:
        source: job_uuid
      fa_file:
        source: fa_file
      fai_file:
        source: fai_file
      mutect_vcf_file:
        source: input_vcf_file
      purecn_vcf_file:
        source: call_variants/var_vcf_file
      var_prob_thres:
        source: var_prob_thres
    out: [output_vcf_file]
