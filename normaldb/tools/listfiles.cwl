class: CommandLineTool
cwlVersion: v1.0
id: listfiles
requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:disco-20190809
  - class: InlineJavascriptRequirement
doc: |
  list files

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
