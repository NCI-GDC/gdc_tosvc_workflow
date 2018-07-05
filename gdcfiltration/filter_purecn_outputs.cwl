#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/gdc_tosvc_tools:latest
  - class: InlineJavascriptRequirement

inputs:
  input_vcf_file:
    type: File
    inputBinding:
      position: 1
      prefix: --input_vcf
  prob_thres:
    type: float
    default: 0.2
    inputBinding:
      position: 3
      prefix: --prob_thres
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

baseCommand: [python, /gdc_tosvc_tools/filter_purecn_outputs.py]
