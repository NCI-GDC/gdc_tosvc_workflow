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
  - id: filtered_vcf_file
    type: File
  - id: filtered_vcf_index_file
    type: File
  - id: sample_info_file
    type: File?
  - id: dnacopy_seg_file
    type: File?
  - id: archive_tar_file
    type: File?

outputs:
  - id: filtered_vcf_uuid
    type: string?
    outputSource: upload_filtered_vcf_file/output_file_uuid
  - id: filtered_vcf_index_uuid
    type: string?
    outputSource: upload_filtered_vcf_index_file/output_file_uuid
  - id: sample_info_uuid
    type: string?
    outputSource: upload_sample_info_file/output_file_uuid
  - id: dnacopy_seg_uuid
    type: string?
    outputSource: upload_dnacopy_seg_file/output_file_uuid
  - id: archive_tar_uuid
    type: string?
    outputSource: upload_archive_tar_file/output_file_uuid

steps:
  - id: upload_filtered_vcf_file
    run: bioclient_cond_upload.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: upload_bucket
        source: bioclient_upload_bucket
      - id: upload_key
        source: [job_uuid, filtered_vcf_file]
        valueFrom: $(self[0] + '/' + self[1].basename)
      - id: input_file
        source: filtered_vcf_file
    out: [output_file_uuid]

  - id: upload_filtered_vcf_index_file
    run: bioclient_cond_upload.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: upload_bucket
        source: bioclient_upload_bucket
      - id: upload_key
        source: [job_uuid, filtered_vcf_index_file]
        valueFrom: $(self[0] + '/' + self[1].basename)
      - id: input_file
        source: filtered_vcf_index_file
    out: [output_file_uuid]
    
  - id: upload_sample_info_file
    run: bioclient_cond_upload.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: upload_bucket
        source: bioclient_upload_bucket
      - id: upload_key
        source: [job_uuid, sample_info_file]
        valueFrom: |
          ${
             if(self[1] != null) {
               return self[0] + '/' + self[1].basename;
             } else {
               return null
             }
           }
      - id: input_file
        source: sample_info_file
    out: [output_file_uuid]
    
  - id: upload_dnacopy_seg_file
    run: bioclient_cond_upload.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: upload_bucket
        source: bioclient_upload_bucket
      - id: upload_key
        source: [job_uuid, dnacopy_seg_file]
        valueFrom: |
          ${
             if(self[1] != null) {
               return self[0] + '/' + self[1].basename;
             } else {
               return null
             }
           }
      - id: input_file
        source: dnacopy_seg_file
    out: [output_file_uuid]
    
  - id: upload_archive_tar_file
    run: bioclient_cond_upload.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: upload_bucket
        source: bioclient_upload_bucket
      - id: upload_key
        source: [job_uuid, archive_tar_file]
        valueFrom: |
          ${
             if(self[1] != null) {
               return self[0] + '/' + self[1].basename;
             } else {
               return null
             }
           }
      - id: input_file
        source: archive_tar_file
    out: [output_file_uuid]
