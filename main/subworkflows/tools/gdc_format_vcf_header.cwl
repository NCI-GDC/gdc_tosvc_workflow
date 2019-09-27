#!/usr/bin/env cwl-runner

class: CommandLineTool
label: "FormatVcfHeader"
cwlVersion: v1.0
doc: Format VCF header for GDC tumor-only variant calling pipeline

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_tosvc_tools:53aa36674ecf31cfdf3c853046010b6593488d6a
  - class: InlineJavascriptRequirement

baseCommand: [python, /gdc_tosvc_tools/format_vcf_header.py]

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

  - id: reference_name
    type: [string, "null"]
    default: GRCh38.d1.vd1.fa
    inputBinding:
      prefix: --reference_name

  - id: patient_barcode
    type: string
    inputBinding:
      prefix: --patient_barcode

  - id: caseid
    type: string
    inputBinding:
      prefix: --case_id

  - id: sample_barcode
    type: string
    inputBinding:
      prefix: --sample_barcode

  - id: aliquot_uuid
    type: string
    inputBinding:
      prefix: --aliquot_uuid

  - id: bam_uuid
    type: string
    inputBinding:
      prefix: --bam_uuid

outputs:
  - id: output_vcf_file
    type: File
    outputBinding:
      glob: $(inputs.output_vcf)
