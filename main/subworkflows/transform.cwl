#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
  #ref info
  - id: aliquotid
    type: string
  - id: callerid
    type: [string, "null"]
  - id: caseid
    type: string
  - id: experimental_strategy
    type: string
  - id: job_uuid
    type: string
  - id: patient_barcode
    type: string
  - id: projectid
    type: [string, "null"]
  - id: sample_barcode
    type: string

  #full ref files
  - id: fasta
    type: File
    secondaryFiles:
      - .fai
  - id: dict
    type: File

  #main ref files
  - id: fasta_main
    type: File
    secondaryFiles:
      - .fai
  - id: dict_main
    type: File

  #input data for pipeline
  - id: bam
    type: File
    secondaryFiles:
      - ^.bai
  - id: vcf
    type: File

  #GEM and PureCN ref files (optional)
  - id: capture_kit
    type: [File, "null"]
  - id: bigwig
    type: [File, "null"]
  - id: gemindex
    type: [File, "null"]
  - id: normaldb
    type: [File, "null"]
  - id: intervalweightfile
    type: [File, "null"]

 #parameters
  - id: fasta_name
    type: string
    default: "GRCh38.d1.vd1.fa"
    doc: reference name used in the VCF header

  - id: fasta_version
    type: string
    default: "hg38"
    doc: reference version used by PureCN

  - id: thread_num
    type: long
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
  []
  # - id: filtered_vcf_uuid
  #   type: string
  #   outputSource: upload_outputs/filtered_vcf_uuid
  # - id: filtered_vcf_index_uuid
  #   type: string
  #   outputSource: upload_outputs/filtered_vcf_index_uuid
  # - id: filtration_metric_uuid
  #   type: [string, "null"]
  #   outputSource: upload_outputs/filtration_metric_uuid
  # - id: dnacopy_seg_uuid
  #   type: [string, "null"]
  #   outputSource: upload_outputs/dnacopy_seg_uuid
  # - id: archive_tar_uuid
  #   type: [string, "null"]
  #   outputSource: upload_outputs/archive_tar_uuid

steps:
  - id: get_filename_prefix
    run: tools/make_file_prefix.cwl
    in:
      - id: job_uuid
        source: job_uuid
      - id: projectid
        source: projectid
      - id: callerid
        source: callerid
      - id: experimental_strategy
        source: experimental_strategy
    out:
      - id: output

  - id: remove_nonstandard_variants
    run: tools/remove_nonstandard_variants.cwl
    in:
      - id: input
        source: vcf
      - id: output
        valueFrom: "std.vcf"
    out:
      - id: output

  - id: filter_mutect_outputs
    run: tools/filter_mutect_outputs.cwl
    scatter: run_without_normaldb
    in:
      - id: run_without_normaldb
        source: run_without_normaldb
      - id: input
        source: remove_nonstandard_variants/output
      - id: output
        source: remove_nonstandard_variants/output
        valueFrom: $(self.basename).filtered_mutect.vcf
    out:
      - id: output

  - id: purecn_gdcfiltration
    run: purecn_gdcfiltration.cwl
    scatter: run_with_normaldb
    in:
      - id: run_with_normaldb
        source: run_with_normaldb
      - id: aliquotid
        source: aliquotid
      - id: bam
        source: bam
      - id: bigwig
        source: bigwig
      - id: capture_kit
        source: capture_kit
      - id: dict
        source: dict
      - id: dict_main
        source: dict_main
      - id: fasta
        source: fasta
      - id: fasta_version
        source: fasta_version
      - id: filename_prefix
        source: get_filename_prefix/output
      - id: gemindex
        source: gemindex
      - id: intervalweightfile
        source: intervalweightfile
      - id: normaldb
        source: normaldb
      - id: thread_num
        source: thread_num
      - id: vcf
        source: vcf
      - id: var_prob_thres
        source: var_prob_thres
    out:
      - id: dnacopy_seg
      - id: filtration_metric
      - id: tar
      - id: vcf

  - id: determine_purecn_gdcfiltration
    run: tools/determine_purecn_gdcfiltration.cwl
    in:
      - id: archive_tar_file
        source: purecn_gdcfiltration/tar
      - id: dnacopy_seg_file
        source: purecn_gdcfiltration/dnacopy_seg
      - id: filtration_metric_file
        source: purecn_gdcfiltration/filtration_metric
      - id: normaldb_vcf_file
        source: purecn_gdcfiltration/vcf
      - id: no_normaldb_vcf_file
        source: filter_mutect_outputs/output
    out:
      - id: output_vcf_file
      - id: output_filtration_metric_file
      - id: output_dnacopy_seg_file
      - id: output_archive_tar_file

  # - id: gdcreannotation
  #   run: gdcreannotation.cwl
  #   in:
  #     - id: vcf
  #       source: determine_purecn_gdcfiltration/output_vcf_file
  #     - id: dict_main
  #       source: get_inputs/dict_main_file
  #     - id: fa_name
  #       source: fa_name
  #     - id: patient_barcode
  #       source: patient_barcode
  #     - id: case_id
  #       source: case_id
  #     - id: aliquot_id
  #       source: aliquot_id
  #     - id: bam_uuid
  #       source: bam_uuid
  #     - id: sample_barcode
  #       source: sample_barcode
  #     - id: filename_prefix
  #       source: get_filename_prefix/output
  #   out:
  #     - id: output
