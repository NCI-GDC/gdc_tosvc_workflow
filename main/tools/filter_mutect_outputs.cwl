class: CommandLineTool
cwlVersion: v1.0
id: filter_mutect_outputs
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:1.0.0-3-g04bf849
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
doc: |
  filter mutect outputs

inputs:
  input: File

  output_filename: string

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: []
arguments:
  - position: 0
    shellQuote: false
    valueFrom: >-
      python /gdc_tosvc_tools/filter_mutect_outputs.py --input_vcf $(inputs.input.path) --output_vcf $(inputs.output_filename)