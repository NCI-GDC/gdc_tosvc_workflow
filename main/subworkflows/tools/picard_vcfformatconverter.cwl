#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:latest
  - class: InlineJavascriptRequirement

inputs:
  - id: create_index
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  - id: input
    type: File
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: output
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

  - id: require_index
    type: string
    default: "false"
    inputBinding:
      prefix: REQUIRE_INDEX=
      separate: false

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.output)
    secondaryFiles:
      - ".tbi"

baseCommand: [java, -jar, /usr/local/bin/picard.jar, VcfFormatConverter]
