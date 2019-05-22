#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:disco-20190515
  - class: InlineJavascriptRequirement

inputs:
  - id: files
    type:
      type: array
      items: File
      
  - id: outname
    type: string

arguments:
  - valueFrom: |
      ${
        var catstr = '';
        for (var i=0; i<inputs.files.length; i++) {
          if (i < inputs.files.length - 1) {
            catstr += inputs.files[i].basename + '\n'
          }
          else {
            catstr += inputs.files[i].basename
          }
        }
        return catstr;
      }

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.outname)

stdout: $(inputs.outname)

baseCommand: [echo]