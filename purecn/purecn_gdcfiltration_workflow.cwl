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
    outputSource: determine_purecn_outputs/output_vcf_file
  - id: filtration_metric_file
    type: File?
    outputSource: determine_purecn_outputs/output_filtration_metric_file
  - id: dnacopy_seg_file
    type: File?
    outputSource: determine_purecn_outputs/output_dnacopy_seg_file
  - id: archive_tar_file
    type: File?
    outputSource: determine_purecn_outputs/output_archive_tar_file

steps:
  - id: get_inputs
    run: ../inout/get_purecn_inputs.cwl
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
    out:
      - id: capture_kit_file
      - id: bigwig_file
      - id: gemindex_file
      - id: normaldb_file
      - id: target_weight_file

  - id: call_somatic_variants
    run: ../purecn/call_somatic_variants.cwl
    in:
      - id: sample_id
        source: aliquot_id
      - id: fa_file
        source: fa_file
      - id: fai_file
        source: fai_file
      - id: genome
        source: fa_version
      - id: tumor_bam_file
        source: bam_file
      - id: tumor_bai_file
        source: bai_file
      - id: input_vcf_file
        source: input_vcf_file
      - id: map_file
        source: get_inputs/bigwig_file
      - id: capture_kit_file
        source: get_inputs/capture_kit_file
      - id: normaldb_file
        source: get_inputs/normaldb_file
      - id: target_weight_file
        source: get_inputs/target_weight_file
      - id: thread_num
        source: thread_num
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
      - id: interval_file
      - id: interval_bed_file
      - id: cov_file
      - id: loess_file
      - id: loess_png_file
      - id: loess_qc_file

  - id: determine_purecn_postprocess
    run: ../auxiliary/determine_purecn_postprocess.cwl
    in:
      - id: purecn_vcf_file
        source: call_somatic_variants/var_vcf_file
    out:
      - id: success_purecn
      - id: fail_purecn

  - id: postprocess_purecn_outputs
    run: ../purecn/postprocess_purecn_outputs.cwl
    scatter: success_purecn
    in:
      - id: success_purecn
        source: determine_purecn_postprocess/success_purecn
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
