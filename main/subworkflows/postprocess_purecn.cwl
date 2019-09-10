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
  - id: aliquotid
    type: string
  - id: fai
    type: File
  - id: vcf
    type: File
  - id: purecn_vcf
    type: File
  - id: purecn_csv
    type: File
  - id: purecn_dnacopy_seg
    type: File
  - id: purecn_segmentation_pdf
    type: File
  - id: purecn_loh_csv
    type: File
  - id: purecn_chromosomes_pdf
    type: File
  - id: purecn_genes_csv
    type: File
  - id: purecn_local_optima_pdf
    type: File
  - id: purecn_pdf
    type: File
  - id: purecn_log
    type: File
  - id: purecn_interval_interval
    type: File
  - id: purecn_interval_bed
    type: File
  - id: purecn_coverage_coverage
    type: File
  - id: purecn_coverage_loess_png
    type: File
  - id: purecn_coverage_loess_qc_txt
    type: File
  - id: purecn_coverage_loess_txt
    type: File

outputs:
  - id: vcf
    type: File
    outputSource: filter_purecn_outputs/output
  - id: filtration_metric
    type: File
    outputSource: modify_purecn_outputs/output_filtration_metric
  - id: dnacopy_seg
    type: File
    outputSource: modify_purecn_outputs/output_dnacopy_seg
  - id: tar_purecn_output
    type: File
    outputSource: tar_purecn/output

steps:
  - id: picard_sortvcf
    run: tools/picard_sortvcf.cwl
    in:
      - id: input
        source: purecn_vcf
      - id: output
        valueFrom: $(inputs.input.basename).gz
    out:
      - id: output

  - id: picard_mergevcfs
    run: tools/picard_mergevcfs.cwl
    in:
      - id: input
        source: [
        vcf,
        picard_sortvcf/output
        ]
      - id: output
        source: filename_prefix
        valueFrom: $(self).merged_mutect_purecn.vcf
      - id: sequence_dictionary
        source: fai
    out:
      - id: output

  - id: filter_purecn_outputs
    run: tools/filter_purecn_outputs.cwl
    in:
      - id: vcf
        source: picard_mergevcfs/output
      - id: prob_thres
        source: var_prob_thres
      - id: output
        source: filename_prefix
        valueFrom: $(self).filtered_purecn.vcf
    out:
      - id: output

  - id: modify_purecn_outputs
    run: tools/modify_purecn_outputs.cwl
    in:
      - id: sampleid
        source: aliquotid
      - id: purecn_csv
        source: purecn_csv
      - id: purecn_dnacopy_seg
        source: purecn_dnacopy_seg
      - id: modified_metric
        source: filename_prefix
        valueFrom: $(self).filtration_metric.tsv
      - id: modified_seg
        source: filename_prefix
        valueFrom: $(self).dnacopy_seg.tsv
    out:
      - id: output_filtration_metric
      - id: output_dnacopy_seg

  - id: tar_purecn
    run: tools/tar_gz.cwl
    in:
      - id: input
        source: [
          vcf,
          purecn_csv,
          purecn_dnacopy_seg,
          purecn_segmentation_pdf,
          purecn_loh_csv,
          purecn_chromosomes_pdf,
          purecn_genes_csv,
          purecn_local_optima_pdf,
          purecn_pdf,
          purecn_log,
          purecn_interval_interval,
          purecn_interval_bed,
          purecn_coverage_coverage,
          purecn_coverage_loess_png,
          purecn_coverage_loess_qc_txt,
          purecn_coverage_loess_txt
        ]
      - id: file
        source: filename_prefix
        valueFrom: $(self).variant_filtration_archive.tar.gz
    out:
      - id: output
