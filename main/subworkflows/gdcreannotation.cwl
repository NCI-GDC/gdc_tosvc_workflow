class: Workflow
cwlVersion: v1.0
id: gdc_reannotation
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
doc: |
  gdc re-annotation

inputs:
  aliquotid: string
  bam_uuid: string
  caseid: string
  dict_main: File
  fasta_name: string
  filename_prefix: string
  patient_barcode: string
  sample_barcode: string
  vcf: File

outputs:
  anno_output:
    type: File
    outputSource: vcfformatconverter/output

steps:
  update_dictionary:
    run: ../tools/picard_updatevcfsequencedictionary.cwl
    in:
      input: vcf
      sequence_dictionary: dict_main
      output_filename:
        source: vcf
        valueFrom: $(self.basename + ".updatedseqdict.vcf")
    out: [output]

  filter_contigs:
    run: ../tools/gdc_variant_filtration_tool.cwl
    in:
      input_vcf: update_dictionary/output
      output_vcf:
        source: update_dictionary/output
        valueFrom: $(self.basename + ".filtered_contigs.vcf")
    out: [output_vcf_file]

  format_header:
    run: ../tools/gdc_format_vcf_header.cwl
    in:
      input_vcf: filter_contigs/output_vcf_file
      output_vcf:
        source: filter_contigs/output_vcf_file
        valueFrom: $(self.basename + ".gdcheader.vcf")
      reference_name: fasta_name
      patient_barcode: patient_barcode
      caseid: caseid
      sample_barcode: sample_barcode
      aliquot_uuid: aliquotid
      bam_uuid: bam_uuid
    out: [output_vcf_file]

  sortvcf:
    run: ../tools/picard_sortvcf.cwl
    in:
      input: format_header/output_vcf_file
      output_filename:
        source: format_header/output_vcf_file
        valueFrom: $(self.basename + ".gz")
    out: [output]

  rename_sample:
    run: ../tools/picard_renamesampleinvcf.cwl
    in:
      input: sortvcf/output
      new_sample_name:
        valueFrom: "TUMOR"
      output_filename:
        source: sortvcf/output
        valueFrom: $(self.basename)
    out: [output]

  vcfformatconverter:
    run: ../tools/picard_vcfformatconverter.cwl
    in:
      input: rename_sample/output
      output_filename:
        source: filename_prefix
        valueFrom: $(self + ".variant_filtration.vcf.gz")
    out: [output]
