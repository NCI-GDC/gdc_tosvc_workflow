class: CommandLineTool
cwlVersion: v1.0
id: wig2bigwig
requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/wig2bigwig:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.wigfile)
      - $(inputs.sizefile)
doc: |
  convert wig to bigwig

inputs:
  - id: wigfile
    type: File
    inputBinding:
      position: 1
  - id: sizefile
    type: File
    inputBinding:
      position: 2

outputs:
  - id: bigwigfile
    type: File
    outputBinding:
      glob: $(inputs.wigfile.basename.split(".").slice(0, -1).join(".") + ".bigwig")

arguments:
  - valueFrom: $(inputs.wigfile.basename.split(".").slice(0, -1).join(".") + ".bigwig")
    position: 3