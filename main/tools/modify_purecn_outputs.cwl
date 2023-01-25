class: CommandLineTool
cwlVersion: v1.0
id: modify_purecn_outputs
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/gdc_tosvc_tools:ea2405fdcc260d1e617216824a903b16508774f1
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.metric_file)
      - $(inputs.dnacopy_seg_file)
doc: |
  modify purecn outputs

inputs:
  sample_id:
    type: string
    inputBinding:
      position: 0
      prefix: --sample_id
  metric_file:
    type: File
    inputBinding:
      position: 1
      prefix: --info_file
  dnacopy_seg_file:
    type: File
    inputBinding:
      position: 2
      prefix: --seg_file
  modified_metric_file:
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
  output_filtration_metric_file:
    type: File
    outputBinding:
      glob: $(inputs.modified_metric_file)
  output_dnacopy_seg_file:
    type: File
    outputBinding:
      glob: $(inputs.modified_seg_file)

baseCommand: [python, /gdc_tosvc_tools/modify_purecn_outputs.py]