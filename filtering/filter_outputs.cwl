#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/filter_purecn_outputs:latest
  - class: InlineJavascriptRequirement

inputs:
  input_vcf_file:
    type: File
    inputBinding:
      position: 1
      prefix: --input_vcf
  output_vcf_file:
    type: string
    inputBinding:
      position: 2
      prefix: --output_vcf
  prob_thres:
    type: float
    default: 0.2
    inputBinding:
      position: 3
      prefix: --prob_thres

outputs:
  filter_vcf_file:
    type: File
    outputBinding:
      glob: $(inputs.output_vcf_file)
