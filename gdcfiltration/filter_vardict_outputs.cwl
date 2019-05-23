#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:53aa36674ecf31cfdf3c853046010b6593488d6a
  - class: InlineJavascriptRequirement

baseCommand: [python, /gdc_tosvc_tools/filter_mutect_outputs.py]

inputs:
  - id: input_vcf_file
    type: File
    inputBinding:
      position: 1
      prefix: --input_vcf
  - id: output_vcf_filename
    type: string
    inputBinding:
      position: 2
      prefix: --output_vcf

outputs:
  - id: output_vcf_file
    type: File
    outputBinding:
      glob: $(inputs.output_vcf_filename)
