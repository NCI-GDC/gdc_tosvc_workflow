#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: alpine:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.var_vcf_file)
      - $(inputs.genes_file)
      - $(inputs.loh_file)
      - $(inputs.metric_file)
      - $(inputs.info_pdf_file)
      - $(inputs.dnacopy_file)
      - $(inputs.segmentation_file)
      - $(inputs.chrome_file)
      - $(inputs.local_optima_file)
      - $(inputs.interval_file)
      - $(inputs.interval_bed_file)
      - $(inputs.cov_file)
      - $(inputs.loess_file)
      - $(inputs.loess_png_file)
      - $(inputs.loess_qc_file)
      - $(inputs.log_file)

baseCommand: ["tar", "hczf"]

inputs:
  var_vcf_file:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)
  genes_file:
    type: File
    inputBinding:
      position: 2
      valueFrom: $(self.basename)
  loh_file:
    type: File
    inputBinding:
      position: 3
      valueFrom: $(self.basename)
  metric_file:
    type: File
    inputBinding:
      position: 4
      valueFrom: $(self.basename)
  info_pdf_file:
    type: File
    inputBinding:
      position: 5
      valueFrom: $(self.basename)
  dnacopy_file:
    type: File
    inputBinding:
      position: 6
      valueFrom: $(self.basename)
  segmentation_file:
    type: File
    inputBinding:
      position: 7
      valueFrom: $(self.basename)
  chrome_file:
    type: File
    inputBinding:
      position: 8
      valueFrom: $(self.basename)
  local_optima_file:
    type: File
    inputBinding:
      position: 9
      valueFrom: $(self.basename)
  interval_file:
    type: File
    inputBinding:
      position: 10
      valueFrom: $(self.basename)
  interval_bed_file:
    type: File
    doc: if this is optional (File?) and we still pass the value to it from super worflow |
         the workflow gets crash with cwltool 1.0.20180306163216 |
         but runs well with newer cwltool such as 1.0.20180403145700
    inputBinding:
      position: 11
      valueFrom: $(self.basename)
  cov_file:
    type: File
    inputBinding:
      position: 12
      valueFrom: $(self.basename)
  loess_file:
    type: File
    inputBinding:
      position: 13
      valueFrom: $(self.basename)
  loess_png_file:
    type: File
    inputBinding:
      position: 14
      valueFrom: $(self.basename)
  loess_qc_file:
    type: File
    inputBinding:
      position: 15
      valueFrom: $(self.basename)
  log_file:
    type: File
    inputBinding:
      position: 16
      valueFrom: $(self.basename)

  compress_file_name:
    type: string
    inputBinding:
      position: 0

outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.compress_file_name)
