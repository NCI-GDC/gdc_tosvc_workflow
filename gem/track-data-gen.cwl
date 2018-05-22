#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: InitialWorkDirRequirement
    listing:
      $(inputs.tumor_bam)
      $(inputs.gem_index)

inputs:
  tumor_bam:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
    secondaryFiles:
      - '^.bai'
  gem_index:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
  gem_thread_num:
    type: int
    default: 40
  gem_max_mismatch:
    type: int
    default: 2
  gem_max_edit:
    type: int
    default: 2

outputs:
  track_data:
    type: File
    outputSource: wig2bigwig/bigwigfile

steps:
  get_readlen:
    run: get_readlen.cwl
    in:
      bam: tumor_bam
    out: [readlen]
      
  gem_mappability:
    run: gem-mappability.cwl
    in:
      indexfile: gem_index
      readlen: get_readlen/readlen
      thread_num: gem_thread_num
      max_mismatch: gem_max_mismatch
      max_edit: gem_max_edit
    out: [mapfile]

  gem2wig:
    run: gem2wig.cwl
    in:
      indexfile: gem_index
      mapfile: gem_mappability/mapfile
    out: [wigfile, sizefile]

  wig2bigwig:
    run: wig2bigwig.cwl
    in:
      wigfile: gem2wig/wigfile
      sizefile: gem2wig/sizefile
    out: [bigwigfile]