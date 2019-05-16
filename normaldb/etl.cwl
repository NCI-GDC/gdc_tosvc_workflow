#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement
    
inputs:
  - id: bioclient_config
    type: File
  - id: bam_uuids
    type:
      type: array
      items: string
  - id: bam_index_uuids
    type:
      type: array
      items: string
  - id: bam_sizes
    type:
      type: array
      items: long
  - id: bam_index_sizes
    type:
      type: array
      items: long
  - id: bed_uuid
    type: string
  - id: bed_size
    type: long
  - id: bed_index_uuid
    type: string
  - id: bed_index_size
    type: long
  - id: fasta_uuid
    type: string
  - id: fasta_size
    type: long
  - id: fasta_index_uuid
    type: string
  - id: fasta_index_size
    type: long
  - id: bigwig_uuid
    type: string
  - id: bigwig_size
    type: long

outputs:
  []
  
steps:
  - id: extract_bams
    run: extract_bam.cwl
    scatter: [bam_uuid, bam_index_uuid, bam_size, bam_index_size]
    scatterMethod: "dotproduct"
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: bam_uuid
        source: bam_uuids
      - id: bam_index_uuid
        source: bam_index_uuids
      - id: bam_size
        source: bam_sizes
      - id: bam_index_size
        source: bam_index_sizes
    out:
      - id: output

  - id: extract_bed
    run: tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: bed_uuid
      - id: file_size
        source: bed_size
    out:
      - id: output

  - id: extract_bed_index
    run: tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: bed_index_uuid
      - id: file_size
        source: bed_index_size
    out:
      - id: output

  - id: extract_fasta
    run: tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: fasta_uuid
      - id: file_size
        source: fasta_size
    out:
      - id: output

  - id: extract_fasta_index
    run: tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: fasta_index_uuid
      - id: file_size
        source: fasta_index_size
    out:
      - id: output

  - id: extract_bigwig
    run: tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: bigwig_uuid
      - id: file_size
        source: bigwig_size
    out:
      - id: output

  - id: root_fasta
    run: tools/root_fasta.cwl
    in:
      - id: fasta
        source: extract_fasta/output
      - id: fasta_index
        source: extract_fasta_index/output
    out:
      - id: output

  - id: root_bed
    run: tools/root_bed.cwl
    in:
      - id: bed
        source: extract_bed/output
      - id: bed_index
        source: extract_bed_index/output
    out:
      - id: output

  - id: transform
    run: transform.cwl
    in:
      - id: bams
        source: extract_bams/output
      - id: bed
        source: root_bed/output
      - id: fasta
        source: root_fasta/output
      - id: bigwig
        source: extract_bigwig/output
    out:
      - id: output
