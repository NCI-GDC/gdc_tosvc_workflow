class: CommandLineTool
cwlVersion: v1.0
id: rename
requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:disco-20190913
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.filename)
        entry: $(inputs.input)
  - class: InlineJavascriptRequirement
doc: |
  rename file

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
