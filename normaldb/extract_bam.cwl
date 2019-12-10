class: Workflow
cwlVersion: v1.0
id: extract_bam
doc: |
  extract bam files

inputs:
  - id: bioclient_config
    type: File
  - id: bam_uuid
    type: string
  - id: bam_index_uuid
    type: string
  - id: bam_size
    type: long
  - id: bam_index_size
    type: long

outputs:
  - id: output
    type: File
    outputSource: root_bam/output

steps:
  - id: extract_bam
    run: tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: bam_uuid
      - id: file_size
        source: bam_size
    out:
      - id: output

  - id: extract_bam_index
    run: tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: bam_index_uuid
      - id: file_size
        source: bam_index_size
    out:
      - id: output

  - id: root_bam
    run: tools/root_bam.cwl
    in:
      - id: bam
        source: extract_bam/output
      - id: bam_index
        source: extract_bam_index/output
    out:
      - id: output
