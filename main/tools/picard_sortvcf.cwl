#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:latest
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: $(Math.ceil(1.2 * inputs.INPUT.size / 1048576))
    tmpdirMax: $(Math.ceil(1.2 * inputs.INPUT.size / 1048576))
    outdirMin: $(Math.ceil(1.2 * inputs.INPUT.size / 1048576))
    outdirMax: $(Math.ceil(1.2 * inputs.INPUT.size / 1048576))

class: CommandLineTool

inputs:
  - id: CREATE_INDEX
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  - id: INPUT
    type: File
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: OUTPUT
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

  - id: TMP_DIR
    type: string
    default: .
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  - id: VALIDATION_STRINGENCY
    type: string
    default: "STRICT"
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  - id: SORTED_OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT)
    secondaryFiles:
      - .tbi

baseCommand: [java, -jar, /usr/local/bin/picard.jar, SortVcf]
