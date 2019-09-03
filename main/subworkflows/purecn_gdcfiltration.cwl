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
  - id: dict
    type: File

  #data for pipeline
  - id: bam
    type: File
  - id: vcf
    type: File

  #parameters
  - id: fasta_version
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
  - id: capture_kit
    type: File
  - id: bigwig
    type: File
  - id: gemindex
    type: File
  - id: normaldb
    type: File
  - id: target_weight
    type: File

outputs:
  - id: output_vcf
    type: File
    outputSource: determine_purecn_outputs/output_vcf
  - id: filtration_metric
    type: [File, "null"]
    outputSource: determine_purecn_outputs/filtration_metric
  - id: dnacopy_seg
    type: [File, "null"]
    outputSource: determine_purecn_outputs/dnacopy_seg
  - id: tar
    type: [File, "null"]
    outputSource: determine_purecn_outputs/tar

steps:
  - id: call_somatic_variants
    run: call_somatic_variants.cwl
    in:
      - id: sample_id
        source: aliquot_id
      - id: fasta
        source: fasta
      - id: genome
        source: fa_version
      - id: bam
        source: bam
      - id: vcf
        source: vcf
      - id: map
        source: bigwig
      - id: capture_kit
        source: capture_kit
      - id: normaldb
        source: normaldb
      - id: target_weight
        source: target_weight
      - id: thread_num
        source: thread_num
    out:
      - id: var_vcf
      - id: var_csv
      - id: metric
      - id: dnacopy
      - id: segmentation
      - id: loh
      - id: chrome
      - id: genes
      - id: local_optima
      - id: rds
      - id: info_pdf
      - id: log
      - id: interval
      - id: interval_bed
      - id: cov
      - id: loess
      - id: loess_png
      - id: loess_qc

  - id: determine_file_exists
    run: ../tools/determine_file_exists.cwl
    in:
      - id: input
        source: call_somatic_variants/var_vcf_file
    out:
      - id: success
      - id: fail

  - id: postprocess_purecn_outputs
    run: ../purecn/postprocess_purecn_outputs.cwl
    scatter: success_purecn
    in:
      - id: success_purecn
        source: determine_file_exists/success
      - id: aliquot_id
        source: aliquot_id
      - id: var_prob_thres
        source: var_prob_thres
      - id: fai_file
        source: fai_file
      - id: input_vcf_file
        source: input_vcf_file
      - id: var_vcf_file
        source: call_somatic_variants/var_vcf_file
      - id: metric_file
        source: call_somatic_variants/metric_file
      - id: dnacopy_file
        source: call_somatic_variants/dnacopy_file
      - id: segmentation_file
        source: call_somatic_variants/segmentation_file
      - id: loh_file
        source: call_somatic_variants/loh_file
      - id: chrome_file
        source: call_somatic_variants/chrome_file
      - id: genes_file
        source: call_somatic_variants/genes_file
      - id: local_optima_file
        source: call_somatic_variants/local_optima_file
      - id: info_pdf_file
        source: call_somatic_variants/info_pdf_file
      - id: log_file
        source: call_somatic_variants/log_file
      - id: interval_file
        source: call_somatic_variants/interval_file
      - id: interval_bed_file
        source: call_somatic_variants/interval_bed_file
      - id: cov_file
        source: call_somatic_variants/cov_file
      - id: loess_file
        source: call_somatic_variants/loess_file
      - id: loess_png_file
        source: call_somatic_variants/loess_png_file
      - id: loess_qc_file
        source: call_somatic_variants/loess_qc_file
      - id: filename_prefix
        source: filename_prefix
    out:
      - id: output_vcf_file
      - id: filtration_metric_file
      - id: dnacopy_seg_file
      - id: archive_tar_file

  - id: annot_fail_purecn_vcf
    run: ../gdcfiltration/annot_fail_purecn_vcf.cwl
    scatter: fail_purecn
    in:
      - id: fail_purecn
        source: determine_purecn_postprocess/fail_purecn
      - id: purecn_log_file
        source: call_somatic_variants/log_file
      - id: input_vcf_file
        source: input_vcf_file
      - id: output_vcf_filename
        source: input_vcf_file
        valueFrom: $(self.basename + ".annot_fail_purecn.vcf")
    out:
      - id: output_vcf_file

  - id: determine_purecn_outputs
    run: ../auxiliary/determine_purecn_outputs.cwl
    in:
      - id: purecn_fail_vcf_file
        source: annot_fail_purecn_vcf/output_vcf_file
      - id: purecn_success_vcf_file
        source: postprocess_purecn_outputs/output_vcf_file
      - id: filtration_metric_file
        source: postprocess_purecn_outputs/filtration_metric_file
      - id: dnacopy_seg_file
        source: postprocess_purecn_outputs/dnacopy_seg_file
      - id: archive_tar_file
        source: postprocess_purecn_outputs/archive_tar_file

    out:
      - id: output_vcf_file
      - id: output_filtration_metric_file
      - id: output_dnacopy_seg_file
      - id: output_archive_tar_file
