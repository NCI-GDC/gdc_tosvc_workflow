#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/filter_mutect_outputs:latest
  - class: InlineJavascriptRequirement

inputs:
  input_vcf_file:
    type: File
    inputBinding:
      position: 1
      prefix: --input_vcf
  output_vcf_filename:
    type: string
    inputBinding:
      position: 2
      prefix: --output_vcf

outputs:
  output_vcf_file:
    type: File
    outputBinding:
      glob: $(inputs.output_vcf_filename)
