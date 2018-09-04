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
      - id: input_vcf
        source: input_vcf_file
      - id: sequence_dictionary
        source: dict_main_file
      - id: output_filename
        source: input_vcf_file
        valueFrom: $(self.basename + '.updatedseqdict.vcf')
    out:
      - id: output_file

  - id: filter_contigs
    run: filter_contigs.cwl
    in:
      - id: input_vcf
        source: update_dictionary/output_file
      - id: output_vcf
        source: update_dictionary/output_file
        valueFrom: $(self.basename + '.filtered_contigs.vcf')
    out:
      - id: output_vcf_file

  - id: format_header
    run: format_vcf_header.cwl
    in:
      - id: input_vcf
        source: filter_contigs/output_vcf_file
      - id: output_vcf
        source: filter_contigs/output_vcf_file
        valueFrom: $(self.basename + '.gdcheader.vcf')
      - id: reference_name
        source: fa_name
      - id: patient_barcode
        source: patient_barcode
      - id: case_id
        source: case_id
      - id: sample_barcode
        source: sample_barcode
      - id: aliquot_uuid
        source: aliquot_id
      - id: bam_uuid
        source: bam_uuid
    out:
      - id: output_vcf_file

  - id: sort_vcf_file
    run: ../auxiliary/sort_vcf_file.cwl
    in:
      - id: input_vcf_file
        source: format_header/output_vcf_file
      - id: output_vcf_filename
        source: format_header/output_vcf_file
        valueFrom: $(self.basename + ".gz")
    out:
      - id: output_vcf_file

  - id: rename_sample
    run: rename_sample.cwl
    in:
      - id: input_vcf_file
        source: sort_vcf_file/output_vcf_file
      - id: new_sample_name
        valueFrom: "TUMOR"
      - id: output_vcf_filename
        source: sort_vcf_file/output_vcf_file
        valueFrom: $(self.basename)
    out:
      - id: output_vcf_file

  - id: convert_vcf_format
    run: ../auxiliary/convert_vcf_format.cwl
    in:
      - id: input_vcf_file
        source: rename_sample/output_vcf_file
      - id: output_vcf_filename
        source: filename_prefix
        valueFrom: $(self + ".variant_filtration.vcf.gz")
    out:
      - id: output_vcf_file
