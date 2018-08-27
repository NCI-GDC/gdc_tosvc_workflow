#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: input_vcf_file
    type: File
  - id: dict_main_file
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
  - id: filename_prefix
    type: string

outputs:
  - id: output_vcf_file
    type: File
    outputSource: convert_vcf_format/output_vcf_file

steps:
  - id: update_dictionary
    run: update_seq_dict.cwl
    in:
      input_vcf:
        source: input_vcf_file
      sequence_dictionary:
        source: dict_main_file
      output_filename:
        source: input_vcf_file
        valueFrom: $(self.basename + '.updatedseqdict.vcf')
    out: [output_file]

  - id: filter_contigs
    run: filter_contigs.cwl
    in:
      input_vcf:
        source: update_dictionary/output_file
      output_vcf:
        source: update_dictionary/output_file
        valueFrom: $(self.basename + '.filtered_contigs.vcf')
    out: [output_vcf_file]

  - id: format_header
    run: format_vcf_header.cwl
    in:
      input_vcf:
        source: filter_contigs/output_vcf_file
      output_vcf:
        source: filter_contigs/output_vcf_file
        valueFrom: $(self.basename + '.gdcheader.vcf')
      reference_name:
        source: fa_name
      patient_barcode: 
        source: patient_barcode
      case_id:
        source: case_id
      sample_barcode:
        source: sample_barcode
      aliquot_uuid:
        source: aliquot_id
      bam_uuid:
        source: bam_uuid
    out: [output_vcf_file]

  - id: sort_vcf_file
    run: sort_vcf_file.cwl
    in:
      input_vcf_file:
        source: format_header/output_vcf_file
      output_vcf_filename:
        source: format_header/output_vcf_file
        valueFrom: $(self.basename + ".gz")
    out:
      [output_vcf_file]

  - id: rename_sample
    run: rename_sample.cwl
    in:
      input_vcf_file:
        source: sort_vcf_file/output_vcf_file
      new_sample_name:
        valueFrom: "TUMOR"
      output_vcf_filename:
        source: sort_vcf_file/output_vcf_file
        valueFrom: $(self.basename)
    out:
      [output_vcf_file]

  - id: convert_vcf_format
    run: convert_vcf_format.cwl
    in:
      input_vcf_file:
        source: rename_sample/output_vcf_file
      output_vcf_filename:
        source: filename_prefix
        valueFrom: $(self + ".variant_filtration.vcf.gz")
    out:
      [output_vcf_file]
