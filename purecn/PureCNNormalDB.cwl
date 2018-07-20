#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/normaldb:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      $([inputs.normaldir])

inputs:
  - id: normaldir
    type: Directory
  - id: genome
    type: string
    inputBinding:
      position: 3
      prefix: --genome
  - id: covfile
    type: File
    inputBinding:
      position: 2
      prefix: --coveragefiles
  - id: outdir
    type: string
    inputBinding:
      position: 1
      prefix: --outdir

outputs:
  - id: outfiles
    type: Directory
    outputBinding:
      glob: "./"

arguments: ["--force"]
