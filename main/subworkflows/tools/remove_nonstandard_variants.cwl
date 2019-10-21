#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-biasfilter-tool:3839a594cab6b8576e76124061cf222fb3719f20
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
      glob: $(inputs.output)

baseCommand: [python, /opt/gdc-biasfilter-tool/RemoveNonStandardVariants.py]
