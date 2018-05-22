#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/gem2wig:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.mapfile)

inputs:
  - id: indexfile
    type: File
    inputBinding:
      position: 1
      prefix: -I
  - id: mapfile
    type: File
    inputBinding:
      position: 2
      prefix: -i

outputs:
  - id: wigfile
    type: File
    outputBinding:
      glob: $(inputs.mapfile.basename.split(".").slice(0, -1).join(".") + '.wig')
  - id: sizefile
    type: File
    outputBinding:
      glob: $(inputs.mapfile.basename.split(".").slice(0, -1).join(".") + '.sizes')

arguments:
  - valueFrom: $(inputs.mapfile.basename.split(".").slice(0, -1).join("."))
    position: 3
    prefix: -o