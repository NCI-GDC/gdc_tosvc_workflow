#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: bioclient_config
    type: File
  - id: bam_uuid
    type: string
  - id: bam_filesize
    type: long
  - id: bai_uuid
    type: string
  - id: bai_filesize
    type: long
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

outputs:
  - id: fa_file
    type: File
    outputSource: get_fa/output
  - id: fai_file
    type: File
    outputSource: get_fai/output
  - id: bam_file
    type: File
    outputSource: get_bam/output
  - id: bai_file
    type: File
    outputSource: get_bai/output
  - id: bigwig_file
    type: File
    outputSource: get_bigwig/output
  - id: gemindex_file
    type: File
    outputSource: get_gemindex/output

steps:
  - id: get_bam
    run: bio_client_download.cwl
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
    run: bio_client_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: bai_uuid
      - id: file_size
        source: bai_filesize
    out:
      - id: output
  - id: get_fa
    run: bio_client_download.cwl
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
    run: bio_client_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: fai_uuid
      - id: file_size
        source: fai_filesize
    out:
      - id: output
  - id: get_bigwig
    run: bio_client_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: bigwig_uuid
      - id: file_size
        source: bigwig_filesize
    out:
      - id: output
  - id: get_gemindex
    run: bio_client_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: gemindex_uuid
      - id: file_size
        source: gemindex_filesize
    out:
      - id: output
