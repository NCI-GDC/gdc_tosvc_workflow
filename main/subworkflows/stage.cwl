#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

class: Workflow

inputs:
  tumor_bam: File
  tumor_bai: File
  raw_vcf: File
  raw_vcf_index: File
  reference_fa: File
  reference_fai: File
  reference_dict: File

steps:
  standardize_tumor_bai:
    run: tools/rename_file.cwl
    in:
      input_file: tumor_bai
      output_filename:
        source: tumor_bai
        valueFrom: |
          ${
             return self.basename.lastIndexOf('.bam') !== -1 ?
                    self.basename.substr(0, self.basename.lastIndexOf('.bam')) + '.bai' :
                    self.basename
           }
    out: [ out_file ]

  make_tumor_bam:
    run: tools/make_secondary.cwl
    in:
      parent_file: tumor_bam
      children:
        source: standardize_tumor_bai/out_file
        valueFrom: $([self])
    out: [ output ]

  make_reference:
    run: tools/make_secondary.cwl
    in:
      parent_file: reference_fa
      children:
        source: [reference_fai, reference_dict]
        valueFrom: $(self)
    out: [ output ]

  make_raw_vcf:
    run: tools/make_secondary.cwl
    in:
      parent_file: raw_vcf
      children:
        source: raw_vcf_index
        valueFrom: $([self])
    out: [ output ]

outputs:
  tumor_with_index:
    type: File
    outputSource: make_tumor_bam/output
  raw_vcf_with_index:
    type: File
    outputSource: make_raw_vcf/output
  reference_with_index:
    type: File
    outputSource: make_reference/output
