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
      prefix: -i
  dnacopy_seg_file:
    type: File
    inputBinding:
      position: 2
      prefix: -s

outputs:
  gdc_sample_info_file:
    type: File
    outputBinding:
      glob: "*.gdc.csv"
  gdc_dnacopy_seg_file:
    type: File
    outputBinding:
      glob: "*_dnacopy.gdc.seg"
