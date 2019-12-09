class: CommandLineTool
cwlVersion: v1.0
id: remove_nonstandard_variants
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-biasfilter-tool:3839a594cab6b8576e76124061cf222fb3719f20
  - class: InlineJavascriptRequirement
doc: |
  remove nonstandard variants

inputs:
  - id: input
    type: File
    inputBinding:
      position: 0

  - id: output_filename
    type: string
    inputBinding:
        position: 1

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [python, /opt/gdc-biasfilter-tool/RemoveNonStandardVariants.py]
