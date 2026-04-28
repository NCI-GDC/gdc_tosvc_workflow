class: CommandLineTool
cwlVersion: v1.0
id: gdc_variant_filtration_tool
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/variant-filtration-tool:{{ variant_filtration_tool }}"
  - class: InlineJavascriptRequirement
doc: |
    Reduce VCF to contigs present in header

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

outputs:
  output_vcf_file:
    type: File
    outputBinding:
      glob: $(inputs.output_vcf)

baseCommand: [gdc_filtration_tools, filter-contigs]
