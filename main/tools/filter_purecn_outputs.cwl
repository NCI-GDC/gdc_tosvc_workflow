class: CommandLineTool
cwlVersion: v1.0
id: filter_purecn_outputs
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/gdc-tosvc-tools:1.0.0-3-g04bf849
  - class: InlineJavascriptRequirement
doc: |
  filter purecn outputs

inputs:
  vcf:
    type: File
    inputBinding:
      position: 1
      prefix: --input_vcf

  prob_thres:
    type: float
    default: 0.2
    inputBinding:
      position: 3
      prefix: --threshold

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
    valueFrom: "filter_purecn_outputs"
  - position: 99
    valueFrom: "filter_purecn_outputs"
