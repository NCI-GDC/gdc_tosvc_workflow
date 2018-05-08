#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/normaldb
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      $([inputs.normaldir])

#    listing: |
#      ${
#        console.log(Object.keys(inputs.normaldir));
#        return inputs.normaldir;
#      }
      
#    listing: |
#      ${
#        return inputs.normaldir.listing
#      }

arguments: ["--force"]

inputs:
  - id: normaldir
    type: Directory
#    inputBinding:
#      valueFrom: $(self.basename)
  - id: genome
    type: string
    inputBinding:
      position: 3
      prefix: --genome
  - id: covfile
    type: File
    inputBinding:
      position: 2
      prefix: --coveragefiles
  - id: outdir
    type: string
    inputBinding:
      position: 1
      prefix: --outdir

outputs:
  - id: outfiles
    type: Directory
    outputBinding:
      glob: "./"