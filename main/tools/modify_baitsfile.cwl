class: CommandLineTool
cwlVersion: v1.0
id: modify_baitsfile
requirements:
  - class: DockerRequirement
    dockerPull: alpine
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
doc: |
  modify baits file, exclude chrM regions

inputs:
  input_baits: File

outputs:
  modified_baits:
    type: File
    outputBinding:
      glob: '*.no_chrM.bed'
baseCommand: []
arguments:
  - position: 0
    shellQuote: false
    valueFrom: >-
      zcat $(inputs.input_baits.path) | grep -v chrM > $(inputs.input_baits.nameroot + '.no_chrM.bed')
