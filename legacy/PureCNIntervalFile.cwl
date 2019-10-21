#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn_interval:1.11.11
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.fa_file)
      - $(inputs.fai_file)

inputs:
  - id: fa_file
    type: File
    inputBinding:
      position: 1
      prefix: --fasta
      valueFrom: $(self.basename)
  - id: fai_file
    type: File
  - id: capture_kit_file
    type: File
    inputBinding:
      position: 2
      prefix: --infile
  - id: map_file
    type: File
    inputBinding:
      position: 3
      prefix: --mappability
  - id: genome
    type: string
    inputBinding:
      position: 4
      prefix: --genome
  - id: out_file
    type: string
    inputBinding:
      position: 5
      prefix: --outfile
  - id: export_file
    type: string
    inputBinding:
      position: 6
      prefix: --export

outputs:
  - id: interval_file
    type: File
    outputBinding:
      glob: $(inputs.out_file)
  - id: interval_bed_file
    type: File
    outputBinding:
      glob: $(inputs.export_file)

arguments: ["--offtarget", "--force"]