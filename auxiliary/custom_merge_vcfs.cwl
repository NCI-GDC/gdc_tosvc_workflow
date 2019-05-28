#!/usr/bin/env cwl-runner

class: CommandLineTool
label: "Custom Merge VCFs"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:840151119b319e13e257ddb6a8669f1c8a543ae4 
  - class: InlineJavascriptRequirement

baseCommand: [python, /gdc_tosvc_tools/filter_mutect_outputs.py]

inputs:
  purecn_vcf:
    type: File
    inputBinding:
      prefix: --purecn_vcf 
    secondaryFiles:
      - .tbi

  raw_vcf: 
    type: File
    doc: reference sequence dictionary file
    inputBinding:
      prefix: --raw_vcf 
    secondaryFiles:
      - .tbi

  output_vcf_filename:
    type: string
    doc: output basename of merged 
    inputBinding:
      prefix: --output_vcf 

outputs:
  output_vcf_file:
    type: File
    outputBinding:
      glob: $(inputs.output_vcf_filename)
    secondaryFiles:
      - ".tbi"
