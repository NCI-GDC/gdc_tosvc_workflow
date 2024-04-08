class: CommandLineTool
cwlVersion: v1.0
id: filter_mutect_outputs
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/gdc-tosvc-tools:1.0.0-3-g04bf849
  - class: InlineJavascriptRequirement
doc: |
  filter mutect outputs

inputs:
  input:
    type: File
    inputBinding:
      position: 1
      prefix: --input_vcf

  output_filename:
    type: string
    inputBinding:
      position: 2
      prefix: --output_vcf

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: []
arguments:
  - position: 0
    valueFrom: "filter_mutect_outputs"
  - position: 99
    valueFrom: "filter_mutect_outputs"
