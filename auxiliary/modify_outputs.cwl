#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/modify_purecn_outputs:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.sample_info_file)
      - $(inputs.dnacopy_seg_file)

inputs:
  sample_info_file:
    type: File
    inputBinding:
      position: 1
      prefix: --info_file
  dnacopy_seg_file:
    type: File
    inputBinding:
      position: 2
      prefix: --seg_file
  modified_info_file:
    type: string
    inputBinding:
      position: 3
      prefix: --modified_info_file
  modified_seg_file:
    type: string
    inputBinding:
      position: 4
      prefix: --modified_seg_file

outputs:
  output_sample_info_file:
    type: File
    outputBinding:
      glob: $(inputs.modified_info_file)
  output_dnacopy_seg_file:
    type: File
    outputBinding:
      glob: $(inputs.modified_seg_file)