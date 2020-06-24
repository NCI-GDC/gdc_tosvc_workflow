class: CommandLineTool
cwlVersion: v1.0
id: remove_nonstandard_variants
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-biasfilter-tool:3839a594cab6b8576e76124061cf222fb3719f20
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
doc: |
  remove nonstandard variants

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
      python /opt/gdc-biasfilter-tool/RemoveNonStandardVariants.py $(inputs.input.path) $(inputs.output_filename)
