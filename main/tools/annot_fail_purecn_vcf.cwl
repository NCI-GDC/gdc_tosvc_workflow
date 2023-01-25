class: CommandLineTool
cwlVersion: v1.0
id: annot_fail_purecn_vcf
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/gdc_tosvc_tools:ea2405fdcc260d1e617216824a903b16508774f1
  - class: InlineJavascriptRequirement
doc: |
  annotate fail purecn vcf

inputs:
  purecn_log:
    type: File
    inputBinding:
      position: 1
      prefix: --purecn_log

  vcf:
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

baseCommand: [python, /gdc_tosvc_tools/annot_fail_purecn_vcf.py]
