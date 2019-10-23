#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  # BIOCLIENT
  bioclient_config: File
  bioclient_upload_bucket: string
  # INPUT
  tumor_bam_gdc_id: string
  tumor_index_gdc_id: string
  raw_vcf_gdc_id: string
  raw_vcf_index_gdc_id: string
  reference_fa_gdc_id: string
  reference_fai_gdc_id: string
  reference_dict_gdc_id: string
  reference_main_dict_gdc_id: string
  bigwig_gdc_id: string
  capture_kit_gdc_id: string
  gemindex_gdc_id: string
  intervalweightfile_gdc_id: string
  normaldb_gdc_id: string
  # GRAPH
  job_uuid: string
  experimental_strategy: string
  project_id: string?
  caller_id:
    type: string
    default: "purecn"
  aliquot_id: string
  case_id: string
  bam_uuid: string
  patient_barcode: string
  sample_barcode: string
  # PARAMETER
  run_with_normaldb:
    type:
      type: array
      items: int
  run_without_normaldb:
    type:
      type: array
      items: int
  fasta_name:
    type: string
    default: "GRCh38.d1.vd1.fa"
  fasta_version:
    type: string
    default: "hg38"
  thread_num:
    type: long
    default: 8
  seed:
    type: long
    default: 123
  var_prob_thres:
    type: float
    default: 0.2

steps:
  extract:
    run: subworkflows/extract.cwl
    in:
      bioclient_config: bioclient_config
      tumor_bam_gdc_id: tumor_bam_gdc_id
      tumor_index_gdc_id: tumor_index_gdc_id
      raw_vcf_gdc_id: raw_vcf_gdc_id
      raw_vcf_index_gdc_id: raw_vcf_index_gdc_id
      reference_fa_gdc_id: reference_fa_gdc_id
      reference_fai_gdc_id: reference_fai_gdc_id
      reference_dict_gdc_id: reference_dict_gdc_id
      reference_main_dict_gdc_id: reference_main_dict_gdc_id
      bigwig_gdc_id: bigwig_gdc_id
      capture_kit_gdc_id: capture_kit_gdc_id
      gemindex_gdc_id: gemindex_gdc_id
      intervalweightfile_gdc_id: intervalweightfile_gdc_id
      normaldb_gdc_id: normaldb_gdc_id
    out: [
      tumor_with_index,
      raw_vcf_with_index,
      reference_with_index,
      main_reference_dict,
      bigwig,
      capture_kit,
      gemindex,
      intervalweightfile,
      normaldb
    ]

  transform:
    run: subworkflows/transform.cwl
    in:
      job_uuid: job_uuid
      experimental_strategy: experimental_strategy
      project_id: project_id
      caller_id: caller_id
      aliquot_id: aliquot_id
      case_id: case_id
      bam_uuid: bam_uuid
      patient_barcode: patient_barcode
      sample_barcode: sample_barcode
      run_without_normaldb: run_without_normaldb
      run_with_normaldb: run_with_normaldb
      fasta_version: fasta_version
      fasta_name: fasta_name
      thread_num: thread_num
      seed: seed
      var_prob_thres: var_prob_thres
      tumor_bam: extract/tumor_with_index
      raw_vcf: extract/raw_vcf_with_index
      reference: extract/reference_with_index
      main_dict: extract/main_reference_dict
      bigwig: extract/bigwig
      capture_kit: extract/capture_kit
      gemindex: extract/gemindex
      intervalweightfile: extract/intervalweightfile
      normaldb: extract/normaldb
    out: [
      purecn_dnacopy_seg,
      purecn_filtration_metric,
      purecn_tar,
      annotated_vcf
    ]

  load:
    run: subworkflows/load.cwl
    in:
      bioclient_config: bioclient_config
      bioclient_upload_bucket: bioclient_upload_bucket
      job_uuid: job_uuid
      filtered_vcf_file: transform/annotated_vcf
      filtration_metric_file: transform/purecn_filtration_metric
      dnacopy_seg_file: transform/purecn_dnacopy_seg
      archive_tar_file: transform/purecn_tar
    out: [
      filtered_vcf_uuid,
      filtered_vcf_index_uuid,
      filtration_metric_uuid,
      dnacopy_seg_uuid,
      archive_tar_uuid
    ]

outputs:
  annotated_vcf_uuid:
    type: string
    outputSource: load/filtered_vcf_uuid
  annotated_vcf_index_uuid:
    type: string
    outputSource: load/filtered_vcf_index_uuid
  filtration_metric_uuid:
    type: string?
    outputSource: load/filtration_metric_uuid
  dnacopy_seg_uuid:
    type: string?
    outputSource: load/dnacopy_seg_uuid
  archive_tar_uuid:
    type: string?
    outputSource: load/archive_tar_uuid