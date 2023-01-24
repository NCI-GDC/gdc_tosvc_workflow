class: CommandLineTool
cwlVersion: v1.0
id: picard_updatevcfsequencedictionary
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:2.26.10-5c848e4
  - class: InlineJavascriptRequirement
doc: |
  picard UpdateVcfSequenceDictionary

inputs:
  input:
    type: File
    inputBinding:
      prefix: "INPUT="
      separate: false

  sequence_dictionary:
    type: File
    inputBinding:
      prefix: SEQUENCE_DICTIONARY=
      separate: false

  output_filename:
    type: string
    inputBinding:
      prefix: "OUTPUT="
      separate: false

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [java, -jar, /usr/local/bin/picard.jar, UpdateVcfSequenceDictionary]
