class: CommandLineTool
cwlVersion: v1.0
id: filter_mutect_outputs
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/gdc-tosvc-tools:{{ gdc_tosvc_tools }}"
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
