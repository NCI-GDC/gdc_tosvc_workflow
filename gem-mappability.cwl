#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/gem-mappability:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.indexfile)

inputs:
  - id: thread
    type: int
    inputBinding:
      position: 1
      prefix: -T
  - id: length
    type: int
    inputBinding:
      position: 3
      prefix: -l
  - id: max_mismatch
    type: int
    inputBinding:
      position: 5
      prefix: -m
  - id: max_edit
    type: int
    inputBinding:
      position: 6
      prefix: -e
  - id: indexfile
    type: File
    inputBinding:
      position: 2
      prefix: -I
  - id: outfile
    type: string
    inputBinding:
      position: 4
      prefix: -o

outputs:
  - id: outfile_out
    type: File
    outputBinding:
      glob: $(inputs.outfile)".*"
