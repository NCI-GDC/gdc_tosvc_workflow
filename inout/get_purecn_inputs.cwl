#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: bioclient_config
    type: File

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
  - id: capture_kit_file
    type: File
    outputSource: get_capture_kit/output
  - id: bigwig_file
    type: File?
    outputSource: get_bigwig/output
  - id: gemindex_file
    type: File?
    outputSource: get_gemindex/output
  - id: normaldb_file
    type: File?
    outputSource: get_normaldb/output
  - id: target_weight_file
    type: File?
    outputSource: get_target_weight/output

steps:
  - id: get_capture_kit
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: capture_kit_uuid
      - id: file_size
        source: capture_kit_filesize
    out:
      - id: output
  - id: get_bigwig
    run: bioclient_download.cwl
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
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: gemindex_uuid
      - id: file_size
        source: gemindex_filesize
    out:
      - id: output
  - id: get_normaldb
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: normaldb_uuid
      - id: file_size
        source: normaldb_filesize
    out:
      - id: output
  - id: get_target_weight
    run: bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: target_weight_uuid
      - id: file_size
        source: target_weight_filesize
    out:
      - id: output
