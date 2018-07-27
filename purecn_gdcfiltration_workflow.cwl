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
  - id: fa_file
    type: File
  - id: fai_file
    type: File
  - id: dict_file
    type: File
  - id: dict_main_file
    type: File

  #input data for pipeline
  - id: bam_file
    type: File
  - id: bai_file
    type: File
  - id: input_vcf_file
    type: File
  - id: capture_file
    type: File

  - id: bigwig_file
    type: File?
  - id: normaldb_file
    type: File?
  - id: target_weight_file
    type: File?

  #input parameters
  - id: fa_version
    type: string
  - id: thread_num
    type: int
    default: 8
  - id: var_prob_thres
    type: float
    default: 0.2
  - id: aliquot_id
    type: string
  - id: filename_prefix
    type: string

outputs:
  - id: output_vcf_file
    type: File
    outputSource: filter_purecn_outputs/output_vcf_file
  - id: filtration_metric_file
    type: File
    outputSource: modify_purecn_outputs/output_filtration_metric_file
  - id: dnacopy_seg_file
    type: File
    outputSource: modify_purecn_outputs/output_dnacopy_seg_file
  - id: archive_tar_file
    type: File
    outputSource: archive_purecn_outputs/output_file

steps:
  - id: call_somatic_variants
    run: purecn/call_somatic_variants.cwl
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
        source: aliquot_id
    out: [var_vcf_file, var_csv_file, metric_file, dnacopy_file, segmentation_file, loh_file, chrome_file, genes_file, local_optima_file, rds_file, info_pdf_file, log_file, interval_file, interval_bed_file, cov_file, loess_file, loess_png_file, loess_qc_file]

  - id: archive_purecn_outputs
    run: auxiliary/archive_purecn_outputs.cwl
    in:
      var_vcf_file:
        source: call_somatic_variants/var_vcf_file
      metric_file:
        source: call_somatic_variants/metric_file
      dnacopy_file:
        source: call_somatic_variants/dnacopy_file
      segmentation_file:
        source: call_somatic_variants/segmentation_file
      loh_file:
        source: call_somatic_variants/loh_file
      chrome_file:
        source: call_somatic_variants/chrome_file
      genes_file:
        source: call_somatic_variants/genes_file
      local_optima_file:
        source: call_somatic_variants/local_optima_file
      info_pdf_file:
        source: call_somatic_variants/info_pdf_file
      log_file:
        source: call_somatic_variants/log_file
      interval_file:
        source: call_somatic_variants/interval_file
      interval_bed_file:
        source: call_somatic_variants/interval_bed_file
      cov_file:
        source: call_somatic_variants/cov_file
      loess_file:
        source: call_somatic_variants/loess_file
      loess_png_file:
        source: call_somatic_variants/loess_png_file
      loess_qc_file:
        source: call_somatic_variants/loess_qc_file
      compress_file_name:
        source: filename_prefix
        valueFrom: $(self + ".variant_filtration_archive.tar.gz")
    out: [output_file]

  - id: modify_purecn_outputs
    run: gdcreannotation/modify_purecn_outputs.cwl
    in:
      sample_id:
        source: aliquot_id
      metric_file:
        source: call_somatic_variants/metric_file
      dnacopy_seg_file:
        source: call_somatic_variants/dnacopy_file
      modified_metric_file:
        source: filename_prefix
        valueFrom: $(self + ".filtration_metric.tsv")
      modified_seg_file:
        source: filename_prefix
        valueFrom: $(self + ".dnacopy_seg.tsv")
    out: [output_filtration_metric_file, output_dnacopy_seg_file]

  - id: merge_vcfs
    run: auxiliary/merge_vcfs.cwl
    in:
      input_vcf_file: [input_vcf_file, call_somatic_variants/var_vcf_file]
      seq_dict:
        source: fai_file
      output_vcf_filename:
        source: filename_prefix
        valueFrom: $(self + ".merged_mutect_purecn.vcf")
    out: [output_vcf_file]

  - id: filter_purecn_outputs
    run: gdcfiltration/filter_purecn_outputs.cwl
    in:
      input_vcf_file:
        source: merge_vcfs/output_vcf_file
      prob_thres:
        source: var_prob_thres
      output_vcf_filename:
        source: filename_prefix
        valueFrom: $(self + ".filtered_purecn.vcf")
    out: [output_vcf_file]
