#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: bioclient_config
    type: File
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
  - id: bam_uuid
    type: string
  - id: bam_filesize
    type: long
  - id: bai_uuid
    type: string
  - id: bai_filesize
    type: long
  - id: vcf_uuid
    type: string
  - id: vcf_filesize
    type: long

outputs:
  - id: fa_file
    type: File
    outputSource: get_fa/output
  - id: fai_file
    type: File
    outputSource: get_fai/output
  - id: dict_file
    type: File
    outputSource: get_dict/output
  - id: fa_main_file
    type: File
    outputSource: get_fa_main/output
  - id: fai_main_file
    type: File
    outputSource: get_fai_main/output
  - id: dict_main_file
    type: File
    outputSource: get_dict_main/output
  - id: bam_file
    type: File
    outputSource: get_bam/output
  - id: bai_file
    type: File
    outputSource: get_bai/output
  - id: vcf_file
    type: File
    outputSource: get_vcf/output

steps:
  - id: get_fa
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: fa_uuid
      - id: file_size
        source: fa_filesize
    out:
      - id: output
  - id: get_fai
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: fai_uuid
      - id: file_size
        source: fai_filesize
    out:
      - id: output
  - id: get_dict
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: dict_uuid
      - id: file_size
        source: dict_filesize
    out:
      - id: output
  - id: get_fa_main
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: fa_main_uuid
      - id: file_size
        source: fa_main_filesize
    out:
      - id: output
  - id: get_fai_main
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: fai_main_uuid
      - id: file_size
        source: fai_main_filesize
    out:
      - id: output
  - id: get_dict_main
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: dict_main_uuid
      - id: file_size
        source: dict_main_filesize
    out:
      - id: output
  - id: get_bam
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: bam_uuid
      - id: file_size
        source: bam_filesize
    out:
      - id: output
  - id: get_bai
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: bai_uuid
      - id: file_size
        source: bai_filesize
    out:
      - id: output
  - id: get_vcf
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: vcf_uuid
      - id: file_size
        source: vcf_filesize
    out:
      - id: output
