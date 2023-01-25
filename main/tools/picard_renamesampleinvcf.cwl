class: CommandLineTool
cwlVersion: v1.0
id: picard_renamesampleinvcf
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/picard:2.26.10-5c848e4
  - class: InlineJavascriptRequirement
doc: |
  picard RenameSampleInVcf
inputs:
  input:
    type: File
    inputBinding:
      prefix: "INPUT="
      separate: false
    secondaryFiles:
      - ".tbi"

  new_sample_name:
    type: string
    inputBinding:
      prefix: "NEW_SAMPLE_NAME="
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

baseCommand: [java, -jar, /usr/local/bin/picard.jar, RenameSampleInVcf]
