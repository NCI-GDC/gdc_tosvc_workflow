#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/extract_wig_size:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.wig_file)
      - $(inputs.size_file)

inputs:
  - id: wig_file
    type: File
    inputBinding:
      position: 1
      prefix: -w
      valueFrom: $(self.basename)
  - id: size_file
    type: File
    inputBinding:
      position: 2
      prefix: -s
      valueFrom: $(self.basename)

outputs:
  - id: extracted_wig_file
    type: File
    outputBinding:
      glob: $(inputs.wig_file.basename + '.1')
  - id: extracted_size_file
    type: File
    outputBinding:
      glob: $(inputs.size_file.basename + '.1')
