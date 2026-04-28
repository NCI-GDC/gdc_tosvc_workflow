class: CommandLineTool
cwlVersion: v1.0
id: remove_nonstandard_variants
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/variant-filtration-tool:{{ variant_filtration_tool }}"
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
doc: |
  remove nonstandard variants

inputs:
  input_vcf:
    type: File
    doc: Input VCF file (.vcf or .vcf.gz)
    inputBinding:
      position: 1

  output_vcf:
    type: string
    default: filtered.vcf.gz
    doc: Output VCF filename
    inputBinding:
      position: 2

outputs:
  filtered_vcf:
    type: File
    doc: Filtered VCF output
    outputBinding:
      glob: $(inputs.output_vcf)

  filtered_vcf_index:
    type: File?
    doc: Tabix index (only if output is .gz)
    outputBinding:
      glob: $(inputs.output_vcf + ".tbi")

baseCommand: [python3, /opt/variant-filtration-tool/filter_nonstandard_variants.py]

