#!/usr/bin/env cwl-runner

class: CommandLineTool
label: "Picard VcfFormatConverter"
cwlVersion: v1.0
doc: |
    Rename a sample within a VCF.

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-biasfilter-tool:3839a594cab6b8576e76124061cf222fb3719f20
  - class: InlineJavascriptRequirement

inputs:
  input_vcf_file:
    type: File
    doc: "input vcf file"
    inputBinding:
      prefix: "INPUT="
      separate: false
    secondaryFiles:
      - ".tbi"

  new_sample_name:
    type: string
    doc: new name of sample
    inputBinding:
      prefix: "NEW_SAMPLE_NAME="
      separate: false

  output_vcf_filename:
    type: string
    doc: output basename of output file
    inputBinding:
      prefix: "OUTPUT="
      separate: false

outputs:
  output_vcf_file:
    type: File
    outputBinding:
      glob: $(inputs.output_vcf_filename)

baseCommand: [java, -Xmx4G, -jar, /opt/picard.jar, RenameSampleInVcf]
