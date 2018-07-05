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
  - id: bioclient_config
    type: File
  - id: bioclient_upload_bucket
    type: string
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
    type: string?
    doc: GDC project id used for output filenames
  - id: caller_id
    type: string?
    doc: GDC caller id used for output filenames
  - id: experimental_strategy
    type: string
    doc: GDC experimental strategy used for output filenames
  
  #full ref files
  - id: fa_uuid
    type: string
  - id: fa_filesize
    type: long
  - id: fai_uuid
    type: string
  - id: fai_filesize
    type: long
  - id: dict_uuid
    type: string
  - id: dict_filesize
    type: long

  #main ref files
  - id: fa_main_uuid
    type: string
  - id: fa_main_filesize
    type: long
  - id: fai_main_uuid
    type: string
  - id: fai_main_filesize
    type: long
  - id: dict_main_uuid
    type: string
  - id: dict_main_filesize
    type: long

  #input data for pipeline
  - id: bam_uuid
    type: string
  - id: bam_filesize
    type: long
  - id: bai_uuid
    type: string
  - id: bai_filesize
    type: long
  - id: input_vcf_uuid
    type: string
  - id: input_vcf_filesize
    type: long
  - id: capture_uuid
    type: string
  - id: capture_filesize
    type: long
    
  #GEM and PureCN ref files (optional)
  - id: bigwig_uuid
    type: string?
  - id: bigwig_filesize
    type: long?
  - id: gemindex_uuid
    type: string?
  - id: gemindex_filesize
    type: long?
  - id: normaldb_uuid
    type: string?
  - id: normaldb_filesize
    type: long?
  - id: target_weight_uuid
    type: string?
  - id: target_weight_filesize
    type: long?

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
  - id: filtered_vcf_uuid
    type: string
    outputSource: upload_outputs/filtered_vcf_uuid
  - id: filtered_vcf_index_uuid
    type: string
    outputSource: upload_outputs/filtered_vcf_index_uuid
  - id: sample_info_uuid
    type: string?
    outputSource: upload_outputs/sample_info_uuid
  - id: dnacopy_seg_uuid
    type: string?
    outputSource: upload_outputs/dnacopy_seg_uuid
  - id: archive_tar_uuid
    type: string?
    outputSource: upload_outputs/archive_tar_uuid

steps:
  - id: get_inputs
    run: inout/get_inputs.cwl
    in:
      - id: bioclient_config
        source: bioclient_config

      - id: fa_uuid
        source: fa_uuid
      - id: fa_filesize
        source: fa_filesize
      - id: fai_uuid
        source: fai_uuid
      - id: fai_filesize
        source: fai_filesize
      - id: dict_uuid
        source: dict_uuid
      - id: dict_filesize
        source: dict_filesize

      - id: fa_main_uuid
        source: fa_uuid
      - id: fa_main_filesize
        source: fa_filesize
      - id: fai_main_uuid
        source: fai_uuid
      - id: fai_main_filesize
        source: fai_filesize
      - id: dict_main_uuid
        source: dict_main_uuid
      - id: dict_main_filesize
        source: dict_main_filesize

      - id: bam_uuid
        source: bam_uuid
      - id: bam_filesize
        source: bam_filesize
      - id: bai_uuid
        source: bai_uuid
      - id: bai_filesize
        source: bai_filesize
      - id: vcf_uuid
        source: input_vcf_uuid
      - id: vcf_filesize
        source: input_vcf_filesize
      - id: capture_uuid
        source: capture_uuid
      - id: capture_filesize
        source: capture_filesize

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

    out: [fa_file, fai_file, dict_file, fa_main_file, fai_main_file, dict_main_file, bam_file, bai_file, vcf_file, capture_file, bigwig_file, gemindex_file, normaldb_file, target_weight_file]
  
  - id: get_filename_prefix
    run: auxiliary/make_file_prefix.cwl
    in:
      - id: job_uuid
        source: job_uuid
      - id: project_id
        source: project_id
      - id: caller_id
        source: caller_id
      - id: experimental_strategy
        source: experimental_strategy
    out: [output]

  - id: remove_nstd_variants
    run: auxiliary/remove_nonstandard_variants.cwl
    in:
      input_vcf:
        source: get_inputs/vcf_file
      output_filename:
        valueFrom: "std.vcf"
    out: [output_vcf]

  - id: gdcfiltration
    run: gdcfiltration_workflow.cwl
    scatter: run_without_normaldb
    in:
      run_without_normaldb:
        source: run_without_normaldb
      fa_file:
        source: get_inputs/fa_file
      fai_file:
        source: get_inputs/fai_file
      dict_file:
        source: get_inputs/dict_file
      dict_main_file:
        source: get_inputs/dict_main_file
      input_vcf_file:
        source: remove_nstd_variants/output_vcf
      capture_file:
        source: get_inputs/capture_file
      bam_uuid:
        source: bam_uuid
      fa_name:
        source: fa_name
      patient_barcode:
        source: patient_barcode
      case_id:
        source: case_id
      aliquot_id:
        source: aliquot_id
      sample_barcode:
        source: sample_barcode
      job_uuid:
        source: job_uuid
      file_prefix:
        source: get_filename_prefix/output
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
      dict_file:
        source: get_inputs/dict_file
      dict_main_file:
        source: get_inputs/dict_main_file
      bam_file:
        source: get_inputs/bam_file
      bai_file:
        source: get_inputs/bai_file
      input_vcf_file:
        source: remove_nstd_variants/output_vcf
      capture_file:
        source: get_inputs/capture_file
      bigwig_file:
        source: get_inputs/bigwig_file
      normaldb_file:
        source: get_inputs/normaldb_file
      target_weight_file:
        source: get_inputs/target_weight_file
      fa_name:
        source: fa_name
      fa_version:
        source: fa_version
      sample_barcode:
        source: sample_barcode
      bam_uuid:
        source: bam_uuid
      patient_barcode:
        source: patient_barcode
      aliquot_id:
        source: aliquot_id
      case_id:
        source: case_id
      thread_num:
        source: thread_num
      var_prob_thres:
        source: var_prob_thres
      file_prefix:
        source: get_filename_prefix/output
      outinfo:
        valueFrom: "."
    out: [output_vcf_file, sample_info_file, dnacopy_seg_file, archive_tar_file]

  - id: determine_purecn_gdcfiltration
    run: determine_purecn_gdcfiltration.cwl
    in:
      no_normaldb_vcf_file:
        source: gdcfiltration/output_vcf_file
      normaldb_vcf_file:
        source: purecn_gdcfiltration/output_vcf_file
      sample_info_file:
        source: purecn_gdcfiltration/sample_info_file
      dnacopy_seg_file:
        source: purecn_gdcfiltration/dnacopy_seg_file
      archive_tar_file:
        source: purecn_gdcfiltration/archive_tar_file
    out:
      [output_vcf_file, output_sample_info_file, output_dnacopy_seg_file, output_archive_tar_file]

  - id: sort_vcf_file
    run: auxiliary/sort_vcf_file.cwl
    in:
      input_vcf:
        source: determine_purecn_gdcfiltration/output_vcf_file
      output_filename:
        source: determine_purecn_gdcfiltration/output_vcf_file
        valueFrom: $(self.basename + ".gz")
    out:
      [output_vcf_file, output_vcf_index_file]

  - id: upload_outputs
    run: inout/cond_upload_outputs.cwl
    in:
      bioclient_config:
        source: bioclient_config
      bioclient_upload_bucket:
        source: bioclient_upload_bucket
      job_uuid:
        source: job_uuid
      filtered_vcf_file:
        source: sort_vcf_file/output_vcf_file
      filtered_vcf_index_file:
        source: sort_vcf_file/output_vcf_index_file
      sample_info_file:
        source: determine_purecn_gdcfiltration/output_sample_info_file
      dnacopy_seg_file:
        source: determine_purecn_gdcfiltration/output_dnacopy_seg_file
      archive_tar_file:
        source: determine_purecn_gdcfiltration/output_archive_tar_file
    out: [filtered_vcf_uuid, filtered_vcf_index_uuid, sample_info_uuid, dnacopy_seg_uuid, archive_tar_uuid]

