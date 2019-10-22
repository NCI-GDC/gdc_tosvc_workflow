#!/usr/bin/env cwl-runner

class: CommandLineTool
label: "Picard VcfFormatConverter"
cwlVersion: v1.0
doc: Sort a VCF file.

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-biasfilter-tool:3839a594cab6b8576e76124061cf222fb3719f20
  - class: InlineJavascriptRequirement

baseCommand: [java, -Xmx4G, -jar, /opt/picard.jar, SortVcf]

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
  - id: seq_dict
    type: string
    default: "null"
    inputBinding:
      prefix: "SEQUENCE_DICTIONARY="
      separate: false

outputs:
  - id: output_vcf_file
    type: File
    outputBinding:
      glob: $(inputs.output_vcf_filename)
    secondaryFiles:
      - ".tbi"
