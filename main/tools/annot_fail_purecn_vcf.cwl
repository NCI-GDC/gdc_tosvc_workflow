class: CommandLineTool
cwlVersion: v1.0
id: annot_fail_purecn_vcf
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/gdc-tosvc-tools:{{ gdc_tosvc_tools }}"
  - class: InlineJavascriptRequirement
doc: |
  annotate fail purecn vcf

inputs:
  purecn_log:
    type: File
    inputBinding:
      position: 1
      prefix: --purecn-log

  vcf:
    type: File
    inputBinding:
      position: 1
      prefix: --input-vcf

  output_filename:
    type: string
    inputBinding:
      position: 2
      prefix: --output-vcf

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: []
arguments:
  - position: 0
    valueFrom: "annot_fail_purecn_vcf"
  - position: 99
    valueFrom: "annot_fail_purecn_vcf"
