class: Workflow
cwlVersion: v1.0
id: transform
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
doc: |
  main transform workflow

inputs:
  # Metadata
  job_uuid: string
  experimental_strategy: string
  project_id: string?
  caller_id: string?
  aliquot_id: string
  case_id: string
  bam_uuid: string
  patient_barcode: string
  sample_barcode: string
  # Parameter
  run_without_normaldb:
    type:
      type: array
      items: int
  run_with_normaldb:
    type:
      type: array
      items: int
  fasta_version: string
  fasta_name: string
  chunks: long
  wgs: boolean
  thread_num: long
  seed: long
  var_prob_thres:
    type: float
    default: 0.2
  # Inputs
  reference:
    type: File
    secondaryFiles: [.fai, ^.dict]
  tumor_bam:
    type: File
    secondaryFiles: [^.bai]
  raw_vcf:
    type: File
    secondaryFiles: [.tbi]
  capture_interval: File?
  normaldb: File?
  main_dict: File


steps:
  get_prefix:
    run: ../tools/make_file_prefix.cwl
    in:
      job_uuid: job_uuid
      experimental_strategy: experimental_strategy
      projectid: project_id
      callerid: caller_id
      run_with_normaldb: run_with_normaldb
    out: [ output ]

  remove_nonstandard_variants:
    run: ../tools/remove_nonstandard_variants.cwl
    in:
      input: raw_vcf
      output_filename:
        valueFrom: "std.vcf"
    out: [ output ]

  filter_mutect_no_normaldb:
    run: ../tools/filter_mutect_outputs.cwl
    scatter: run_without_normaldb
    in:
      run_without_normaldb: run_without_normaldb
      input: remove_nonstandard_variants/output
      output_filename:
        source: remove_nonstandard_variants/output
        valueFrom: $(self.basename + ".filtered_mutect.vcf")
    out: [ output ]

  purecn_with_normaldb:
    run: purecn_gdcfiltration.cwl
    scatter: run_with_normaldb
    in:
      run_with_normaldb: run_with_normaldb
      fasta: reference
      bam: tumor_bam
      raw_vcf: raw_vcf
      capture_interval: capture_interval
      normaldb: normaldb
      fasta_version: fasta_version
      aliquotid: aliquot_id
      thread_num: thread_num
      seed: seed
      filename_prefix: get_prefix/output
      var_prob_thres: var_prob_thres
      chunks: chunks
      wgs: wgs
    out: [ filtered_vcf, filtration_metric, dnacopy_seg, tar, output_suffix ]

  determine_filtration:
    run: ../tools/determine_purecn_gdcfiltration.cwl
    in:
      archive_tar_file: purecn_with_normaldb/tar
      dnacopy_seg_file: purecn_with_normaldb/dnacopy_seg
      filtration_metric_file: purecn_with_normaldb/filtration_metric
      normaldb_vcf_file: purecn_with_normaldb/filtered_vcf
      no_normaldb_vcf_file: filter_mutect_no_normaldb/output
    out: [ dnacopy_seg, filtration_metric, tar, vcf ]

  annotation:
    run: gdcreannotation.cwl
    in:
      aliquotid: aliquot_id
      bam_uuid: bam_uuid
      caseid: case_id
      dict_main: main_dict
      fasta_name: fasta_name
      filename_prefix:
        source: [ get_prefix/output, purecn_with_normaldb/output_suffix ]
        valueFrom: $(self[0] + self[1])
      patient_barcode: patient_barcode
      sample_barcode: sample_barcode
      vcf: determine_filtration/vcf
    out: [ anno_output ]

outputs:
  purecn_dnacopy_seg:
    type: File?
    outputSource: determine_filtration/dnacopy_seg
  purecn_filtration_metric:
    type: File?
    outputSource: determine_filtration/filtration_metric
  purecn_tar:
    type: File?
    outputSource: determine_filtration/tar
  annotated_vcf:
    type: File
    outputSource: annotation/anno_output
