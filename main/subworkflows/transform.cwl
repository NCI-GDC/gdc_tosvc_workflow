#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
  #ref info
  - id: job_uuid
    type: string
  - id: case_id
    type: string
  - id: aliquot_id
    type: string
  - id: patient_barcode
    type: string
  - id: sample_barcode
    type: string
  - id: project_id
    type: [string, "null"]
    doc: GDC project id used for output filenames
  - id: caller_id
    type: [string, "null"]
    doc: GDC caller id used for output filenames
  - id: experimental_strategy
    type: string
    doc: GDC experimental strategy used for output filenames

  #full ref files
  - id: fa
    type: File
  - id: fai
    type: File
  - id: dict
    type: File

  #main ref files
  - id: fa_main
    type: File
  - id: fai_main
    type: File
  - id: dict_main
    type: File

  #input data for pipeline
  - id: bam
    type: File
  - id: bai
    type: File
  - id: vcf
    type: File

  #GEM and PureCN ref files (optional)
  - id: capture_kit
    type: [File, "null"]
  - id: bigwig
    type: [File, "null"]
  - id: gemindex
    type: [File, "null"]
  - id: normaldb
    type: [File, "null"]
  - id: target_weight
    type: [File, "null"]

 #parameters
  - id: fa_name
    type: string
    default: "GRCh38.d1.vd1.fa"
    doc: reference name used in the VCF header
  - id: fa_version
    type: string
    default: "hg38"
    doc: reference version used by PureCN
  - id: thread_num
    type: int
    default: 8
    doc: number of thread used by PureCN and some other tools
  - id: var_prob_thres
    type: float
    default: 0.2
    doc: threshold for posterior probability of somatic variants calculated by PureCN |
         this threshold is used in the filtering step
  - id: gem_max_mismatch
    type: int
    default: 2
  - id: gem_max_edit
    type: int
    default: 2

  #conditional inputs
  - id: run_with_normaldb
    type:
      type: array
      items: int
  - id: run_without_normaldb
    type:
      type: array
      items: int

outputs:
  - id: filtered_vcf_uuid
    type: string
    outputSource: upload_outputs/filtered_vcf_uuid
  - id: filtered_vcf_index_uuid
    type: string
    outputSource: upload_outputs/filtered_vcf_index_uuid
  - id: filtration_metric_uuid
    type: [string, "null"]
    outputSource: upload_outputs/filtration_metric_uuid
  - id: dnacopy_seg_uuid
    type: [string, "null"]
    outputSource: upload_outputs/dnacopy_seg_uuid
  - id: archive_tar_uuid
    type: [string, "null"]
    outputSource: upload_outputs/archive_tar_uuid

steps:
  - id: get_filename_prefix
    run: tools/make_file_prefix.cwl
    in:
      - id: job_uuid
        source: job_uuid
      - id: project_id
        source: project_id
      - id: caller_id
        source: caller_id
      - id: experimental_strategy
        source: experimental_strategy
    out:
      - id: output

  - id: remove_nstd_variants
    run: tools/remove_nonstandard_variants.cwl
    in:
      - id: input_vcf
        source: get_inputs/vcf_file
      - id: output_filename
        valueFrom: "std.vcf"
    out:
      - id: output_vcf

  - id: filter_mutect_outputs
    run: tools/filter_mutect_outputs.cwl
    scatter: run_without_normaldb
    in:
      - id: run_without_normaldb
        source: run_without_normaldb
      - id: input_vcf
        source: remove_nstd_variants/output_vcf
    out:
      - id: output_vcf

  - id: purecn_gdcfiltration
    run: purecn_gdcfiltration.cwl
    scatter: run_with_normaldb
    in:
      - id: run_with_normaldb
        source: run_with_normaldb
      - id: fa_file
        source: get_inputs/fa_file
      - id: fai_file
        source: get_inputs/fai_file
      - id: dict_file
        source: get_inputs/dict_file
      - id: dict_main_file
        source: get_inputs/dict_main_file
      - id: bam_file
        source: get_inputs/bam_file
      - id: bai_file
        source: get_inputs/bai_file
      - id: input_vcf_file
        source: remove_nstd_variants/output_vcf
      - id: fa_version
        source: fa_version
      - id: thread_num
        source: thread_num
      - id: var_prob_thres
        source: var_prob_thres
      - id: aliquot_id
        source: aliquot_id
      - id: filename_prefix
        source: get_filename_prefix/output
      - id: capture_kit
        source: capture_kit
      - id: bigwig
        source: bigwig
      - id: gemindex
        source: gemindex
      - id: normaldb
        source: normaldb
      - id: target_weight
        source: target_weight
    out:
      - id: output_vcf_file
      - id: filtration_metric_file
      - id: dnacopy_seg_file
      - id: archive_tar_file

  - id: determine_purecn_gdcfiltration
    run: tools/determine_purecn_gdcfiltration.cwl
    in:
      - id: no_normaldb_vcf_file
        source: gdcfiltration/output_vcf_file
      - id: normaldb_vcf_file
        source: purecn_gdcfiltration/output_vcf_file
      - id: filtration_metric_file
        source: purecn_gdcfiltration/filtration_metric_file
      - id: dnacopy_seg_file
        source: purecn_gdcfiltration/dnacopy_seg_file
      - id: archive_tar_file
        source: purecn_gdcfiltration/archive_tar_file
    out:
      - id: output_vcf_file
      - id: output_filtration_metric_file
      - id: output_dnacopy_seg_file
      - id: output_archive_tar_file

  - id: gdc_reannotation
    run: gdcreannotation_workflow.cwl
    in:
      - id: input_vcf_file
        source: determine_purecn_gdcfiltration/output_vcf_file
      - id: dict_main_file
        source: get_inputs/dict_main_file
      - id: fa_name
        source: fa_name
      - id: patient_barcode
        source: patient_barcode
      - id: case_id
        source: case_id
      - id: aliquot_id
        source: aliquot_id
      - id: bam_uuid
        source: bam_uuid
      - id: sample_barcode
        source: sample_barcode
      - id: filename_prefix
        source: get_filename_prefix/output
    out:
      - id: output_vcf_file