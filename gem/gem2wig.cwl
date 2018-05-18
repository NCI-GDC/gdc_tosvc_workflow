#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/gem2wig:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.infile)

inputs:
  - id: index
    type: File
    inputBinding:
      position: 1
      prefix: -I
  - id: infile
    type: File
    inputBinding:
      position: 2
      prefix: -i
  - id: outfile
    type: string
    inputBinding:
      position: 3
      prefix: -o

outputs:
  - id: wigfile
    type: File
    outputBinding:
      glob: $(inputs.outfile + '.wig')
  - id: sizefile
    type: File
    outputBinding:
      glob: $(inputs.outfile + '.sizes')
