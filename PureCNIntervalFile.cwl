#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/interval
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.fasta)
      - $(inputs.infile)

inputs:
  - id: infile
    type: File
    inputBinding:
      position: 1
      prefix: --infile
  - id: fasta
    type: File
    inputBinding:
      position: 2
      prefix: --fasta
  - id: mappability
    type: File
    inputBinding:
      position: 3
      prefix: --mappability
  - id: genome
    type: string
    inputBinding:
      position: 4
      prefix: --genome
  - id: outfile
    type: string
    inputBinding:
      position: 5
      prefix: --outfile
  - id: export
    type: string
    inputBinding:
      position: 6
      prefix: --export

outputs:
  - id: outfile_out
    type: File
    outputBinding:
      glob: $(inputs.outfile)
  - id: export_out
    type: File
    outputBinding:
      glob: $(inputs.export)

arguments: ["--offtarget"]