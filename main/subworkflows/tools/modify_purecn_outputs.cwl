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

inputs:
  - id: sampleid
    type: string
    inputBinding:
      position: 0
      prefix: --sample_id

  - id: purecn_csv
    type: File
    inputBinding:
      position: 1
      prefix: --info_file

  - id: purecn_dnacopy_seg
    type: File
    inputBinding:
      position: 2
      prefix: --seg_file

  - id: modified_metric
    type: string
    inputBinding:
      position: 3
      prefix: --modified_info_file

  - id: modified_seg
    type: string
    inputBinding:
      position: 4
      prefix: --modified_seg_file

outputs:
  - id: output_filtration_metric
    type: File
    outputBinding:
      glob: $(inputs.modified_metric_file)

  - id: output_dnacopy_seg
    type: File
    outputBinding:
      glob: $(inputs.modified_seg_file)

baseCommand: [python, /gdc_tosvc_tools/modify_purecn_outputs.py]
