#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/gem-indexer:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.infile)

inputs:
  - id: thread
    type: int
    inputBinding:
      position: 1
      prefix: -T
  - id: content
    type: string
    inputBinding:
      position: 2
      prefix: -c
  - id: infile
    type: File
    inputBinding:
      position: 3
      prefix: -i
  - id: outfile
    type: string
    inputBinding:
      position: 4
      prefix: -o

outputs:
  - id: outfile_out
    type: File
    outputBinding:
      glob: $(inputs.outfile)
