class: CommandLineTool
cwlVersion: v1.0
id: filter_mutect_outputs
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/gdc-tosvc-tools:1.0.0-3-g04bf849
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
      python /gdc-tosvc-tools/filter_mutect_outputs.py --input_vcf $(inputs.input.path) --output_vcf $(inputs.output_filename)