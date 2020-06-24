class: CommandLineTool
cwlVersion: v1.0
id: purecn_coverage
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn:1.14.3
doc: |
  purecn coverage

inputs:
  bam:
    type: File
    inputBinding:
      prefix: --bam
    secondaryFiles:
      - ^.bai

  force:
    type: boolean
    default: true
    inputBinding:
      prefix: --force

  interval:
    type: File
    inputBinding:
      prefix: --interval

  outdir:
    type: string
    default: "."
    inputBinding:
      prefix: --outdir

  threads:
    type: long
    default: 24
    inputBinding:
      prefix: --cores

outputs:
  coverage:
    type: File
    outputBinding:
      glob: "*coverage.txt"

  loess_txt:
    type: File
    outputBinding:
      glob: "*coverage_loess.txt"

  loess_png:
    type: File
    outputBinding:
      glob: "*coverage_loess.png"

  loess_qc_txt:
    type: File
    outputBinding:
      glob: "*coverage_loess_qc.txt"

baseCommand: [Rscript, /usr/local/lib/R/site-library/PureCN/extdata/Coverage.R]
