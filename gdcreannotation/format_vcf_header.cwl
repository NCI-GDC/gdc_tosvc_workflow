#!/usr/bin/env cwl-runner

class: CommandLineTool
label: "FormatVcfHeader"
cwlVersion: v1.0
doc: |
    Format VCF header for GDC tumor-only variant calling pipeline

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:latest
  - class: InlineJavascriptRequirement

inputs:
  input_vcf:
    type: File
    doc: "input vcf file"
    inputBinding:
      prefix: --input_vcf

  output_vcf:
    type: string
    doc: output basename of vcf 
    inputBinding:
      prefix: --output_vcf

  reference_name:
    type: string?
    default: GRCh38.d1.vd1.fa
    inputBinding:
      prefix: --reference_name

  patient_barcode:
    type: string
    inputBinding:
      prefix: --patient_barcode

  case_id:
    type: string
    inputBinding:
      prefix: --case_id

  sample_barcode:
    type: string
    inputBinding:
      prefix: --sample_barcode

  aliquot_uuid:
    type: string
    inputBinding:
      prefix: --aliquot_uuid

  bam_uuid:
    type: string
    inputBinding:
      prefix: --bam_uuid

outputs:
  output_vcf_file:
    type: File
    outputBinding:
      glob: $(inputs.output_vcf)

baseCommand: [python, /gdc_tosvc_tools/format_vcf_header.py]
