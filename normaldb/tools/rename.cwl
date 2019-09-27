#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:disco-20190913
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.filename)
        entry: $(inputs.input)
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: input
    type: File

  - id: filename
    type: string

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.filename)

baseCommand: [/bin/true]
