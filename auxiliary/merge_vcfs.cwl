#!/usr/bin/env cwl-runner

class: CommandLineTool
label: "Picard MergeVcfs"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-biasfilter-tool:3839a594cab6b8576e76124061cf222fb3719f20
  - class: InlineJavascriptRequirement

baseCommand: [java, -Xmx4G, -jar, /opt/picard.jar, MergeVcfs]

inputs:
  - id: input_vcf_file
    type:
      type: array
      items: File
      inputBinding:
        prefix: INPUT=
        separate: false
  - id: seq_dict
    type: File
    doc: reference sequence dictionary file
    inputBinding:
      prefix: "SEQUENCE_DICTIONARY="
      separate: false
  - id: output_vcf_filename
    type: string
    doc: output basename of merged 
    inputBinding:
      prefix: OUTPUT=
      separate: false

outputs:
  - id: output_vcf_file
    type: File
    outputBinding:
      glob: $(inputs.output_vcf_filename)
    secondaryFiles:
      - ".tbi"
