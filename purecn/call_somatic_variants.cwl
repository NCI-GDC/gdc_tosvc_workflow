#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  - id: fa_file
    type: File
  - id: fai_file
    type: File
  - id: tumor_bam_file
    type: File
  - id: tumor_bai_file
    type: File
  - id: input_vcf_file
    type: File
  - id: capture_kit_file
    type: File?
  - id: map_file
    type: File?
  - id: normaldb_file
    type: File?
  - id: target_weight_file
    type: File?
  - id: genome
    type: string
  - id: sample_id
    type: string
  - id: thread_num
    type: int

outputs:
  - id: var_vcf_file
    type: File?
    outputSource: var_call/var_vcf_file
  - id: var_csv_file
    type: File?
    outputSource: var_call/var_csv_file
  - id: metric_file
    type: File?
    outputSource: var_call/metric_file
  - id: dnacopy_file
    type: File?
    outputSource: var_call/dnacopy_file
  - id: segmentation_file
    type: File?
    outputSource: var_call/segmentation_file
  - id: loh_file
    type: File?
    outputSource: var_call/loh_file
  - id: chrome_file
    type: File?
    outputSource: var_call/chrome_file
  - id: genes_file
    type: File?
    outputSource: var_call/genes_file
  - id: local_optima_file
    type: File?
    outputSource: var_call/local_optima_file
  - id: rds_file
    type: File?
    outputSource: var_call/rds_file
  - id: info_pdf_file
    type: File?
    outputSource: var_call/info_pdf_file
  - id: log_file
    type: File?
    outputSource: var_call/log_file
  - id: interval_file
    type: File
    outputSource: interval/interval_file
  - id: interval_bed_file
    type: File
    outputSource: interval/interval_bed_file
  - id: cov_file
    type: File
    outputSource: coverage/cov_file
  - id: loess_file
    type: File
    outputSource: coverage/loess_file
  - id: loess_png_file
    type: File
    outputSource: coverage/loess_png_file
  - id: loess_qc_file
    type: File
    outputSource: coverage/loess_qc_file

steps:
  - id: interval
    run: PureCNIntervalFile.cwl
    in:
      - id: fa_file
        source: fa_file
      - id: fai_file
        source: fai_file
      - id: capture_kit_file
        source: capture_kit_file
      - id: map_file
        source: map_file
      - id: genome
        source: genome
      - id: out_file
        source: fa_file
        valueFrom: $(self.nameroot + ".capture_baits_hg38_gcgene.txt")
      - id: export_file
        source: fa_file
        valueFrom: $(self.nameroot + ".capture_baits_optimized_hg38.bed")
    out:
      - id: interval_file
      - id: interval_bed_file

  - id: coverage
    run: PureCNCoverage.cwl
    in:
      - id: bam_file
        source: tumor_bam_file
      - id: bai_file
        source: tumor_bai_file
      - id: interval_file
        source: interval/interval_file
      - id: thread_num
        source: thread_num
    out:
      - id: cov_file
      - id: loess_file
      - id: loess_png_file
      - id: loess_qc_file

  - id: var_call
    run: PureCN.cwl
    in:
      - id: sample_id
        source: sample_id
      - id: tumor_file
        source: coverage/loess_file
      - id: input_vcf_file
        source: input_vcf_file
      - id: interval_file
        source: interval/interval_file
      - id: normaldb_file
        source: normaldb_file
      - id: target_weight_file
        source: target_weight_file
      - id: genome
        source: genome
    out:
      - id: var_vcf_file
      - id: var_csv_file
      - id: metric_file
      - id: dnacopy_file
      - id: segmentation_file
      - id: loh_file
      - id: chrome_file
      - id: genes_file
      - id: local_optima_file
      - id: rds_file
      - id: info_pdf_file
      - id: log_file
