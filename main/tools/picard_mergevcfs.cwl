class: CommandLineTool
cwlVersion: v1.0
id: picard_mergevcfs
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
doc: |
  picard merge vcfs

inputs:
  create_index:
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  input:
    type:
      type: array
      items: File
      inputBinding:
        prefix: INPUT=
        separate: false

  output_filename:
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

  sequence_dictionary:
    type: File
    inputBinding:
      prefix: SEQUENCE_DICTIONARY=
      separate: false

  tmp_dir:
    type: string
    default: .
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  validation_stringency:
    type: string
    default: "STRICT"
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
    secondaryFiles:
      - .tbi

baseCommand: [java, -jar, /usr/local/bin/picard.jar, MergeVcfs]
