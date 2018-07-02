#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  #input ref data
  - id: fa_file
    type: File
  - id: fai_file
    type: File
  - id: dict_file
    type: File
  - id: dict_main_file
    type: File

  #input data for pipeline
  - id: bam_file
    type: File
  - id: bai_file
    type: File
  - id: input_vcf_file
    type: File
  - id: capture_file
    type: File

  - id: bigwig_file
    type: File?
  - id: normaldb_file
    type: File?
  - id: target_weight_file
    type: File?

  #input parameters
  - id: fa_name
    type: string
  - id: fa_version
    type: string
  - id: bam_uuid
    type: string
  - id: sample_id
    type: string
  - id: sample_barcode
    type: string
  - id: aliquot_id
    type: string
  - id: patient_barcode
    type: string
  - id: case_id
    type: string
  - id: thread_num
    type: int
    default: 8
  - id: var_prob_thres
    type: float
    default: 0.2
  - id: file_prefix
    type: string

outputs:
  - id: output_vcf_file
    type: File
    outputSource: format_header/output_vcf_file
  - id: sample_info_file
    type: File
    outputSource: modify_outputs/output_sample_info_file
  - id: dnacopy_seg_file
    type: File
    outputSource: modify_outputs/output_dnacopy_seg_file
  - id: archive_tar_file
    type: File
    outputSource: tar_outputs/outfile

steps:
  - id: call_variants
    run: purecn/variant-data-gen.cwl
    in:
      fa_file:
        source: fa_file
      fai_file:
        source: fai_file
      genome:
        source: fa_version
      map_file:
        source: bigwig_file
      tumor_bam_file:
        source: bam_file
      tumor_bai_file:
        source: bai_file
      capture_file:
        source: capture_file
      input_vcf_file:
        source: input_vcf_file
      normaldb_file:
        source: normaldb_file
      target_weight_file:
        source: target_weight_file
      thread_num:
        source: thread_num
      sample_id:
        source: sample_id
      outinfo:
        valueFrom: "."
    out: [sample_info_file, chrome_file, dnacopy_file, genes_file, local_optima_file, log_file, loh_file, info_pdf_file, rds_file, segmentation_file, var_csv_file, var_vcf_file, interval_file, interval_bed_file, cov_file, loess_file, loess_png_file, loess_qc_file]

  - id: modify_outputs
    run: auxiliary/modify_outputs.cwl
    in:
      sample_info_file:
        source: call_variants/sample_info_file
      dnacopy_seg_file:
        source: call_variants/dnacopy_file
      modified_info_file:
        source: file_prefix
        valueFrom: $(self + ".variant_filtration_info.csv")
      modified_seg_file:
        source: file_prefix
        valueFrom: $(self + ".dnacopy_seg.csv")
    out: [output_sample_info_file, output_dnacopy_seg_file]

  - id: tar_outputs
    run: auxiliary/tar_outputs.cwl
    in:
      var_vcf_file:
        source: call_variants/var_vcf_file
      genes_file:
        source: call_variants/genes_file
      log_file:
        source: call_variants/log_file
      loh_file:
        source: call_variants/loh_file
      info_pdf_file:
        source: call_variants/info_pdf_file
      segmentation_file:
        source: call_variants/segmentation_file
      chrome_file:
        source: call_variants/chrome_file
      local_optima_file:
        source: call_variants/local_optima_file
      interval_file:
        source: call_variants/interval_file
      interval_bed_file:
        source: call_variants/interval_bed_file
      cov_file:
        source: call_variants/cov_file
      loess_file:
        source: call_variants/loess_file
      loess_png_file:
        source: call_variants/loess_png_file
      loess_qc_file:
        source: call_variants/loess_qc_file
      compress_file_name:
        source: file_prefix
        valueFrom: $(self + ".variant_filtration_archive.tar.gz")
    out: [outfile]

  - id: variant_filtration_reannotation
    run: gdcfiltration/variant_filtration_reannotation.cwl
    in:
      fa_file:
        source: fa_file
      fai_file:
        source: fai_file
      mutect_vcf_file:
        source: input_vcf_file
      purecn_vcf_file:
        source: call_variants/var_vcf_file
      var_prob_thres:
        source: var_prob_thres
      file_prefix:
        source: file_prefix
    out: [output_vcf_file]

  - id: update_dictionary
    run: auxiliary/update_seq_dict.cwl
    in:
      input_vcf:
        source: variant_filtration_reannotation/output_vcf_file
      sequence_dictionary:
        source: dict_main_file
      output_filename:
        source: file_prefix
        valueFrom: $(self + '.updatedseqdict.vcf')
    out: [output_file]

  - id: filter_contigs
    run: auxiliary/filter_contigs.cwl
    in:
      input_vcf:
        source: update_dictionary/output_file
      output_vcf:
        source: file_prefix
        valueFrom: $(self + '.updatedseqdict.contigfilter.vcf')
    out: [output_vcf_file]

  - id: format_header
    run: auxiliary/format_vcf_header.cwl
    in:
      input_vcf:
        source: filter_contigs/output_vcf_file
      output_vcf:
        source: file_prefix
        valueFrom: $(self + '.variant_filtration.vcf')
      reference_name:
        source: fa_name
      patient_barcode: 
        source: patient_barcode
      case_id:
        source: case_id
      tumor_barcode:
        source: sample_barcode
      tumor_aliquot_uuid:
        source: aliquot_id
      tumor_bam_uuid:
        source: bam_uuid
      normal_barcode:
        source: sample_barcode
      normal_aliquot_uuid:
        source: aliquot_id
      normal_bam_uuid:
        source: bam_uuid
    out: [output_vcf_file]
