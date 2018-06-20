#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:latest
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

baseCommand: [/usr/local/bin/bio_client.py]

inputs:
  - id: config_file
    type: File
    inputBinding:
      prefix: --config-file
      position: 0

  - id: upload
    type: string
    default: upload
    inputBinding:
      position: 1

  - id: upload_bucket
    type: string
    inputBinding:
      prefix: --upload-bucket
      position: 2

  - id: upload_key
    type: string
    inputBinding:
      prefix: --upload_key
      position: 3

  - id: input_file
    type: File
    inputBinding:
      position: 99

outputs:
  - id: output_file
    type: File
    outputBinding:
      glob: "*_upload.json"

  - id: output_file_uuid
    type: string 
    outputBinding:
      glob: "*_upload.json"      
      loadContents: true
      outputEval: |
        ${
           var data = JSON.parse(self[0].contents);
           return(data["did"]);
         }