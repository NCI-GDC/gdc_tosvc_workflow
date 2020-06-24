class: Workflow
cwlVersion: v1.0
id: load
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
doc: |
  upload results

inputs:
  bioclient_config: File
  bioclient_upload_bucket: string
  job_uuid: string
  filtered_vcf_file: File
  filtration_metric_file: File?
  dnacopy_seg_file: File?
  archive_tar_file: File?

outputs:
  filtered_vcf_uuid:
    type: string
    outputSource: upload_filtered_vcf_file/output_file_uuid
  filtered_vcf_index_uuid:
    type: string
    outputSource: upload_filtered_vcf_index_file/output_file_uuid
  filtration_metric_uuid:
    type: string?
    outputSource: upload_filtration_metric_file/output_file_uuid
  dnacopy_seg_uuid:
    type: string?
    outputSource: upload_dnacopy_seg_file/output_file_uuid
  archive_tar_uuid:
    type: string?
    outputSource: upload_archive_tar_file/output_file_uuid

steps:
  upload_filtered_vcf_file:
    run: ../tools/bioclient_cond_upload.cwl
    in:
      config_file: bioclient_config
      upload_bucket: bioclient_upload_bucket
      upload_key:
        source: [job_uuid, filtered_vcf_file]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input_file: filtered_vcf_file
    out: [output_file_uuid]

  upload_filtered_vcf_index_file:
    run: ../tools/bioclient_cond_upload.cwl
    in:
      config_file: bioclient_config
      upload_bucket: bioclient_upload_bucket
      upload_key:
        source: [job_uuid, filtered_vcf_file]
        valueFrom: $(self[0] + '/' + self[1].secondaryFiles[0].basename)
      input_file:
        source: filtered_vcf_file
        valueFrom: $(self.secondaryFiles[0])
    out: [output_file_uuid]

  upload_filtration_metric_file:
    run: ../tools/bioclient_cond_upload.cwl
    in:
      config_file: bioclient_config
      upload_bucket: bioclient_upload_bucket
      upload_key:
        source: [job_uuid, filtration_metric_file]
        valueFrom: |
          ${
             if(self[1] != null) {
               return self[0] + '/' + self[1].basename;
             } else {
               return null
             }
           }
      input_file: filtration_metric_file
    out: [output_file_uuid]

  upload_dnacopy_seg_file:
    run: ../tools/bioclient_cond_upload.cwl
    in:
      config_file: bioclient_config
      upload_bucket: bioclient_upload_bucket
      upload_key:
        source: [job_uuid, dnacopy_seg_file]
        valueFrom: |
          ${
             if(self[1] != null) {
               return self[0] + '/' + self[1].basename;
             } else {
               return null
             }
           }
      input_file: dnacopy_seg_file
    out: [output_file_uuid]

  upload_archive_tar_file:
    run: ../tools/bioclient_cond_upload.cwl
    in:
      config_file: bioclient_config
      upload_bucket: bioclient_upload_bucket
      upload_key:
        source: [job_uuid, archive_tar_file]
        valueFrom: |
          ${
             if(self[1] != null) {
               return self[0] + '/' + self[1].basename;
             } else {
               return null
             }
           }
      input_file: archive_tar_file
    out: [output_file_uuid]
