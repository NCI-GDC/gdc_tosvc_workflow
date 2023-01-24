class: CommandLineTool
cwlVersion: v1.0
id: purecn
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/purecn_docker:2.2.0
successCodes:
  - 0
  - 1

doc: |
  purecn

inputs:
  sampleid:
    type: string
    inputBinding:
      prefix: --sampleid

  tumor:
    type: File
    inputBinding:
      prefix: --tumor

  raw_vcf:
    type: File
    inputBinding:
      prefix: --vcf

  intervals:
    type: File
    inputBinding:
      prefix: --intervals

  normaldb:
    type: File
    inputBinding:
      prefix: --normaldb

  genome:
    type: string
    default: hg38
    inputBinding:
      prefix: --genome

  cores:
    type: long
    inputBinding:
      prefix: --cores

  seed:
    type: long
    inputBinding:
      prefix: --seed

  force:
    type: boolean
    default: true
    inputBinding:
      prefix: --force

  normal:
    type: File?
    inputBinding:
      prefix: --normal

  normal_panel:
    type: File?
    inputBinding:
      prefix: --normal_panel

  outvcf:
    type: boolean
    default: true
    inputBinding:
      prefix: --out-vcf

  postoptimize:
    type: boolean
    default: true
    inputBinding:
      prefix: --post-optimize

  statsfile:
    type: File?
    inputBinding:
      prefix: --statsfile

  output_dir:
    type: string
    default: "."
    inputBinding:
      prefix: --out

  fun_segmentation:
    type: string
    default: PSCBS
    inputBinding:
      prefix: --fun-segmentation

outputs:
  chromosomes_pdf:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_chromosomes.pdf")

  csv:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + ".csv")

  dnacopy_seg:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_dnacopy.seg")

  genes_csv:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_genes.csv")

  local_optima_pdf:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_local_optima.pdf")

  log:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + ".log")

  loh_csv:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_loh.csv")

  pdf:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + ".pdf")

  rds:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + ".rds")

  segmentation_pdf:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_segmentation.pdf")

  variants_csv:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + "_variants.csv")

  out_vcf:
    type: File?
    outputBinding:
      glob: $(inputs.sampleid + ".vcf")

baseCommand: [Rscript, /usr/local/lib/R/site-library/PureCN/extdata/PureCN.R]
