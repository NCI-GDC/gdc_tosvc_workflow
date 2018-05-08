#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/purecn
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
    listing: |
      ${
         return inputs.normaldir.listing
       }

arguments: ["--outvcf", "--force", "--postoptimize"]

inputs:
  - id: normaldir
    type: Directory
  - id: tumor
    type: File
    inputBinding:
      position: 1
      prefix: --tumor
  - id: normaldb
    type: File
    inputBinding:
      position: 2
      prefix: --normaldb
      valueFrom: $(self.basename)
  - id: sampleid
    type: string
    inputBinding:
      position: 3
      prefix: --sampleid
  - id: vcf
    type: File
    inputBinding:
      position: 4
      prefix: --vcf
  - id: statsfile
    type: File?
    inputBinding:
      position: 5
      prefix: --statsfile
  - id: genome
    type: string
    inputBinding:
      position: 6
      prefix: --genome
  - id: gcgene
    type: File
    inputBinding:
      position: 7
      prefix: --gcgene
  - id: targetweightfile
    type: File
    inputBinding:
      position: 8
      prefix: --targetweightfile
  - id: outdir
    type: string
    inputBinding:
      position: 9
      prefix: --out

outputs:
  - id: outdir_out
    type: Directory
    outputBinding:
      glob: "./"
