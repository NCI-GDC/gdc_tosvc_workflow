#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: fa_file
    type: File
  - id: fai_file
    type: File
  - id: dict_file
    type: File
  - id: dict_main_file
    type: File
  - id: input_vcf_file
    type: File
  - id: capture_file
    type: File
  - id: fa_name
    type: string
  - id: patient_barcode
    type: string
  - id: case_id
    type: string
  - id: aliquot_id
    type: string
  - id: bam_uuid
    type: string
  - id: sample_barcode
    type: string
  - id: job_uuid
    type: string
  - id: file_prefix
    type: string

outputs:
  - id: output_vcf_file
    type: File
    outputSource: format_header/output_vcf_file

steps:
  - id: filter_mutect
    run: gdcfiltration/filter_mutect_outputs.cwl
    in:
      sample_id:
        source: job_uuid
      fa_file:
        source: fa_file
      fai_file:
        source: fai_file
      input_vcf_file:
        source: input_vcf_file
      capture_file:
        source: capture_file
      output_vcf_filename:
        source: job_uuid
        valueFrom: $(self + ".variant_filtration.vcf")
    out: [output_vcf_file]

  - id: update_dictionary
    run: auxiliary/update_seq_dict.cwl
    in:
      input_vcf:
        source: filter_mutect/output_vcf_file
      sequence_dictionary:
        source: dict_main_file
      output_filename:
        source: file_prefix
        valueFrom: $(self + '.updatedseqdict.vcf')
    out: [output_file]

  - id: filter_contigs
    run: auxiliary/filter_contigs.cwl
    in:
      input_vcf:
        source: update_dictionary/output_file
      output_vcf:
        source: file_prefix
        valueFrom: $(self + '.updatedseqdict.contigfilter.vcf')
    out: [output_vcf_file]

  - id: format_header
    run: auxiliary/format_vcf_header.cwl
    in:
      input_vcf:
        source: filter_contigs/output_vcf_file
      output_vcf:
        source: file_prefix
        valueFrom: $(self + '.variant_filtration.vcf')
      reference_name:
        source: fa_name
      patient_barcode: 
        source: patient_barcode
      case_id:
        source: case_id
      tumor_barcode:
        source: sample_barcode
      tumor_aliquot_uuid:
        source: aliquot_id
      tumor_bam_uuid:
        source: bam_uuid
      normal_barcode:
        source: sample_barcode
      normal_aliquot_uuid:
        source: aliquot_id
      normal_bam_uuid:
        source: bam_uuid
    out: [output_vcf_file]
