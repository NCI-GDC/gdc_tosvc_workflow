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
    tmpdirMin: $(Math.ceil(1.2 * inputs.input.size / 1048576))
    tmpdirMax: $(Math.ceil(1.2 * inputs.input.size / 1048576))
    outdirMin: $(Math.ceil(1.2 * inputs.input.size / 1048576))
    outdirMax: $(Math.ceil(1.2 * inputs.input.size / 1048576))

class: CommandLineTool

inputs:
  - id: create_index
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  - id: input
    type:
      type: array
      items: File
      inputBinding:
        prefix: INPUT=
        separate: false

  - id: output
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

  - id: sequence_dictionary
    type: File
    inputBinding:
      prefix: SEQUENCE_DICTIONARY=
      separate: false
      
  - id: tmp_dir
    type: string
    default: .
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  - id: validation_stringency
    type: string
    default: "STRICT"
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.output)
    secondaryFiles:
      - .tbi

baseCommand: [java, -jar, /usr/local/bin/picard.jar, MergeVcfs]
