class: CommandLineTool
cwlVersion: v1.0
id: root_fasta
requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:disco-20190809
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.fasta.basename)
        entry: $(inputs.fasta)
      - entryname: $(inputs.fasta_index.basename)
        entry: $(inputs.fasta_index)
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 500
    ramMax: 500
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1
doc: |
  root fasta

inputs:
  - id: fasta
    type: File

  - id: fasta_index
    type: File

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.fasta.basename)
    secondaryFiles:
      - .fai

baseCommand: "true"
