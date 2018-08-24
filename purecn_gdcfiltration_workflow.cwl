#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  #ref info
  - id: bioclient_config
    type: File

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

  #GEM and PureCN ref files
  - id: capture_kit_uuid
    type: string
  - id: capture_kit_filesize
    type: long
  - id: bigwig_uuid
    type: string
  - id: bigwig_filesize
    type: long
  - id: gemindex_uuid
    type: string
  - id: gemindex_filesize
    type: long
  - id: normaldb_uuid
    type: string
  - id: normaldb_filesize
    type: long
  - id: target_weight_uuid
    type: string
  - id: target_weight_filesize
    type: long

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
  - id: get_inputs
    run: inout/get_purecn_inputs.cwl
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: capture_kit_uuid
        source: capture_kit_uuid
      - id: capture_kit_filesize
        source: capture_kit_filesize
      - id: bigwig_uuid
        source: bigwig_uuid
      - id: bigwig_filesize
        source: bigwig_filesize
      - id: gemindex_uuid
        source: gemindex_uuid
      - id: gemindex_filesize
        source: gemindex_filesize
      - id: normaldb_uuid
        source: normaldb_uuid
      - id: normaldb_filesize
        source: normaldb_filesize
      - id: target_weight_uuid
        source: target_weight_uuid
      - id: target_weight_filesize
        source: target_weight_filesize
    out: [capture_kit_file, bigwig_file, gemindex_file, normaldb_file, target_weight_file]

  - id: call_somatic_variants
    run: purecn/call_somatic_variants.cwl
    in:
      fa_file:
        source: fa_file
      fai_file:
        source: fai_file
      genome:
        source: fa_version
      tumor_bam_file:
        source: bam_file
      tumor_bai_file:
        source: bai_file
      input_vcf_file:
        source: input_vcf_file
      map_file:
        source: get_inputs/bigwig_file
      capture_kit_file:
        source: get_inputs/capture_kit_file
      normaldb_file:
        source: get_inputs/normaldb_file
      target_weight_file:
        source: get_inputs/target_weight_file
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
