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
  var_prob_thres:
    type: float
    default: 0.2

outputs:
  output_vcf_file:
    type: File
    outputSource: merge_vcfs/output_vcf_file

steps:
  filter_purecn:
    run: filter_purecn_outputs.cwl
    in:
      input_vcf_file:
        source: purecn_vcf_file
      prob_thres:
        source: var_prob_thres
      output_vcf_filename:
        source: sample_id
        valueFrom: $(self + ".purecn.gdc_filtration.vcf")
    out: [output_vcf_file]

  merge_vcfs:
    run: merge_vcfs.cwl
    in:
      input_vcf: [mutect_vcf_file, filter_purecn/output_vcf_file]
      sequence_dictionary:
        source: fai_file
      output_filename:
        source: sample_id
        valueFrom: $(self + ".purecn.gdc_filtration.merged.vcf")
    out: [output_vcf_file]
