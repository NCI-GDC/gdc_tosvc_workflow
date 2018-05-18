#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: InitialWorkDirRequirement
    listing:
      $(inputs.gem_index)

inputs:
  ref_prefix:
    type: string
  tumor_bam:
    type: File
    secondaryFiles:
      - '^.bai'
  gem_index:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
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
        source: ref_prefix
        valueFrom: $(self + '.100')
    out: [mapfile]

  gem2wig:
    run: gem2wig.cwl
    in:
      index: gem_index
      infile: gem_mappability/mapfile
      outfile:
        source: ref_prefix
        valueFrom: $(self + '.100')
    out: [wigfile, sizefile]

  wig2bigwig:
    run: wig2bigwig.cwl
    in:
      wig: gem2wig/wigfile
      size: gem2wig/sizefile
      outfile:
        source: ref_prefix
        valueFrom: $(self + '.100.bigwig')
    out: [bigwigfile]