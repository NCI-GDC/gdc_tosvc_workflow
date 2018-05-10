#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/coverage
  - class: InlineJavascriptRequirement

inputs:
  - id: bam
    type: File
    secondaryFiles:
      - '^.bai'
    inputBinding:
      position: 1
      prefix: --bam
  - id: gcgene
    type: File
    inputBinding:
      position: 2
      prefix: --gcgene
  - id: outdir
    type: string
    inputBinding:
      position: 3
      prefix: --outdir

outputs:
  - id: outfiles
    type: Directory
    outputBinding:
      glob: "./"