class: Workflow
cwlVersion: v1.0
id: extract
requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
doc: |
  extract inputs

inputs:
  bioclient_config: File
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

steps:
  tumor_bam_download:
    run: ../tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: tumor_bam_gdc_id
    out: [ output ]
  tumor_bai_download:
    run: ../tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: tumor_index_gdc_id
    out: [ output ]
  raw_vcf_download:
    run: ../tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: raw_vcf_gdc_id
    out: [ output ]
  raw_vcf_index_download:
    run: ../tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: raw_vcf_index_gdc_id
    out: [ output ]
  reference_fa_download:
    run: ../tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: reference_fa_gdc_id
    out: [ output ]
  reference_fai_download:
    run: ../tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: reference_fai_gdc_id
    out: [ output ]
  reference_dict_download:
    run: ../tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: reference_dict_gdc_id
    out: [ output ]
  main_dict_download:
    run: ../tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: reference_main_dict_gdc_id
    out: [ output ]
  capture_interval_download:
    run: ../tools/bioclient_cond_download.cwl
    in:
      config_file: bioclient_config
      download_handle: capture_interval_gdc_id
    out: [ output ]
  normaldb_download:
    run: ../tools/bioclient_cond_download.cwl
    in:
      config_file: bioclient_config
      download_handle: normaldb_gdc_id
    out: [ output ]
  stage:
    run: stage.cwl
    in:
      tumor_bam: tumor_bam_download/output
      tumor_bai: tumor_bai_download/output
      raw_vcf: raw_vcf_download/output
      raw_vcf_index: raw_vcf_index_download/output
      reference_fa: reference_fa_download/output
      reference_fai: reference_fai_download/output
      reference_dict: reference_dict_download/output
    out: [ tumor_with_index, raw_vcf_with_index, reference_with_index ]

outputs:
  tumor_with_index:
    type: File
    outputSource: stage/tumor_with_index
  raw_vcf_with_index:
    type: File
    outputSource: stage/raw_vcf_with_index
  reference_with_index:
    type: File
    outputSource: stage/reference_with_index
  main_reference_dict:
    type: File
    outputSource: main_dict_download/output
  capture_interval:
    type: File?
    outputSource: capture_interval_download/output
  normaldb:
    type: File?
    outputSource: normaldb_download/output
