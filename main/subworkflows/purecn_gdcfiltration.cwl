#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: bioclient_config
    type: File

  #ref data
  - id: fasta
    type: File
    secondaryFiles:
      - .fai
  - id: dict
    type: File

  #data for pipeline
  - id: bam
    type: File
    secondaryFiles:
      - ^.bai
  - id: vcf
    type: File

  #parameters
  - id: fasta_version
    type: string
  - id: thread_num
    type: long
    default: 8
  - id: var_prob_thres
    type: float
    default: 0.2
  - id: aliquotid
    type: string
  - id: filename_prefix
    type: string

  #GEM and PureCN ref files
  - id: capture_kit
    type: File
  - id: bigwig
    type: File
  - id: gemindex
    type: File
  - id: normaldb
    type: File
  - id: intervalweightfile
    type: File

outputs:
  []
  # - id: output_vcf
  #   type: File
  #   outputSource: determine_purecn_outputs/output_vcf
  # - id: filtration_metric
  #   type: [File, "null"]
  #   outputSource: determine_purecn_outputs/filtration_metric
  # - id: dnacopy_seg
  #   type: [File, "null"]
  #   outputSource: determine_purecn_outputs/dnacopy_seg
  # - id: tar
  #   type: [File, "null"]
  #   outputSource: determine_purecn_outputs/tar

steps:
  - id: call_somatic_variants
    run: call_somatic_variants.cwl
    in:
      - id: sampleid
        source: aliquotid
      - id: fasta
        source: fasta
      - id: genome
        source: fasta_version
      - id: bam
        source: bam
      - id: vcf
        source: vcf
      - id: bigwig
        source: bigwig
      - id: capture_kit
        source: capture_kit
      - id: normaldb
        source: normaldb
      - id: intervalweightfile
        source: intervalweightfile
      - id: thread_num
        source: thread_num
    out:
      - id: chromosomes_pdf
      - id: csv
      - id: dnacopy_seg
      - id: genes_csv
      - id: local_optima_pdf
      - id: log
      - id: loh_csv
      - id: pdf
      - id: rds
      - id: segmentation_pdf
      - id: variants_csv
      - id: vcf
      - id: interval_bed
      - id: interval_interval
      - id: coverage_coverage
      - id: coverage_loess_png
      - id: coverage_loess_qc_txt
      - id: coverage_loess_txt

  - id: determine_file_exists
    run: tools/determine_file_exists.cwl
    in:
      - id: input
        source: call_somatic_variants/vcf
    out:
      - id: success
      - id: fail

  - id: postprocess_purecn
    run: postprocess_purecn.cwl
    scatter: success_purecn
    in:
      - id: success_purecn
        source: determine_file_exists/success
      - id: aliquotid
        source: aliquotid
      - id: fai
        source: fasta
        valueFrom: $(self.secondaryFiles[0])
      - id: filename_prefix
        source: filename_prefix
      - id: var_prob_thres
        source: var_prob_thres
      - id: vcf
        source: vcf
      - id: purecn_chromosomes_pdf
        source: call_somatic_variants/chromosomes_pdf
      - id: purecn_csv
        source: call_somatic_variants/csv
      - id: purecn_dnacopy_seg
        source: call_somatic_variants/dnacopy_seg
      - id: purecn_genes_csv
        source: call_somatic_variants/genes_csv
      - id: purecn_local_optima_pdf
        source: call_somatic_variants/local_optima_pdf
      - id: purecn_log
        source: call_somatic_variants/log
      - id: purecn_loh_csv
        source: call_somatic_variants/loh_csv
      - id: purecn_pdf
        source: call_somatic_variants/pdf
      - id: purecn_segmentation_pdf
        source: call_somatic_variants/segmentation_pdf
      - id: purecn_vcf
        source: call_somatic_variants/vcf
      - id: purecn_interval_interval
        source: call_somatic_variants/interval_interval
      - id: purecn_interval_bed
        source: call_somatic_variants/interval_bed
      - id: purecn_coverage_coverage
        source: call_somatic_variants/coverage_coverage
      - id: purecn_coverage_loess_png
        source: call_somatic_variants/coverage_loess_png
      - id: purecn_coverage_loess_qc_txt
        source: call_somatic_variants/coverage_loess_qc_txt
      - id: purecn_coverage_loess_txt
        source: call_somatic_variants/coverage_loess_txt
    out:
      - id: output_vcf_file
      - id: filtration_metric_file
      - id: dnacopy_seg_file
      - id: archive_tar_file

  # - id: annot_fail_purecn_vcf
  #   run: ../gdcfiltration/annot_fail_purecn_vcf.cwl
  #   scatter: fail_purecn
  #   in:
  #     - id: fail_purecn
  #       source: determine_purecn_postprocess/fail_purecn
  #     - id: purecn_log_file
  #       source: call_somatic_variants/log_file
  #     - id: input_vcf_file
  #       source: input_vcf_file
  #     - id: output_vcf_filename
  #       source: input_vcf_file
  #       valueFrom: $(self.basename + ".annot_fail_purecn.vcf")
  #   out:
  #     - id: output_vcf_file

  # - id: determine_purecn_outputs
  #   run: ../auxiliary/determine_purecn_outputs.cwl
  #   in:
  #     - id: purecn_fail_vcf_file
  #       source: annot_fail_purecn_vcf/output_vcf_file
  #     - id: purecn_success_vcf_file
  #       source: postprocess_purecn_outputs/output_vcf_file
  #     - id: filtration_metric_file
  #       source: postprocess_purecn_outputs/filtration_metric_file
  #     - id: dnacopy_seg_file
  #       source: postprocess_purecn_outputs/dnacopy_seg_file
  #     - id: archive_tar_file
  #       source: postprocess_purecn_outputs/archive_tar_file

  #   out:
  #     - id: output_vcf_file
  #     - id: output_filtration_metric_file
  #     - id: output_dnacopy_seg_file
  #     - id: output_archive_tar_file
