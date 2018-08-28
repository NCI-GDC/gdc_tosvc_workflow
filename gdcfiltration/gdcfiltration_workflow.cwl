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
  - id: input_vcf_file
    type: File

outputs:
  - id: output_vcf_file
    type: File
    outputSource: filter_mutect/output_vcf_file

steps:
  - id: filter_mutect
    run: filter_mutect_outputs.cwl
    in:
      input_vcf_file:
        source: input_vcf_file
      output_vcf_filename:
        source: input_vcf_file
        valueFrom: $(self.basename + ".filtered_mutect.vcf")
    out: [output_vcf_file]
