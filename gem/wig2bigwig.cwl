#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/wig2bigwig:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.wig)
      - $(inputs.size)

inputs:
  - id: wig
    type: File
    inputBinding:
      position: 1
  - id: size
    type: File
    inputBinding:
      position: 2
  - id: outfile
    type: string
    inputBinding:
      position: 3

outputs:
  - id: bigwigfile
    type: File
    outputBinding:
      glob: $(inputs.outfile)
