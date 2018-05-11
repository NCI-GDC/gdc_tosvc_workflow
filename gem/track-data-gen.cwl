#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  ref_name:
    type: string
  tumor_bam:
    type: File
    secondaryFiles:
      - '^.bai'
  gem_index:
    type: File
  gem_thread:
    type: int
  gem_len:
    type: int
  gem_max_mismatch:
    type: int
  gem_max_edit:
    type: int

outputs:
  track_data:
    type: File
    outputSource: wig2bigwig/bigwigfile

steps:
  gem_mappability:
    run: gem-mappability.cwl
    in:
      thread: gem_thread
      length: gem_len
      max_mismatch: gem_max_mismatch
      max_edit: gem_max_edit
      indexfile: gem_index
      outfile:
        source: ref_name
        valueFrom: $(self + '.100')
    out: [outfile_out]

  gem2wig:
    run: gem-2-wig.cwl
    in:
      index: gem_index
      infile: gem_mappability/outfile_out
      outfile:
        source: ref_name
        valueFrom: $(self + '.100.mappability')
    out: [outfile_out]

  wig2bigwig:
    run: wig2bigwig.cwl
    in:
      wig: gem2wig/outfile_out
      size:
        source: ref_name
        valueFrom: $(self + '.sizes')
      bigwig:
        source: ref_name
        valueFrom: $(self + '.100.bigwig')
    out: [bigwigfile]