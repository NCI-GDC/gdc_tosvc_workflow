class: CommandLineTool
cwlVersion: v1.0
id: filter_purecn_outputs
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:53aa36674ecf31cfdf3c853046010b6593488d6a
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
      prefix: --prob_thres

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

baseCommand: [python, /gdc_tosvc_tools/filter_purecn_outputs.py]
