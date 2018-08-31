#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:c3b1b6044acd2df3cadc28d642dd6fcc335832db
  - class: InlineJavascriptRequirement

baseCommand: [python, /gdc_tosvc_tools/annot_fail_purecn_vcf.py]

inputs:
  - id: purecn_log_file
    type: File
    inputBinding:
      position: 1
      prefix: --purecn_log
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
