#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: filename_prefix
    type: string
  - id: var_prob_thres
    type: float
  - id: aliquot_id
    type: string
  - id: fai_file
    type: File
  - id: input_vcf_file
    type: File
  - id: var_vcf_file
    type: File
  - id: metric_file
    type: File
  - id: dnacopy_file
    type: File
  - id: segmentation_file
    type: File
  - id: loh_file
    type: File
  - id: chrome_file
    type: File
  - id: genes_file
    type: File?
  - id: local_optima_file
    type: File
  - id: info_pdf_file
    type: File
  - id: log_file
    type: File
  - id: interval_file
    type: File
  - id: interval_bed_file
    type: File
  - id: cov_file
    type: File
  - id: loess_file
    type: File
  - id: loess_png_file
    type: File
  - id: loess_qc_file
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
      - id: input_vcf_file
        source: var_vcf_file
      - id: output_vcf_filename
        source: var_vcf_file
        valueFrom: $(self.basename + ".gz")
    out:
      - id: output_vcf_file

  - id: merge_vcfs
    run: ../auxiliary/merge_vcfs.cwl
    in:
      - id: input_vcf_file
        source: [input_vcf_file, sort_purecn_vcf/output_vcf_file]
      - id: seq_dict
        source: fai_file
      - id: output_vcf_filename
        source: filename_prefix
        valueFrom: $(self + ".merged_mutect_purecn.vcf")
    out:
      - id: output_vcf_file

  - id: filter_purecn_outputs
    run: ../gdcfiltration/filter_purecn_outputs.cwl
    in:
      - id: input_vcf_file
        source: merge_vcfs/output_vcf_file
      - id: prob_thres
        source: var_prob_thres
      - id: output_vcf_filename
        source: filename_prefix
        valueFrom: $(self + ".filtered_purecn.vcf")
    out:
      - id: output_vcf_file

  - id: modify_purecn_outputs
    run: ../gdcfiltration/modify_purecn_outputs.cwl
    in:
      - id: sample_id
        source: aliquot_id
      - id: metric_file
        source: metric_file
      - id: dnacopy_seg_file
        source: dnacopy_file
      - id: modified_metric_file
        source: filename_prefix
        valueFrom: $(self + ".filtration_metric.tsv")
      - id: modified_seg_file
        source: filename_prefix
        valueFrom: $(self + ".dnacopy_seg.tsv")
    out:
      - id: output_filtration_metric_file
      - id: output_dnacopy_seg_file

  - id: archive_purecn_outputs
    run: ../auxiliary/archive_purecn_outputs.cwl
    in:
      - id: var_vcf_file
        source: var_vcf_file
      - id: metric_file
        source: metric_file
      - id: dnacopy_file
        source: dnacopy_file
      - id: segmentation_file
        source: segmentation_file
      - id: loh_file
        source: loh_file
      - id: chrome_file
        source: chrome_file
      - id: genes_file
        source: genes_file
      - id: local_optima_file
        source: local_optima_file
      - id: info_pdf_file
        source: info_pdf_file
      - id: log_file
        source: log_file
      - id: interval_file
        source: interval_file
      - id: interval_bed_file
        source: interval_bed_file
      - id: cov_file
        source: cov_file
      - id: loess_file
        source: loess_file
      - id: loess_png_file
        source: loess_png_file
      - id: loess_qc_file
        source: loess_qc_file
      - id: compress_file_name
        source: filename_prefix
        valueFrom: $(self + ".variant_filtration_archive.tar.gz")
    out:
      - id: output_file
