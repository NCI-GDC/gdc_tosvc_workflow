class: CommandLineTool
cwlVersion: v1.0
id: root_bed
requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:disco-20190809
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.bed.basename)
        entry: $(inputs.bed)
      - entryname: $(inputs.bed_index.basename)
        entry: $(inputs.bed_index)
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
  root bed

inputs:
  - id: bed
    type: File

  - id: bed_index
    type: File

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.bed.basename)
    secondaryFiles:
      - .tbi

baseCommand: "true"
