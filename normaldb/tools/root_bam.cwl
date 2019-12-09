class: CommandLineTool
cwlVersion: v1.0
id: root_bam
requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:disco-20190809
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.bam.basename)
        entry: $(inputs.bam)
      - entryname: $(inputs.bam_index.basename)
        entry: $(inputs.bam_index)
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
  root bam

inputs:
  - id: bam
    type: File

  - id: bam_index
    type: File

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.bam.basename)
    secondaryFiles:
      - ^.bai

baseCommand: "true"
