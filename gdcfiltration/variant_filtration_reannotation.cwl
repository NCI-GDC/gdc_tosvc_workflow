#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  fa_file:
    type: File
  fai_file:
    type: File
  mutect_vcf_file:
    type: File
  purecn_vcf_file:
    type: File
  var_prob_thres:
    type: float
    default: 0.2
  filename_prefix:
    type: string

outputs:
  output_vcf_file:
    type: File
    outputSource: filter_purecn/output_vcf_file

steps:
  merge_vcfs:
    run: merge_vcfs.cwl
    in:
      input_vcf_file: [mutect_vcf_file, purecn_vcf_file]
      seq_dict:
        source: fai_file
      output_vcf_filename:
        source: filename_prefix
        valueFrom: $(self + ".merged_mutect_purecn.vcf")
    out: [output_vcf_file]

  filter_purecn:
    run: filter_purecn_outputs.cwl
    in:
      input_vcf_file:
        source: merge_vcfs/output_vcf_file
      prob_thres:
        source: var_prob_thres
      output_vcf_filename:
        source: filename_prefix
        valueFrom: $(self + ".filtered_purecn.vcf")
    out: [output_vcf_file]
