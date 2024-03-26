class: CommandLineTool
cwlVersion: v1.0
id: annot_fail_purecn_vcf
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/gdc-tosvc-tools:1.0.0-3-g04bf849
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

baseCommand: [annot_fail_purecn_vcf]
