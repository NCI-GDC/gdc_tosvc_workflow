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
  - id: tumor_bam
    type: File
  - id: tumor_bai
    type: File
  - id: vcf
    type: File
  - id: capture_kit
    type: File
  - id: map
    type: File
  - id: normaldb
    type: File
  - id: target_weight
    type: File
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
  - id: purecn_interval
    run: tools/purecn_intervals.cwl
    in:
      - id: fasata
        source: fa
      - id: bed
        source: capture_kit
      - id: bigwig
        source: bigwig
      - id: genome
        source: genome
      - id: out_file
        source: fasta
        valueFrom: $(self.nameroot + ".capture_baits_hg38_gcgene.txt")
      - id: export_file
        source: fasta
        valueFrom: $(self.nameroot + ".capture_baits_optimized_hg38.bed")
    out:
      - id: interval
      - id: bed

  - id: purecn_coverage
    run: tools/purecn_coverage.cwl
    in:
      - id: bam
        source: bam
      - id: interval
        source: purcen_interval/interval
      - id: thread_num
        source: thread_num
    out:
      - id: coverage
      - id: loess_txt
      - id: loess_png
      - id: loess_qc_txt

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
