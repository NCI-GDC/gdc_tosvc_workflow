#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  - id: tumor_bam
    type: File
    secondaryFiles:
      - '.bai'
  - id: gem_index
    type: File
  - id: gem_thread_num
    type: int
    default: 40
  - id: gem_max_mismatch
    type: int
    default: 2
  - id: gem_max_edit
    type: int
    default: 2

outputs:
  - id: bigwig_file:
    type: File
    outputSource: wig2bigwig/bigwigfile
  - id: extracted_wig_file:
    type: File
    outputSource: extract_wig_size/extracted_wig_file
  - id: extracted_size_file:
    type: File
    outputSource: extract_wig_size/extracted_size_file
  - id: wig_file:
    type: File
    outputSource: gem2wig/wigfile
  - id: size_file:
    type: File
    outputSource: gem2wig/sizefile
  - id: map_file:
    type: File
    outputSource: gem_mappability/mapfile

steps:
  - id: get_readlen
    run: get_readlen.cwl
    in:
      bam: tumor_bam
    out: [readlen]
      
  - id: gem_mappability
    run: gem-mappability.cwl
    in:
      indexfile: gem_index
      readlen: get_readlen/readlen
      thread_num: gem_thread_num
      max_mismatch: gem_max_mismatch
      max_edit: gem_max_edit
    out: [mapfile]

  - id: gem2wig
    run: gem2wig.cwl
    in:
      indexfile: gem_index
      mapfile: gem_mappability/mapfile
    out: [wigfile, sizefile]

  - id: extract_wig_size
    run: extract_wig_size.cwl
    in:
      wig_file: gem2wig/wigfile
      size_file: gem2wig/sizefile
    out: [extracted_wig_file, extracted_size_file]

  - id: wig2bigwig
    run: wig2bigwig.cwl
    in:
      wigfile: extract_wig_size/extracted_wig_file
      sizefile: extract_wig_size/extracted_size_file
    out: [bigwigfile]