#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: input
    type: File
    inputBinding:
      prefix: "INPUT="
      separate: false

  - id: sequence_dictionary
    type: File
    inputBinding:
      prefix: SEQUENCE_DICTIONARY=
      separate: false

  - id: output
    type: string
    inputBinding:
      prefix: "OUTPUT="
      separate: false

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [java, -jar, /usr/local/bin/picard.jar, UpdateVcfSequenceDictionary]
