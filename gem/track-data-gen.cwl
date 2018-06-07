#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  tumor_bam:
    type: File
    secondaryFiles:
      - '.bai'
  gem_index:
    type: File
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
  bigwig_file:
    type: File
    outputSource: wig2bigwig/bigwigfile
  extracted_wig_file:
    type: File
    outputSource: extract_wig_size/extracted_wig_file
  extracted_size_file:
    type: File
    outputSource: extract_wig_size/extracted_size_file
  wig_file:
    type: File
    outputSource: gem2wig/wigfile
  size_file:
    type: File
    outputSource: gem2wig/sizefile
  map_file:
    type: File
    outputSource: gem_mappability/mapfile

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

  extract_wig_size:
    run: extract_wig_size.cwl
    in:
      wig_file: gem2wig/wigfile
      size_file: gem2wig/sizefile
    out: [extracted_wig_file, extracted_size_file]

  wig2bigwig:
    run: wig2bigwig.cwl
    in:
      wigfile: extract_wig_size/extracted_wig_file
      sizefile: extract_wig_size/extracted_size_file
    out: [bigwigfile]