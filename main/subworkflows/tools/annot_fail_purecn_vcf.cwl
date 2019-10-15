#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:06d509b6f9ba5a26d31690153b08f2381823ec1d
  - class: InlineJavascriptRequirement

inputs:
  - id: purecn_log
    type: File
    inputBinding:
      position: 1
      prefix: --purecn_log

  - id: vcf
    type: File
    inputBinding:
      position: 1
      prefix: --input_vcf

  - id: output
    type: string
    inputBinding:
      position: 2
      prefix: --output_vcf

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.output)

baseCommand: [python, /gdc_tosvc_tools/annot_fail_purecn_vcf.py]
