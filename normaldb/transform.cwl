#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: bams
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
  - id: bed
    type: File
  - id: fasta
    type: File
    secondaryFiles:
      - .fai
  - id: bigwig
    type: File
  - id: genome
    type: string
  - id: project_id
    type: string
  - id: target_capture_kit
    type: string

outputs:
  - id: purecn_bed
    type: [File, "null"]
    outputSource: rename_bed/output
  - id: purecn_png
    type: File
    outputSource: rename_png/output
  - id: purecn_rds
    type: File
    outputSource: rename_rds/output
  - id: purecn_txt
    type: File
    outputSource: rename_txt/output

steps:
  - id: purecn_intervals
    run: tools/purecn_intervals.cwl
    in:
      - id: bed
        source: bed
      - id: fasta
        source: fasta
      - id: bigwig
        source: bigwig
    out:
      - id: output

  - id: purecn_coverage
    run: tools/purecn_coverage.cwl
    scatter: [bam]
    in:
      - id: bam
        source: bams
      - id: interval
        source: purecn_intervals/output
    out:
      - id: coverage
      - id: loess_txt
      - id: loess_png
      - id: loess_qc_txt

  - id: listloess
    run: tools/listfiles.cwl
    in:
      - id: files
        source: purecn_coverage/loess_txt
      - id: outname
        valueFrom: purecn_loess.lst
    out:
      - id: output

  - id: purecn_normaldb
    run: tools/purecn_normaldb.cwl
    in:
      - id: inputcoveragefiles
        source: purecn_coverage/loess_txt
      - id: coveragefiles
        source: listloess/output
    out:
      - id: bed
      - id: png
      - id: rds
      - id: txt

  - id: rename_bed
    run: tools/rename.cwl
    in:
      - id: input
        source: purecn_normaldb/bed
      - id: filename
        source: [
        target_capture_kit,
        project_id,
        genome
        ]
        valueFrom: low_coverage_targets.$(self[0].replace(/\s/g, '').toLowerCase()).$(self[1].toLowerCase()).$(self[2]).bed
    out:
      - id: output

  - id: rename_png
    run: tools/rename.cwl
    in:
      - id: input
        source: purecn_normaldb/png
      - id: filename
        source: [
        target_capture_kit,
        project_id,
        genome
        ]
        valueFrom: interval_weights.$(self[0].replace(/\s/g, '').toLowerCase()).$(self[1].toLowerCase()).$(self[2]).png
    out:
      - id: output

  - id: rename_rds
    run: tools/rename.cwl
    in:
      - id: input
        source: purecn_normaldb/rds
      - id: filename
        source: [
        target_capture_kit,
        project_id,
        genome
        ]
        valueFrom: normalDB.$(self[0].replace(/\s/g, '').toLowerCase()).$(self[1].toLowerCase()).$(self[2]).rds
    out:
      - id: output

  - id: rename_txt
    run: tools/rename.cwl
    in:
      - id: input
        source: purecn_normaldb/txt
      - id: filename
        source: [
        target_capture_kit,
        project_id,
        genome
        ]
        valueFrom: interval_weights.$(self[0].replace(/\s/g, '').toLowerCase()).$(self[1].toLowerCase()).$(self[2]).txt
    out:
      - id: output
