#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: alpine:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.genes_file)
      - $(inputs.log_file)
      - $(inputs.info_pdf_file)
      - $(inputs.segmentation_file)
      - $(inputs.chrome_file)
      - $(inputs.local_optima_file)
      - $(inputs.interval_file)
      - $(inputs.interval_bed_file)
      - $(inputs.cov_file)
      - $(inputs.loess_file)
      - $(inputs.loess_png_file)
      - $(inputs.loess_qc_file)

baseCommand: ["tar", "hczf"]

inputs:
  genes_file:
    type: File
    inputBinding:
      position: 3
      valueFrom: $(self.basename)
  log_file:
    type: File
    inputBinding:
      position: 4
      valueFrom: $(self.basename)
  info_pdf_file:
    type: File
    inputBinding:
      position: 6
      valueFrom: $(self.basename)
  segmentation_file:
    type: File
    inputBinding:
      position: 8
      valueFrom: $(self.basename)
  chrome_file:
    type: File
    inputBinding:
      position: 9
      valueFrom: $(self.basename)
  local_optima_file:
    type: File
    inputBinding:
      position: 10
      valueFrom: $(self.basename)

  interval_file:
    type: File
    inputBinding:
      position: 13
      valueFrom: $(self.basename)
  interval_bed_file:
    type: File?
    inputBinding:
      position: 14
      valueFrom: $(self.basename)
  cov_file:
    type: File
    inputBinding:
      position: 15
      valueFrom: $(self.basename)
  loess_file:
    type: File
    inputBinding:
      position: 16
      valueFrom: $(self.basename)
  loess_png_file:
    type: File
    inputBinding:
      position: 17
      valueFrom: $(self.basename)
  loess_qc_file:
    type: File
    inputBinding:
      position: 18
      valueFrom: $(self.basename)

  compress_file_name:
    type: string
    inputBinding:
      position: 0

outputs:
  outfile:
    type: File
    outputBinding:
      glob: $(inputs.compress_file_name)
