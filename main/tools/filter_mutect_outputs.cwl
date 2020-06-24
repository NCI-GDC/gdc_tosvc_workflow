class: CommandLineTool
cwlVersion: v1.0
id: filter_mutect_outputs
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:53aa36674ecf31cfdf3c853046010b6593488d6a
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