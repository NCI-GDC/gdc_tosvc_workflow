#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:53aa36674ecf31cfdf3c853046010b6593488d6a
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.metric_file)
      - $(inputs.dnacopy_seg_file)

baseCommand: [python, /gdc_tosvc_tools/modify_purecn_outputs.py]

inputs:
  - id: sample_id
    type: string
    inputBinding:
      position: 0
      prefix: --sample_id
  - id: metric_file
    type: File
    inputBinding:
      position: 1
      prefix: --info_file
  - id: dnacopy_seg_file
    type: File
    inputBinding:
      position: 2
      prefix: --seg_file
  - id: modified_metric_file
    type: string
    inputBinding:
      position: 3
      prefix: --modified_info_file
  - id: modified_seg_file
    type: string
    inputBinding:
      position: 4
      prefix: --modified_seg_file

outputs:
  - id: output_filtration_metric_file
    type: File
    outputBinding:
      glob: $(inputs.modified_metric_file)
  - id: output_dnacopy_seg_file
    type: File
    outputBinding:
      glob: $(inputs.modified_seg_file)