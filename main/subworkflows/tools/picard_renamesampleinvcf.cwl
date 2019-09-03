#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:latest
  - class: InlineJavascriptRequirement

inputs:
  - id: input
    type: File
    inputBinding:
      prefix: "INPUT="
      separate: false
    secondaryFiles:
      - ".tbi"

  - id: new_sample_name
    type: string
    inputBinding:
      prefix: "NEW_SAMPLE_NAME="
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
      glob: $(inputs.output)

baseCommand: [java, -jar, /usr/local/bin/picard.jar, RenameSampleInVcf]
