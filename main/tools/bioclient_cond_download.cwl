class: CommandLineTool
cwlVersion: v1.0
id: bioclient_cond_upload
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/bio-client:latest
doc: |
  bioclient conditional upload


cwlVersion: v1.0
class: CommandLineTool
id: bio_client_download
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/bio-client:{{ bio_client }}"
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 2000
    ramMax: 2000
    tmpdirMin: $(Math.ceil (inputs.file_size / 1048576))
    tmpdirMax: $(Math.ceil (inputs.file_size / 1048576))
    outdirMin: $(Math.ceil (inputs.file_size / 1048576))
    outdirMax: $(Math.ceil (inputs.file_size / 1048576))
  - class: EnvVarRequirement
    envDef:
    - envName: "REQUESTS_CA_BUNDLE"
      envValue: $(inputs.cert.path)

inputs:
  config_file:
    type: File?
  download_handle:
    type: string?
  cert:
      type: File
      default:
        class: File
        location: /etc/ssl/certs/ca-certificates.crt

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
