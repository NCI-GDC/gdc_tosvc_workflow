#!/usr/bin/env cwl-runner

class: CommandLineTool
label: "Picard UpdateSequenceDictionary" 
cwlVersion: v1.0
doc: |
    Updates sequence dictionary in VCF 

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-biasfilter-tool:3839a594cab6b8576e76124061cf222fb3719f20
  - class: InlineJavascriptRequirement

baseCommand: [java, -Xmx4G, -jar, /opt/picard.jar, UpdateVcfSequenceDictionary]

inputs:
  - id: input_vcf
    type: File
    doc: "input vcf file"
    inputBinding:
      prefix: "INPUT="
      separate: false
  - id: sequence_dictionary
    type: File
    doc: sequence dictionary you want to update header with 
    inputBinding:
      prefix: SD= 
      separate: false
  - id: output_filename
    type: string
    doc: output basename of output file
    inputBinding:
      prefix: "OUTPUT="
      separate: false

outputs:
  - id: output_file
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
    doc: Updated VCF file 
