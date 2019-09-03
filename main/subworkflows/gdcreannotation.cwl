#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: vcf
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
    outputSource: vcfformatconverter/output

steps:
  - id: update_dictionary
    run: tools/picard_updatevcfsequencedictionary.cwl
    in:
      - id: input
        source: vcf
      - id: sequence_dictionary
        source: dict_main_file
      - id: output
        source: vcf
        valueFrom: $(self.basename).updatedseqdict.vcf
    out:
      - id: output

  - id: filter_contigs
    run: tools/gdc_variant_filtration_tool.cwl
    in:
      - id: input_vcf
        source: update_dictionary/output
      - id: output_vcf
        source: update_dictionary/output
        valueFrom: $(self.basename).filtered_contigs.vcf
    out:
      - id: output_vcf_file

  - id: format_header
    run: tools/gdc_format_vcf_header.cwl
    in:
      - id: input_vcf
        source: filter_contigs/output_vcf_file
      - id: output_vcf
        source: filter_contigs/output_vcf_file
        valueFrom: $(self.basename).gdcheader.vcf
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

  - id: sortvcf
    run: tools/picard_sortvcf.cwl
    in:
      - id: input
        source: format_header/output_vcf_file
      - id: output
        source: format_header/output_vcf_file
        valueFrom: $(self.basename).gz
    out:
      - id: output

  - id: rename_sample
    run: tools/picard_renamesampleinvcf.cwl
    in:
      - id: input
        source: sortvcf/output
      - id: new_sample_name
        valueFrom: "TUMOR"
      - id: output
        source: sortvcf/output
        valueFrom: $(self.basename)
    out:
      - id: output

  - id: vcfformatconverter
    run: tools/picard_vcfformatconverter.cwl
    in:
      - id: input
        source: rename_sample/output
      - id: output
        source: filename_prefix
        valueFrom: $(self).variant_filtration.vcf.gz
    out:
      - id: output
