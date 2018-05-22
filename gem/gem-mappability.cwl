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
  - id: indexfile
    type: File
    inputBinding:
      position: 2
      prefix: -I
  - id: readlen
    type: File
    inputBinding:
      loadContents: true
      valueFrom: $(null)
  - id: thread_num?
    type: int
    inputBinding:
      position: 1
      prefix: -T
  - id: max_mismatch?
    type: int
    inputBinding:
      position: 5
      prefix: -m
  - id: max_edit?
    type: int
    inputBinding:
      position: 6
      prefix: -e

outputs:
  - id: mapfile
    type: File
    outputBinding:
      glob: $(inputs.indexfile.basename + '.' + Math.ceil(inputs.readlen.contents.replace(/\n/g, '')))

arguments:
  - valueFrom: $(Math.ceil(inputs.readlen.contents.replace(/\n/g, '')))
    position: 3
    prefix: -l
  - valueFrom: $(inputs.indexfile.basename + '.' + Math.ceil(inputs.readlen.contents.replace(/\n/g, '')))
    position: 4
    prefix: -o
