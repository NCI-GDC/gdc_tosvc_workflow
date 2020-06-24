class: CommandLineTool
cwlVersion: v1.0
id: picard_vcfformatconverter
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:latest
  - class: InlineJavascriptRequirement
doc: |
  picard VcfFormatConverter

inputs:
  create_index:
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  input:
    type: File
    inputBinding:
      prefix: INPUT=
      separate: false

  output_filename:
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

  require_index:
    type: string
    default: "false"
    inputBinding:
      prefix: REQUIRE_INDEX=
      separate: false

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
    secondaryFiles:
      - ".tbi"

baseCommand: [java, -jar, /usr/local/bin/picard.jar, VcfFormatConverter]
