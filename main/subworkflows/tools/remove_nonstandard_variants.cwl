#!/usr/bin/env cwl-runner

class: CommandLineTool
label: Drops non-standard VCF alleles
cwlVersion: v1.0
doc: |
    Filters (REMOVES!) rows from VCF with non-standard alleles

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-biasfilter:de5a941fe830deea0ff2544fbbe521a783cf629f988277786720e66e3a4dbb13
  - class: InlineJavascriptRequirement

baseCommand: [/usr/local/bin/RemoveNonStandardVariants.py]

inputs:
  - id: input_vcf
    type: File
    doc: input vcf file
    inputBinding:
      position: 0

  - id: output_filename
    type: string
    doc: output basename of output file
    inputBinding:
        position: 1

outputs:
  - id: output_vcf
    type: File
    doc: Filtered VCF file
    outputBinding:
      glob: $(inputs.output_filename)
