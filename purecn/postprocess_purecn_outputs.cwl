#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  filename_prefix:
    type: string
  var_prob_thres:
    type: float
  aliquot_id:
    type: string
  fai_file:
    type: File
  input_vcf_file:
    type: File
  var_vcf_file:
    type: File
  metric_file:
    type: File
  dnacopy_file:
    type: File
  segmentation_file:
    type: File
  loh_file:
    type: File
  chrome_file:
    type: File
  genes_file:
    type: File?
  local_optima_file:
    type: File
  info_pdf_file:
    type: File
  log_file:
    type: File
  interval_file:
    type: File
  interval_bed_file:
    type: File
  cov_file:
    type: File
  loess_file:
    type: File
  loess_png_file:
    type: File
  loess_qc_file:
    type: File

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
  - id: sort_purecn_vcf
    run: ../auxiliary/sort_vcf_file.cwl
    in:
      input_vcf_file:
        source: var_vcf_file
      output_vcf_filename:
        source: var_vcf_file
        valueFrom: $(self.basename + ".gz")
    out:
      [output_vcf_file]

  - id: merge_vcfs
    run: ../auxiliary/merge_vcfs.cwl
    in:
      input_vcf_file: [input_vcf_file, sort_purecn_vcf/output_vcf_file]
      seq_dict:
        source: fai_file
      output_vcf_filename:
        source: filename_prefix
        valueFrom: $(self + ".merged_mutect_purecn.vcf")
    out: [output_vcf_file]

  - id: filter_purecn_outputs
    run: ../gdcfiltration/filter_purecn_outputs.cwl
    in:
      input_vcf_file:
        source: merge_vcfs/output_vcf_file
      prob_thres:
        source: var_prob_thres
      output_vcf_filename:
        source: filename_prefix
        valueFrom: $(self + ".filtered_purecn.vcf")
    out: [output_vcf_file]

  - id: modify_purecn_outputs
    run: ../gdcfiltration/modify_purecn_outputs.cwl
    in:
      sample_id:
        source: aliquot_id
      metric_file:
        source: metric_file
      dnacopy_seg_file:
        source: dnacopy_file
      modified_metric_file:
        source: filename_prefix
        valueFrom: $(self + ".filtration_metric.tsv")
      modified_seg_file:
        source: filename_prefix
        valueFrom: $(self + ".dnacopy_seg.tsv")
    out: [output_filtration_metric_file, output_dnacopy_seg_file]

  - id: archive_purecn_outputs
    run: ../auxiliary/archive_purecn_outputs.cwl
    in:
      var_vcf_file:
        source: var_vcf_file
      metric_file:
        source: metric_file
      dnacopy_file:
        source: dnacopy_file
      segmentation_file:
        source: segmentation_file
      loh_file:
        source: loh_file
      chrome_file:
        source: chrome_file
      genes_file:
        source: genes_file
      local_optima_file:
        source: local_optima_file
      info_pdf_file:
        source: info_pdf_file
      log_file:
        source: log_file
      interval_file:
        source: interval_file
      interval_bed_file:
        source: interval_bed_file
      cov_file:
        source: cov_file
      loess_file:
        source: loess_file
      loess_png_file:
        source: loess_png_file
      loess_qc_file:
        source: loess_qc_file
      compress_file_name:
        source: filename_prefix
        valueFrom: $(self + ".variant_filtration_archive.tar.gz")
    out: [output_file]
