class: CommandLineTool
cwlVersion: v1.0
id: purecn_coverage
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/purecn_docker:f0456fe84f64b058373ea386d6e860704ce88c4e
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
      prefix: --out-dir

  threads:
    type: long
    default: 8
    inputBinding:
      prefix: --cores

  chunks:
    type: long
    default: 60
    inputBinding:
      prefix: --chunks

  wgs:
    type: boolean
    default: false
    doc: If specified, it will include parameter `--skip-gc-norm`.
    inputBinding:
      prefix: --skip-gc-norm

outputs:
  coverage:
    type: File
    outputBinding:
      glob: "*coverage.txt.gz"

  loess_txt:
    type: File?
    outputBinding:
      glob: "*coverage_loess.txt.gz"

  loess_png:
    type: File?
    outputBinding:
      glob: "*coverage_loess.png"

  loess_qc_txt:
    type: File?
    outputBinding:
      glob: "*coverage_loess_qc.txt"

baseCommand: [Rscript, /usr/local/lib/R/site-library/PureCN/extdata/Coverage.R]
