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

inputs:
  input_vcf:
    type: File
    doc: "input vcf file"
    inputBinding:
      prefix: "INPUT="
      separate: false

  output_filename:
    type: string
    doc: output basename of output file
    inputBinding:
      prefix: "OUTPUT="
      separate: false

  create_index:
    type: string
    default: "true"
    inputBinding:
      prefix: "CREATE_INDEX="
      separate: false

outputs:
  output_vcf_file:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
  output_vcf_index_file:
    type: File
    outputBinding:
      glob: $(inputs.output_filename + ".tbi")

baseCommand: [java, -Xmx4G, -jar, /opt/picard.jar, VcfFormatConverter, REQUIRE_INDEX=false]
