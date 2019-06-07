#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn:5d5ac8fca6399ae8ff1587b2678d32449249d44fa132498ed9231286bbea2c97

inputs:
  - id: fasta
    type: File
    inputBinding:
      prefix: --fasta

  - id: bed
    type: File
    inputBinding:
      prefix: --infile

  - id: bigwig
    type: File
    inputBinding:
      prefix: --mappability

  - id: genome
    type: string
    default: hg38
    inputBinding:
      prefix: --genome

  - id: offtarget
    type: boolean
    default: true
    inputBinding:
      prefix: --offtarget

  - id: force
    type: boolean
    default: true
    inputBinding:
      prefix: --force

arguments:
  - valueFrom: $(inputs.bed.nameroot)
    prefix: --outfile
    separate: true

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.bed.nameroot)

baseCommand: [Rscript, /usr/local/lib/R/site-library/PureCN/extdata/IntervalFile.R]
