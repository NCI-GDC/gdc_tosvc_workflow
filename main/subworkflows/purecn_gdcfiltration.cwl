#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

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

  #parameters
  seed: long
  aliquotid: string
  fasta_version: string
  filename_prefix: string
  thread_num: long
  var_prob_thres:
    type: float
    default: 0.2

  #GEM and PureCN ref files
  bigwig: File
  capture_kit: File
  gemindex: File
  intervalweightfile: File
  normaldb: File

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
  call_somatic_variants:
    run: call_somatic_variants.cwl
    in:
      sampleid: aliquotid
      fasta: fasta
      genome: fasta_version
      bam: bam
      raw_vcf: raw_vcf
      bigwig: bigwig
      capture_kit: capture_kit
      normaldb: normaldb
      intervalweightfile: intervalweightfile
      thread_num: thread_num
      seed: seed
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
      interval_bed,
      interval_interval,
      coverage_coverage,
      coverage_loess_png,
      coverage_loess_qc_txt,
      coverage_loess_txt
    ]

  determine_file_exists:
    run: tools/determine_file_exists.cwl
    in:
      purecn_vcf_file: call_somatic_variants/purecn_vcf
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
      purecn_chromosomes_pdf: call_somatic_variants/chromosomes_pdf
      purecn_csv: call_somatic_variants/csv
      purecn_dnacopy_seg: call_somatic_variants/dnacopy_seg
      purecn_genes_csv: call_somatic_variants/genes_csv
      purecn_local_optima_pdf: call_somatic_variants/local_optima_pdf
      purecn_log: call_somatic_variants/log
      purecn_loh_csv: call_somatic_variants/loh_csv
      purecn_pdf: call_somatic_variants/pdf
      purecn_segmentation_pdf: call_somatic_variants/segmentation_pdf
      purecn_vcf: call_somatic_variants/purecn_vcf
      purecn_interval_interval: call_somatic_variants/interval_interval
      purecn_interval_bed: call_somatic_variants/interval_bed
      purecn_coverage_coverage: call_somatic_variants/coverage_coverage
      purecn_coverage_loess_png: call_somatic_variants/coverage_loess_png
      purecn_coverage_loess_qc_txt: call_somatic_variants/coverage_loess_qc_txt
      purecn_coverage_loess_txt: call_somatic_variants/coverage_loess_txt
    out: [ out_vcf, filtration_metric, dnacopy_seg, tar_purecn_output ]

  annot_fail_purecn_vcf:
    run: tools/annot_fail_purecn_vcf.cwl
    scatter: fail_purecn
    in:
      fail_purecn: determine_file_exists/fail_purecn
      purecn_log: call_somatic_variants/log
      vcf: raw_vcf
      output_filename:
        source: raw_vcf
        valueFrom: $(self.basename + ".annot_fail_purecn.vcf")
    out: [ output ]

  determine_purecn_outputs:
    run: tools/determine_purecn_outputs.cwl
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
