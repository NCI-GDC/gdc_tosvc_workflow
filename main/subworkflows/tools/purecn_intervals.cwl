#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn:1.14.3

inputs:
  - id: fasta
    type: File
    inputBinding:
      prefix: --fasta

  - id: force
    type: boolean
    default: true
    inputBinding:
      prefix: --force

  - id: genome
    type: string
    default: hg38
    inputBinding:
      prefix: --genome

  - id: infile
    type: File
    inputBinding:
      prefix: --infile

  - id: mappability
    type: File
    inputBinding:
      prefix: --mappability

  - id: offtarget
    type: boolean
    default: true
    inputBinding:
      prefix: --offtarget

arguments:
  - valueFrom: $(inputs.fasta.nameroot).$(inputs.infile.nameroot.split('.')[0]).$(inputs.genome).txt
    prefix: --outfile
    separate: true

  - valueFrom: $(inputs.fasta.nameroot).$(inputs.infile.nameroot.split('.')[0]).$(inputs.genome).bed
    prefix: --export
    separate: true

outputs:
  - id: interval
    type: File
    outputBinding:
      glob: $(inputs.fasta.nameroot).$(inputs.infile.nameroot.split('.')[0]).$(inputs.genome).txt

  - id: bed
    type: File
    outputBinding:
      glob: $(inputs.fasta.nameroot).$(inputs.infile.nameroot.split('.')[0]).$(inputs.genome).bed

baseCommand: [Rscript, /usr/local/lib/R/site-library/PureCN/extdata/IntervalFile.R]
