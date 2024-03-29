class: CommandLineTool
cwlVersion: v1.0
id: purecn
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/purecn_docker:2.6.4
successCodes:
  - 0
  - 1

doc: |
  purecn

inputs:
  sampleid:
    type: string

  tumor:
    type: File

  raw_vcf:
    type: File

  intervals:
    type: File

  normaldb:
    type: File

  genome:
    type: string
    default: hg38

  cores:
    type: long

  seed:
    type: long

  force:
    type: boolean
    default: true

  outvcf:
    type: boolean
    default: true

  postoptimize:
    type: boolean
    default: true

  output_dir:
    type: string
    default: "."

  fun_segmentation:
    type: string
    default: PSCBS

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
    type: File
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

baseCommand: [bash, "-c"]

arguments:
  - position: 0
    shellQuote: false
    valueFrom: >-
      Rscript
      /usr/local/lib/R/site-library/PureCN/extdata/PureCN.R
      --sampleid $(inputs.sampleid)
      --tumor $(inputs.tumor.path)
      --vcf $(inputs.raw_vcf.path)
      --intervals $(inputs.intervals.path)
      --normaldb $(inputs.normaldb.path)
      --genome $(inputs.genome)
      --cores $(inputs.cores)
      --seed $(inputs.seed)
      --force $(inputs.force)
      --out-vcf $(inputs.outvcf)
      --post-optimize $(inputs.postoptimize)
      --out $(inputs.output_dir)
      --fun-segmentation $(inputs.fun_segmentation) 2>&1 | tee $(inputs.sampleid).log
