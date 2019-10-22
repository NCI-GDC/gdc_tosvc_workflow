#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:53aa36674ecf31cfdf3c853046010b6593488d6a
  - class: InlineJavascriptRequirement

inputs:
  - id: vcf
    type: File
    inputBinding:
      position: 1
      prefix: --input_vcf

  - id: prob_thres
    type: float
    default: 0.2
    inputBinding:
      position: 3
      prefix: --prob_thres

  - id: output_filename
    type: string
    inputBinding:
      position: 2
      prefix: --output_vcf

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [python, /gdc_tosvc_tools/filter_purecn_outputs.py]
