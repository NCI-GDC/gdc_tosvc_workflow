class: Workflow
cwlVersion: v1.0
id: etl
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
doc: |
  extract transform load

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
  capture_interval_gdc_id: string?
  normaldb_gdc_id: string?
  # GRAPH
  job_uuid: string
  experimental_strategy: string
  project_id: string?
  caller_id:
    type: string
    default: "purecn"
  aliquot_id: string
  case_id: string
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
    run: ../main/subworkflows/extract.cwl
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
      capture_interval_gdc_id: capture_interval_gdc_id
      normaldb_gdc_id: normaldb_gdc_id
    out: [
      tumor_with_index,
      raw_vcf_with_index,
      reference_with_index,
      main_reference_dict,
      capture_interval,
      normaldb
    ]

  transform:
    run: ../main/subworkflows/transform.cwl
    in:
      job_uuid: job_uuid
      experimental_strategy: experimental_strategy
      project_id: project_id
      caller_id: caller_id
      aliquot_id: aliquot_id
      case_id: case_id
      bam_uuid: tumor_bam_gdc_id
      patient_barcode: patient_barcode
      sample_barcode: sample_barcode
      run_without_normaldb: run_without_normaldb
      run_with_normaldb: run_with_normaldb
      fasta_version: fasta_version
      fasta_name: fasta_name
      thread_num: thread_num
      seed: seed
      var_prob_thres: var_prob_thres
      reference: extract/reference_with_index
      tumor_bam: extract/tumor_with_index
      raw_vcf: extract/raw_vcf_with_index
      capture_interval: extract/capture_interval
      normaldb: extract/normaldb
      main_dict: extract/main_reference_dict
    out: [
      purecn_dnacopy_seg,
      purecn_filtration_metric,
      purecn_tar,
      annotated_vcf
    ]

  load:
    run: ../main/subworkflows/load.cwl
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
  filtered_vcf_uuid:
    type: string
    outputSource: load/filtered_vcf_uuid
  filtered_vcf_index_uuid:
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