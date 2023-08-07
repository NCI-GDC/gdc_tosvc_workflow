class: Workflow
cwlVersion: v1.0
id: normaldb_workflow
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
doc: |
  create normaldb for PureCN

inputs:
  fasta:
    type: File
    secondaryFiles: [.fai, ^.dict]

  genome:
    type: string
    default: hg38

  baits_bed_file: File

  mappability: File

  bam_files:
    type: File[]
    inputBinding:
      prefix: --bam
    secondaryFiles:
      - ^.bai

  threads:
    type: long
    default: 8
    doc: One thread per BAM file. Not Chunk.
    inputBinding:
      prefix: --cores

  chunks:
    type: long
    default: 60
    inputBinding:
      prefix: --chunks

outputs:
    intervalfile:
      type: File
      outputSource: run_purecn_intervalfile/interval

    normaldb:
      type: File
      outputSource: extract_normaldb/rds_file

steps:
  run_purecn_intervalfile:
    run: ../main/tools/purecn_intervals.cwl
    in:
      fasta: fasta
      genome: genome
      infile: baits_bed_file
      mappability: mappability
    out: [interval, bed]

  run_all_purecn_coverage:
    run: ../main/tools/purecn_coverage.cwl
    scatter: bam
    in:
      bam: bam_files
      interval: run_purecn_intervalfile/interval
      threads: threads
      chunks: chunks
    out: [coverage, loess_png, loess_qc_txt, loess_txt]

  run_purecn_normaldb:
    run: ../main/tools/purecn_normaldb.cwl
    in:
      inputcoveragefiles: run_all_purecn_coverage/loess_txt
      genome: genome
    out: [normaldb]

  extract_normaldb:
    run: ./find_rds.cwl
    in:
      dir: run_purecn_normaldb/normaldb
    out: [rds_file]

