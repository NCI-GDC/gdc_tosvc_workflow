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

outputs:
  - id: outfiles
    type: File
    outputBinding:
      glob: "*"

arguments:
  - valueFrom: $(runtime.outdir)
    prefix: --outdir