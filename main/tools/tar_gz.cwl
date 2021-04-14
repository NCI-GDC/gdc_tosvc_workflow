class: CommandLineTool
cwlVersion: v1.0
id: tar_gz
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/xz:b8f105f87b8d69a0414f8997bd5b586e502d9a1aa74d429314ec97cbddd81ff8
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
      items: File
    inputBinding:
      position: 3

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.file)

baseCommand: [tar]