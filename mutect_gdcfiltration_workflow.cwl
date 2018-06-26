#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: job_uuid
    type: string
  - id: fa_file
    type: File
  - id: fai_file
    type: File
  - id: capture_file
    type: File?
  - id: input_vcf_file
    type: File

outputs:
  - id: output_vcf_file
    type: File
    outputSource: filter_mutect/output_vcf_file

steps:
  - id: filter_mutect
    run: filtering/filter_mutect_outputs.cwl
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
        valueFrom: $(self + ".gdc_filtration.vcf")

    out: [output_vcf_file]
