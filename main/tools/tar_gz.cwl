class: CommandLineTool
cwlVersion: v1.0
id: tar_gz
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/bio-alpine:base
  - class: InlineJavascriptRequirement
doc: |
  create tar gz

inputs:
  create:
    type: boolean
    default: true
    inputBinding:
      prefix: --create
      position: 0

  file:
    type: string
    inputBinding:
      prefix: --file
      position: 1

  gzip:
    type: boolean
    default: true
    inputBinding:
      prefix: --gzip
      position: 2

  input:
    type:
      type: array
      items: ['null', File]
    inputBinding:
      position: 3

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.file)

baseCommand: [tar]
