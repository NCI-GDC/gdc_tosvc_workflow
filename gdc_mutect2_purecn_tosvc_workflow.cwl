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
  #input ref data
  - id: bioclient_config
    type: File
  - id: bioclient_upload_bucket
    type: string
  - id: job_uuid
    type: string
  - id: fa_uuid
    type: string
  - id: fa_filesize
    type: long
  - id: fai_uuid
    type: string
  - id: fai_filesize
    type: long
  - id: bigwig_uuid
    type: string
  - id: bigwig_filesize
    type: long
  - id: gemindex_uuid
    type: string
  - id: gemindex_filesize
    type: long

  #input parameters
  - id: fa_version
    type: string
  - id: thread_num
    type: int
  - id: gem_max_mismatch
    type: int
    default: 2
  - id: gem_max_edit
    type: int
    default: 2
  - id: var_prob_thres
    type: float
    default: 0.2

  #input data for pipeline
  - id: bam_uuid
    type: string
  - id: bam_filesize
    type: long
  - id: bai_uuid
    type: string
  - id: bai_filesize
    type: long
  - id: input_vcf_file
    type: File

  #optional inputs
  - id: capture_file
    type: File
  - id: normaldb_file
    type: File
  - id: target_weight_file
    type: File

  #conditinonal inputs
  - id: run_with_normaldb
    type:
      type: array
      items: int
  - id: run_without_normaldb
    type:
      type: array
      items: int

outputs:
  - id: var_vcf_file_uuid
    type: string
    outputSource: upload_outputs/var_vcf_file_uuid
  - id: sample_info_file_uuid
    type: string?
    outputSource: upload_outputs/sample_info_file_uuid
  - id: dnacopy_file_uuid
    type: string?
    outputSource: upload_outputs/dnacopy_seg_file_uuid
  - id: other_files_uuid
    type: string?
    outputSource: upload_outputs/other_files_uuid

steps:
  - id: get_inputs
    run: inout/get_inputs.cwl
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: bam_uuid
        source: bam_uuid
      - id: bam_filesize
        source: bam_filesize
      - id: bai_uuid
        source: bai_uuid
      - id: bai_filesize
        source: bai_filesize
      - id: fa_uuid
        source: fa_uuid
      - id: fa_filesize
        source: fa_filesize
      - id: fai_uuid
        source: fai_uuid
      - id: fai_filesize
        source: fai_filesize
      - id: bigwig_uuid
        source: bigwig_uuid
      - id: bigwig_filesize
        source: bigwig_filesize
      - id: gemindex_uuid
        source: gemindex_uuid
      - id: gemindex_filesize
        source: gemindex_filesize
    out: [fa_file, fai_file, bam_file, bai_file, bigwig_file, gemindex_file]
  
  - id: remove_nstd_variants
    run: auxiliary/remove_nonstandard_variants.cwl
    in:
      input_vcf:
        source: input_vcf_file
      output_filename:
        valueFrom: "std.vcf"
    out: [output_file]

  - id: mutect_gdcfiltration
    run: mutect_gdcfiltration_workflow.cwl
    scatter: run_without_normaldb
    in:
      run_without_normaldb:
        source: run_without_normaldb
      fa_file:
        source: get_inputs/fa_file
      fai_file:
        source: get_inputs/fai_file
      capture_file:
        source: capture_file
      input_vcf_file:
        source: remove_nstd_variants/output_file
      job_uuid:
        source: job_uuid
    out: [output_vcf_file]

  - id: purecn_gdcfiltration
    run: purecn_gdcfiltration_workflow.cwl
    scatter: run_with_normaldb
    in:
      run_with_normaldb:
        source: run_with_normaldb
      fa_file:
        source: get_inputs/fa_file
      fai_file:
        source: get_inputs/fai_file
      fa_version:
        source: fa_version
      bigwig_file:
        source: get_inputs/bigwig_file
      bam_file:
        source: get_inputs/bam_file
      bai_file:
        source: get_inputs/bai_file
      capture_file:
        source: capture_file
      input_vcf_file:
        source: remove_nstd_variants/output_file
      normaldb_file:
        source: normaldb_file
      target_weight_file:
        source: target_weight_file
      thread_num:
        source: thread_num
      job_uuid:
        source: job_uuid
      outinfo:
        valueFrom: "."
    out: [output_vcf_file, sample_info_file, dnacopy_seg_file, other_files]

  - id: merge_purecn_mutect_gdcfiltration
    run: merge_purecn_mutect_gdcfiltration.cwl
    in:
      no_normaldb_vcf_file:
        source: mutect_gdcfiltration/output_vcf_file
      normaldb_vcf_file:
        source: purecn_gdcfiltration/output_vcf_file
      sample_info_file:
        source: purecn_gdcfiltration/sample_info_file
      dnacopy_seg_file:
        source: purecn_gdcfiltration/dnacopy_seg_file
      other_files:
        source: purecn_gdcfiltration/other_files
    out:
      [output_vcf_file, output_sample_info_file, output_dnacopy_seg_file, output_other_files]
      
  - id: upload_outputs
    run: inout/cond_upload_outputs.cwl
    in:
      bioclient_config:
        source: bioclient_config
      bioclient_upload_bucket:
        source: bioclient_upload_bucket
      job_uuid:
        source: job_uuid
      var_vcf_file:
        source: merge_purecn_mutect_gdcfiltration/output_vcf_file
      sample_info_file:
        source: merge_purecn_mutect_gdcfiltration/output_sample_info_file
      dnacopy_seg_file:
        source: merge_purecn_mutect_gdcfiltration/output_dnacopy_seg_file
      other_files:
        source: merge_purecn_mutect_gdcfiltration/output_other_files
    out: [var_vcf_file_uuid, sample_info_file_uuid, dnacopy_seg_file_uuid, other_files_uuid]
