#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:latest
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

baseCommand: []

inputs:
  - id: config_file
    type: File?
  - id: upload_bucket
    type: string?
  - id: upload_key
    type: string?
  - id: input_file
    type: File?

outputs:
  - id: output_file_uuid
    type: string?
    outputBinding:
      glob: "*_upload.json"      
      loadContents: true
      outputEval: |
        ${
           if(self.length > 0) {
               var data = JSON.parse(self[0].contents);
               return(data["did"]);
           } else {
               return null
           }
         }

arguments:
  - valueFrom: |
      ${
         var tool = "/usr/local/bin/bio_client.py"
         var reqs = ["config_file", "upload_bucket", "upload_key"]
         var cmd = []
         if(inputs.input_file !== null) {
             for(var i=0; i < reqs.length; i++) {
                 if(inputs[i] === null) {
                     throw "Missing required option " + i
                 }
             }
             cmd.push(tool)
             cmd.push("--config-file")
             cmd.push(inputs['config_file'].path)
             cmd.push("upload")
             cmd.push("--upload-bucket")
             cmd.push(inputs['upload_bucket'])
             cmd.push("--upload_key")
             cmd.push(inputs['upload_key'])
             cmd.push(inputs.input_file)
         } else {
             cmd.push("true")
         }
         return cmd
       }
