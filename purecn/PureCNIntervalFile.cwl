#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/interval
  - class: InlineJavascriptRequirement

inputs:
  - id: ref_file
    type: File
    inputBinding:
      position: 1
      prefix: --fasta
    secondaryFiles:
      - ".fai"
  - id: interval_file
    type: File
    inputBinding:
      position: 2
      prefix: --infile
  - id: map_file
    type: File
    inputBinding:
      position: 3
      prefix: --mappability
  - id: genome
    type: string
    inputBinding:
      position: 4
      prefix: --genome
  - id: out_file
    type: string
    inputBinding:
      position: 5
      prefix: --outfile
  - id: export_file
    type: string
    inputBinding:
      position: 6
      prefix: --export

outputs:
  - id: gcgene_file
    type: File
    outputBinding:
      glob: $(inputs.out_file)
  - id: capture_file
    type: File
    outputBinding:
      glob: $(inputs.export_file)

arguments: ["--offtarget"]