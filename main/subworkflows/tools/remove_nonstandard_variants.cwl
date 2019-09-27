#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-biasfilter:de5a941fe830deea0ff2544fbbe521a783cf629f988277786720e66e3a4dbb13
  - class: InlineJavascriptRequirement

inputs:
  - id: input
    type: File
    inputBinding:
      position: 0

  - id: output
    type: string
    inputBinding:
        position: 1

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [/usr/local/bin/RemoveNonStandardVariants.py]
