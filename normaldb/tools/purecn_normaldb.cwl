#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn_normaldb:1.11.11
  - class: InitialWorkDirRequirement
    listing: |
      ${
        var inputlist = [];
        for (var i=0; i<inputs.inputcoveragefiles.length; i++) {
           var newentry = {"entry": inputs.inputcoveragefiles[i],
                           "entryname": inputs.inputcoveragefiles[i].basename,
                           "writeable": false};
           inputlist.push(newentry);
        }
        return inputlist;
      }

inputs:
  - id: inputcoveragefiles
    type:
      type: array
      items: File

  - id: coveragefiles
    type: File
    inputBinding:
      prefix: --coveragefiles

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

  - id: outdir
    type: string
    default: .
    inputBinding:
      prefix: --outdir

outputs:
  - id: bed
    type: File
    outputBinding:
      glob: "low_coverage_targets_*.bed"

  - id: png
    type: File
    outputBinding:
      glob: "interval_weights_*.png"
      
  - id: rds
    type: File
    outputBinding:
      glob: "normalDB_*.rds"
      
  - id: txt
    type: File
    outputBinding:
      glob: "interval_weights_*.txt"
