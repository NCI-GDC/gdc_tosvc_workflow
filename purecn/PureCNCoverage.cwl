#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/coverage:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.bam_file)
      - $(inputs.bai_file)

inputs:
  - id: bam_file
    type: File
    inputBinding:
      position: 1
      prefix: --bam
      valueFrom: $(self.basename)
  - id: bai_file
    type: File
    inputBinding:
      position: 2
      prefix: --bai
      valueFrom: $(self.basename)
  - id: interval_file
    type: File
    inputBinding:
      position: 3
      prefix: --interval
  - id: thread_num
    type: int?
    inputBinding:
      position: 4
      prefix: --cpu
  - id: outdir
    type: string
    inputBinding:
      position: 5
      prefix: --outdir

outputs:
  - id: cov_file
    type: File
    outputBinding:
      glob: "*coverage.txt"
  - id: loess_file
    type: File
    outputBinding:
      glob: "*coverage_loess.txt"
  - id: loess_png_file
    type: File
    outputBinding:
      glob: "*coverage_loess.png"
  - id: loess_qc_file
    type: File
    outputBinding:
      glob: "*coverage_loess_qc.txt"

arguments: ["--force"]