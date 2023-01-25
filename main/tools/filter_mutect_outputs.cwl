class: CommandLineTool
cwlVersion: v1.0
id: filter_mutect_outputs
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/gdc_tosvc_tools:ea2405fdcc260d1e617216824a903b16508774f1
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