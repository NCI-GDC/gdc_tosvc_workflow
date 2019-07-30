#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn:5d5ac8fca6399ae8ff1587b2678d32449249d44fa132498ed9231286bbea2c97
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
  - class: InlineJavascriptRequirement

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

baseCommand: [Rscript, /usr/local/lib/R/site-library/PureCN/extdata/NormalDB.R]
