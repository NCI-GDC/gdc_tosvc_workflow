#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  sample_id:
    type: string
  fa_file:
    type: File
  fai_file:
    type: File
  mutect_vcf_file:
    type: File
  purecn_vcf_file:
    type: File
  sample_info_file:
    type: File
  dnacopy_seg_file:
    type: File
  var_prob_thres:
    type: float
    default: 0.2

outputs:
  gdc_vcf_file:
    type: File
    outputSource: merge_vcfs/output_vcf_file
  gdc_sample_info_file:
    type: File
    outputSource: modify_outputs/gdc_sample_info_file
  gdc_dnacopy_seg_file:
    type: File
    outputSource: modify_outputs/gdc_dnacopy_seg_file

steps:

  modify_outputs:
    run: modify_outputs.cwl
    in:
      sample_info_file:
        source: sample_info_file
      dnacopy_seg_file:
        source: dnacopy_seg_file
    out: [gdc_sample_info_file, gdc_dnacopy_seg_file]

  remove_nonstandard_variants_mutect:
    run: remove_nonstandard_variants.cwl
    in:
      input_vcf:
        source: mutect_vcf_file
      output_filename:
        valueFrom: "tmp.vcf"
    out: [output_file]

  remove_nonstandard_variants_purecn:
    run: remove_nonstandard_variants.cwl
    in:
      input_vcf:
        source: purecn_vcf_file
      output_filename:
        valueFrom: "std.vcf"
    out: [output_file]

  filter_purecn:
    run: filter_outputs.cwl
    in:
      input_vcf_file:
        source: remove_nonstandard_variants_purecn/output_file
      output_vcf_file:
        valueFrom: "filter.vcf"
      prob_thres:
        source: var_prob_thres
    out: [filter_vcf_file]

  merge_vcfs:
    run: merge_vcfs.cwl
    in:
      input_vcf: [remove_nonstandard_variants_mutect/output_file, filter_purecn/filter_vcf_file]
      sequence_dictionary:
        source: fai_file
      output_filename:
        source: sample_id
        valueFrom: $(self + ".gdc.vcf")
    out: [output_vcf_file]
