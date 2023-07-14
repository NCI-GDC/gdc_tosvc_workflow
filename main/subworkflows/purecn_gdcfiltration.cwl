class: Workflow
cwlVersion: v1.0
id: purecn_gdcfiltration
requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
doc: |
  purecn gdc filtration

inputs:
  #ref data
  fasta:
    type: File
    secondaryFiles: [.fai, ^.dict]

  #data for pipeline
  bam:
    type: File
    secondaryFiles: [^.bai]
  raw_vcf: File

  #PureCN ref files
  capture_interval: File
  normaldb: File

  #parameters
  chunks: long
  wgs: boolean
  fasta_version: string
  aliquotid: string
  thread_num: long
  seed: long
  filename_prefix: string
  var_prob_thres:
    type: float
    default: 0.2


outputs:
  filtered_vcf:
    type: File
    outputSource: determine_purecn_outputs/output_vcf_file
  filtration_metric:
    type: File?
    outputSource: determine_purecn_outputs/output_filtration_metric_file
  dnacopy_seg:
    type: File?
    outputSource: determine_purecn_outputs/output_dnacopy_seg_file
  tar:
    type: File?
    outputSource: determine_purecn_outputs/output_archive_tar_file
  output_suffix:
    type: string
    outputSource: determine_purecn_outputs/suffix

steps:
  run_purecn:
    run: run_purecn.cwl
    in:
      bam: bam
      raw_vcf: raw_vcf
      capture_interval: capture_interval
      normaldb: normaldb
      genome: fasta_version
      sampleid: aliquotid
      thread_num: thread_num
      seed: seed
      wgs: wgs
      chunks: chunks
    out: [
      chromosomes_pdf,
      csv,
      dnacopy_seg,
      genes_csv,
      local_optima_pdf,
      log,
      loh_csv,
      pdf,
      rds,
      segmentation_pdf,
      variants_csv,
      purecn_vcf,
      coverage_coverage,
      coverage_loess_png,
      coverage_loess_qc_txt,
      coverage_loess_txt
    ]

  determine_file_exists:
    run: ../tools/determine_file_exists.cwl
    in:
      purecn_vcf_file: run_purecn/purecn_vcf
    out: [ success_purecn, fail_purecn ]

  postprocess_purecn:
    run: postprocess_purecn.cwl
    scatter: success_purecn
    in:
      success_purecn: determine_file_exists/success_purecn
      aliquotid: aliquotid
      fai:
        source: fasta
        valueFrom: $(self.secondaryFiles[0])
      filename_prefix: filename_prefix
      var_prob_thres: var_prob_thres
      raw_vcf: raw_vcf
      purecn_chromosomes_pdf: run_purecn/chromosomes_pdf
      purecn_csv: run_purecn/csv
      purecn_dnacopy_seg: run_purecn/dnacopy_seg
      purecn_genes_csv: run_purecn/genes_csv
      purecn_local_optima_pdf: run_purecn/local_optima_pdf
      purecn_log: run_purecn/log
      purecn_loh_csv: run_purecn/loh_csv
      purecn_pdf: run_purecn/pdf
      purecn_segmentation_pdf: run_purecn/segmentation_pdf
      purecn_vcf: run_purecn/purecn_vcf
      purecn_coverage_coverage: run_purecn/coverage_coverage
      purecn_coverage_loess_png: run_purecn/coverage_loess_png
      purecn_coverage_loess_qc_txt: run_purecn/coverage_loess_qc_txt
      purecn_coverage_loess_txt: run_purecn/coverage_loess_txt
    out: [ out_vcf, filtration_metric, dnacopy_seg, tar_purecn_output ]

  annot_fail_purecn_vcf:
    run: ../tools/annot_fail_purecn_vcf.cwl
    scatter: fail_purecn
    in:
      fail_purecn: determine_file_exists/fail_purecn
      purecn_log: run_purecn/log
      vcf: raw_vcf
      output_filename:
        source: raw_vcf
        valueFrom: $(self.basename + ".annot_fail_purecn.vcf")
    out: [ output ]

  determine_purecn_outputs:
    run: ../tools/determine_purecn_outputs.cwl
    in:
      purecn_fail_vcf_file: annot_fail_purecn_vcf/output
      purecn_success_vcf_file: postprocess_purecn/out_vcf
      filtration_metric_file: postprocess_purecn/filtration_metric
      dnacopy_seg_file: postprocess_purecn/dnacopy_seg
      archive_tar_file: postprocess_purecn/tar_purecn_output
    out: [
      output_vcf_file,
      output_filtration_metric_file,
      output_dnacopy_seg_file,
      output_archive_tar_file,
      suffix
    ]
