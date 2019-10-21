#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

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
  bigwig_gdc_id: string
  capture_kit_gdc_id: string
  gemindex_gdc_id: string
  intervalweightfile_gdc_id: string
  normaldb_gdc_id: string

steps:
  tumor_bam_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: tumor_bam_gdc_id
    out: [ output ]
  tumor_bai_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: tumor_index_gdc_id
    out: [ output ]
  raw_vcf_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: raw_vcf_gdc_id
    out: [ output ]
  raw_vcf_index_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: raw_vcf_index_gdc_id
    out: [ output ]
  reference_fa_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: reference_fa_gdc_id
    out: [ output ]
  reference_fai_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: reference_fai_gdc_id
    out: [ output ]
  reference_dict_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: reference_dict_gdc_id
    out: [ output ]
  main_dict_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: reference_main_dict_gdc_id
    out: [ output ]
  bigwig_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: bigwig_gdc_id
    out: [ output ]
  capture_kit_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: capture_kit_gdc_id
    out: [ output ]
  gemindex_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: gemindex_gdc_id
    out: [ output ]
  intervalweight_download:
    run: tools/bio_client_download.cwl
    in:
      config_file: bioclient_config
      download_handle: intervalweightfile_gdc_id
    out: [ output ]
  normaldb_download:
    run: tools/bio_client_download.cwl
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
  bigwig:
    type: File
    outputSource: bigwig_download/output
  capture_kit:
    type: File
    outputSource: capture_kit_download/output
  gemindex:
    type: File
    outputSource: gemindex_download/output
  intervalweightfile:
    type: File
    outputSource: intervalweight_download/output
  normaldb:
    type: File
    outputSource: normaldb_download/output
