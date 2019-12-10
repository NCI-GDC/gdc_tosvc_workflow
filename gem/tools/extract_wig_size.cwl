class: CommandLineTool
cwlVersion: v1.0
id: extract_wig_size
requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/gdc_tosvc_tools:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.wig_file)
      - $(inputs.size_file)
doc: |
  extract wig size

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
      glob: $(inputs.wig_file.basename + '.trim.tsv')
  - id: extracted_size_file
    type: File
    outputBinding:
      glob: $(inputs.size_file.basename + '.trim.tsv')

baseCommand: [python, /gdc_tosvc_tools/extract_wig_size.py]