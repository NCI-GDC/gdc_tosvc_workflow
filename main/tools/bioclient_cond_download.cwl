class: CommandLineTool
cwlVersion: v1.0
id: bioclient_cond_upload
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/bio-client:latest
doc: |
  bioclient conditional upload

inputs:
  config_file:
    type: File?
  download_handle:
    type: string?

outputs:
  output:
    type: File?
    outputBinding:
      glob: "*"
      outputEval: |
        ${
          if (inputs.download_handle !== null) return self
          else return null
        }

baseCommand: []
arguments:
  - valueFrom: |
      ${
         var tool = "/usr/local/bin/bio_client.py"
         var cmd = []
         if (inputs.download_handle !== null) {
           cmd.push(tool)
           cmd.push("--config-file")
           cmd.push(inputs.config_file.path)
           cmd.push("download")
           cmd.push("--dir_path")
           cmd.push(".")
           cmd.push(inputs.download_handle)
         } else {
           cmd.push("true")
         }
         return cmd
       }
