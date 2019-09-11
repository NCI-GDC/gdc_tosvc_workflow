#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  #ref info
  - id: bioclient_config
    type: File
  - id: bioclient_upload_bucket
    type: string
  - id: job_uuid
    type: string
  - id: case_id
    type: string
  - id: aliquot_id
    type: string
  - id: patient_barcode
    type: string
  - id: sample_barcode
    type: string
  - id: project_id
    type: string?
    doc: GDC project id used for output filenames
  - id: caller_id
    type: string?
    doc: GDC caller id used for output filenames
  - id: experimental_strategy
    type: string
    doc: GDC experimental strategy used for output filenames

  #full ref files
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

  #main ref files
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

  #input data for pipeline
  - id: bam_uuid
    type: string
  - id: bam_filesize
    type: long
  - id: bai_uuid
    type: string
  - id: bai_filesize
    type: long
  - id: input_vcf_uuid
    type: string
  - id: input_vcf_filesize
    type: long

  #GEM and PureCN ref files (optional)
  - id: capture_kit_uuid
    type: string?
  - id: capture_kit_filesize
    type: long?
  - id: bigwig_uuid
    type: string?
  - id: bigwig_filesize
    type: long?
  - id: gemindex_uuid
    type: string?
  - id: gemindex_filesize
    type: long?
  - id: normaldb_uuid
    type: string?
  - id: normaldb_filesize
    type: long?
  - id: target_weight_uuid
    type: string?
  - id: target_weight_filesize
    type: long?

 #parameters
  - id: fa_name
    type: string
    default: "GRCh38.d1.vd1.fa"
    doc: reference name used in the VCF header
  - id: fa_version
    type: string
    default: "hg38"
    doc: reference version used by PureCN
  - id: thread_num
    type: int
    default: 8
    doc: number of thread used by PureCN and some other tools
  - id: var_prob_thres
    type: float
    default: 0.2
    doc: threshold for posterior probability of somatic variants calculated by PureCN |
         this threshold is used in the filtering step
  - id: gem_max_mismatch
    type: int
    default: 2
  - id: gem_max_edit
    type: int
    default: 2

  #conditional inputs
  - id: run_with_normaldb
    type:
      type: array
      items: int
  - id: run_without_normaldb
    type:
      type: array
      items: int

outputs:
  - id: filtered_vcf_uuid
    type: string
    outputSource: upload_outputs/filtered_vcf_uuid
  - id: filtered_vcf_index_uuid
    type: string
    outputSource: upload_outputs/filtered_vcf_index_uuid
  - id: filtration_metric_uuid
    type: string?
    outputSource: upload_outputs/filtration_metric_uuid
  - id: dnacopy_seg_uuid
    type: string?
    outputSource: upload_outputs/dnacopy_seg_uuid
  - id: archive_tar_uuid
    type: string?
    outputSource: upload_outputs/archive_tar_uuid

steps:
  - id: extract_fa
    run: tools/bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: fa_uuid
      - id: file_size
        source: fa_filesize
    out:
      - id: output

  - id: extract_fai
    run: tools/bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: fai_uuid
      - id: file_size
        source: fai_filesize
    out:
      - id: output

  - id: extract_dict
    run: tools/bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: dict_uuid
      - id: file_size
        source: dict_filesize
    out:
      - id: output

  - id: extract_fa_main
    run: tools/bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: fa_main_uuid
      - id: file_size
        source: fa_main_filesize
    out:
      - id: output

  - id: extract_fai_main
    run: tools/bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: fai_main_uuid
      - id: file_size
        source: fai_main_filesize
    out:
      - id: output

  - id: extract_dict_main
    run: tools/bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: dict_main_uuid
      - id: file_size
        source: dict_main_filesize
    out:
      - id: output

  - id: extract_bam
    run: tools/bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: bam_uuid
      - id: file_size
        source: bam_filesize
    out:
      - id: output

  - id: extract_bai
    run: tools/bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: bai_uuid
      - id: file_size
        source: bai_filesize
    out:
      - id: output

  - id: extract_vcf
    run: tools/bioclient_download.cwl
    in:
      - id: config_file
        source: bioclient_config
      - id: download_handle
        source: vcf_uuid
      - id: file_size
        source: vcf_filesize
    out:
      - id: output

  - id: extract_with_normaldb
    run: subworkflows/extract_with_normaldb.cwl
    scatter: run_with_normaldb
    in:
      - id: run_with_normaldb
        source: run_with_normaldb
      - id: bioclient_config
        source: bioclient_config
      - id: capture_kit_uuid
        source: capture_kit_uuid
      - id: capture_kit_filesize
        source: capture_kit_filesize
      - id: bigwig_uuid
        source: bigwig_uuid
      - id: bigwig_filesize
        source: bigwig_filesize
      - id: gemindex_uuid
        source: gemindex_uuid
      - id: gemindex_filesize
        source: gemindex_filesize
      - id: normaldb_uuid
        source: normaldb_uuid
      - id: target_weight_uuid
        source: target_weight_uuid
      - id: target_weight_filesize
        source: target_weight_filesize
    out:
      - id: bigwig
      - id: capture_kit
      - id: gemindex
      - id: normaldb
      - id: target_weight
        
  - id: transform
    run: transform.cwl
    in:
      - id: fa
        source: extract_fa/output
      - id: fai
        source: extract_fai/output
      - id: dict
        source: extract_dict/output
      - id: fa_main
        source: extract_fa_main/output
      - id: fai_main
        source: extract_fai_main/output
      - id: dict_main
        source: extract_dict_main/output
      - id: bam
        source: extract_bam/output
      - id: bai
        source: extract_bai/output
      - id: vcf
        source: extract_vcf/output
      - id: job_uuid
        source: job_uuid
      - id: aliquot_id
        source: aliquot_id
      - id: case_id
        source: case_id
      - id: project_id
        source: project_id
      - id: caller_id
        source: caller_id
      - id: experimental_strategy
        source: experimental_strategy
      - id: run_with_normaldb
        source: run_with_normaldb
      - id: capture_kit
        source: extract_with_normaldb/capture_kit
      - id: bigwig
        source: extract_with_normaldb/bigwig
      - id: gemindex
        source: extract_with_normaldb/gemindex
      - id: normaldb
        source: extract_with_normaldb/normaldb
      - id: target_weight
        source: extract_with_normaldb/target_weight
  out:
    - id: vcf
    - id: filtration_metric
    - id: dnacopy_seg
    - id: tar

  - id: load_vcf
    run: tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/output_vcf
      - id: upload-bucket
        source: bioclient_load_bucket
      - id: upload-key
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      - id: job_uuid
        source: job_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_vcf_index
    run: tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/output_vcf
        valueFrom: $(self.secondaryFiles[0])
      - id: upload-bucket
        source: bioclient_load_bucket
      - id: upload-key
        valueFrom: $(inputs.job_uuid)/$(inputs.input.secondaryFiles[0])
      - id: job_uuid
        source: job_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_filtration_metric
    run: tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/
      - id: upload-bucket
        source: bioclient_load_bucket
      - id: upload-key
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      - id: job_uuid
        source: job_uuid
        valueFrom: $(null)

  - id: load_dnacopy_seg
    run: tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/
      - id: upload-bucket
        source: bioclient_load_bucket
      - id: upload-key
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      - id: job_uuid
        source: job_uuid
        valueFrom: $(null)

  - id: load_tar
    run: tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/
      - id: upload-bucket
        source: bioclient_load_bucket
      - id: upload-key
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      - id: job_uuid
        source: job_uuid
        valueFrom: $(null)

  - id: emit_vcf_uuid
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: load_vcf/output
      - id: key
        valueFrom: did
    out:
      - id: output

