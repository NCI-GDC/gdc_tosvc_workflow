#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/wig2bigwig:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.wigfile)
      - $(inputs.sizefile)

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