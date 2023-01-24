class: Workflow
cwlVersion: v1.0
id: postprocess_purecn
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
doc: |
  post-process purecn

inputs:
  filename_prefix: string
  var_prob_thres: float
  aliquotid: string
  fai: File
  raw_vcf: File
  purecn_vcf: File
  purecn_csv: File
  purecn_dnacopy_seg: File
  purecn_segmentation_pdf: File
  purecn_loh_csv: File
  purecn_chromosomes_pdf: File
  purecn_genes_csv: File
  purecn_local_optima_pdf: File
  purecn_pdf: File
  purecn_log: File
  purecn_coverage_coverage: File
  purecn_coverage_loess_png: File
  purecn_coverage_loess_qc_txt: File
  purecn_coverage_loess_txt: File

outputs:
  out_vcf:
    type: File
    outputSource: filter_purecn_outputs/output
  filtration_metric:
    type: File
    outputSource: modify_purecn_outputs/output_filtration_metric_file
  dnacopy_seg:
    type: File
    outputSource: modify_purecn_outputs/output_dnacopy_seg_file
  tar_purecn_output:
    type: File
    outputSource: tar_purecn/output

steps:
  picard_sortvcf:
    run: ../tools/picard_sortvcf.cwl
    in:
      input: purecn_vcf
      output_filename:
        source: purecn_vcf
        valueFrom: $(self.basename + ".gz")
    out: [output]

  picard_mergevcfs:
    run: ../tools/picard_mergevcfs.cwl
    in:
      input: [ raw_vcf, picard_sortvcf/output ]
      output_filename:
        source: filename_prefix
        valueFrom: $(self + ".merged_mutect_purecn.vcf")
      sequence_dictionary: fai
    out: [output]

  filter_purecn_outputs:
    run: ../tools/filter_purecn_outputs.cwl
    in:
      vcf: picard_mergevcfs/output
      prob_thres: var_prob_thres
      output_filename:
        source: filename_prefix
        valueFrom: $(self + ".filtered_purecn.vcf")
    out: [output]

  modify_purecn_outputs:
    run: ../tools/modify_purecn_outputs.cwl
    in:
      sample_id: aliquotid
      metric_file: purecn_csv
      dnacopy_seg_file: purecn_dnacopy_seg
      modified_metric_file:
        source: filename_prefix
        valueFrom: $(self + ".filtration_metric.tsv")
      modified_seg_file:
        source: filename_prefix
        valueFrom: $(self + ".dnacopy_seg.tsv")
    out: [
      output_filtration_metric_file,
      output_dnacopy_seg_file
      ]

  tar_purecn:
    run: ../tools/tar_gz.cwl
    in:
      input:
        source: [
          raw_vcf,
          purecn_csv,
          purecn_dnacopy_seg,
          purecn_segmentation_pdf,
          purecn_loh_csv,
          purecn_chromosomes_pdf,
          purecn_genes_csv,
          purecn_local_optima_pdf,
          purecn_pdf,
          purecn_log,
          purecn_coverage_coverage,
          purecn_coverage_loess_png,
          purecn_coverage_loess_qc_txt,
          purecn_coverage_loess_txt
        ]
      file:
        source: filename_prefix
        valueFrom: $(self + ".variant_filtration_archive.tar.gz")
    out: [output]
