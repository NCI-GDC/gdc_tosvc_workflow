#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  - id: bioclient_config
    type: File
  - id: bioclient_upload_bucket
    type: string
  - id: job_uuid
    type: string
  - id: var_vcf_file
    type: File
  - id: sample_info_file
    type: File
  - id: dnacopy_seg_file
    type: File
  - id: other_files
    type: File

outputs:
  - id: var_vcf_file_uuid
    type: string
    outputSource: upload_var_vcf_file/output_file_uuid
  - id: sample_info_file_uuid
    type: string
    outputSource: upload_sample_info_file/output_file_uuid
  - id: dnacopy_seg_file_uuid
    type: string
    outputSource: upload_dnacopy_seg_file/output_file_uuid
  - id: other_files_uuid
    type: string
    outputSource: upload_other_files/output_file_uuid

steps:
  - id: upload_var_vcf_file
    run: bioclient_upload.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: upload_bucket
        source: bioclient_upload_bucket
      - id: upload_key
        source: [job_uuid, var_vcf_file]
        valueFrom: $(self[0] + '/' + self[1].basename)
      - id: input_file
        source: var_vcf_file
    out: [output_file, output_file_uuid]
  - id: upload_sample_info_file
    run: bioclient_upload.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: upload_bucket
        source: bioclient_upload_bucket
      - id: upload_key
        source: [job_uuid, sample_info_file]
        valueFrom: $(self[0] + '/' + self[1].basename)
      - id: input_file
        source: sample_info_file
    out: [output_file, output_file_uuid]
  - id: upload_dnacopy_seg_file
    run: bioclient_upload.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: upload_bucket
        source: bioclient_upload_bucket
      - id: upload_key
        source: [job_uuid, dnacopy_seg_file]
        valueFrom: $(self[0] + '/' + self[1].basename)
      - id: input_file
        source: dnacopy_seg_file
    out: [output_file, output_file_uuid]
  - id: upload_other_files
    run: bioclient_upload.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: upload_bucket
        source: bioclient_upload_bucket
      - id: upload_key
        source: [job_uuid, other_files]
        valueFrom: $(self[0] + '/' + self[1].basename)
      - id: input_file
        source: other_files
    out: [output_file, output_file_uuid]
