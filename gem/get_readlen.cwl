#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: biocontainers/samtools
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

stdout: readlen.txt

baseCommand: ["samtools", "view"]

inputs:
  - id: bam
    type: File
    inputBinding:
      position: 0
    secondaryFiles:
      - '.bai'

outputs:
  - id: readlen
    type: stdout

arguments:
  - valueFrom: "|"
    position: 1
  - valueFrom: "head"
    position: 2
  - valueFrom: "1000"
    position: 3
    prefix: -n
  - valueFrom: "|"
    position: 4
  - valueFrom: "awk"
    position: 5
  - valueFrom: '{sum += length($10); n++} END { if (n > 0) print sum / n; }'
    position: 6
    shellQuote: true