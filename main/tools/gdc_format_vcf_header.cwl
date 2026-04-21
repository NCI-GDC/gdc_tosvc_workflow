class: CommandLineTool
cwlVersion: v1.0
id: gdc_format_vcf_header
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/gdc-tosvc-tools:{{ gdc_tosvc_tools }}"
  - class: InlineJavascriptRequirement
doc: |
  Format VCF header for GDC tumor-only variant calling pipeline

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
    type: [string, "null"]
    default: GRCh38.d1.vd1.fa
    inputBinding:
      prefix: --reference_name

  patient_barcode:
    type: string
    inputBinding:
      prefix: --patient_barcode

  caseid:
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

baseCommand: []
arguments:
  - position: 0
    valueFrom: "format_vcf_header"
  - position: 99
    valueFrom: "format_vcf_header"
