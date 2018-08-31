#!/usr/bin/env cwl-runner

class: CommandLineTool
label: "ContigFilter"
cwlVersion: v1.0
doc: |
    Reduce VCF to contigs present in header

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/variant-filtration-tool:384f593b3dfc43acfc31d02e75589d2e2545008c 
  - class: InlineJavascriptRequirement

baseCommand: [python3, /opt/variant-filtration-tool/FilterContigs.py]

inputs:
  - id: input_vcf
    type: File
    doc: "input vcf file"
    inputBinding:
      prefix: --input_vcf

  - id: output_vcf
    type: string
    doc: output basename of vcf 
    inputBinding:
      prefix: --output_vcf

outputs:
  - id: output_vcf_file
    type: File
    outputBinding:
      glob: $(inputs.output_vcf)
