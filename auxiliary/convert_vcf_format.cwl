#!/usr/bin/env cwl-runner

class: CommandLineTool
label: "Picard VcfFormatConverter"
cwlVersion: v1.0
doc: |
    Converts a VCF.

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-biasfilter-tool:3839a594cab6b8576e76124061cf222fb3719f20
  - class: InlineJavascriptRequirement

baseCommand: [java, -Xmx4G, -jar, /opt/picard.jar, VcfFormatConverter, REQUIRE_INDEX=false]

inputs:
  - id: input_vcf_file
    type: File
    doc: "input vcf file"
    inputBinding:
      prefix: "INPUT="
      separate: false

  - id: output_vcf_filename
    type: string
    doc: output basename of output file
    inputBinding:
      prefix: "OUTPUT="
      separate: false

  - id: create_index
    type: string
    default: "true"
    inputBinding:
      prefix: "CREATE_INDEX="
      separate: false

outputs:
  - id: output_vcf_file
    type: File
    outputBinding:
      glob: $(inputs.output_vcf_filename)
    secondaryFiles:
      - ".tbi"