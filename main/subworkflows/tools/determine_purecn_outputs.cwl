#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: purecn_fail_vcf_file
    type:
      type: array
      items: ['null', File]
  - id: purecn_success_vcf_file
    type:
      type: array
      items: ['null', File]
  - id: filtration_metric_file
    type:
      type: array
      items: ['null', File]
  - id: dnacopy_seg_file
    type:
      type: array
      items: ['null', File]
  - id: archive_tar_file
    type:
      type: array
      items: ['null', File]

outputs:
  - id: output_vcf_file
    type: File
  - id: output_filtration_metric_file
    type: File?
  - id: output_dnacopy_seg_file
    type: File?
  - id: output_archive_tar_file
    type: File?
  - id: suffix
    type: string

expression: |
   ${
      if (inputs.purecn_success_vcf_file.length == 1 && inputs.purecn_fail_vcf_file.length == 0) {
        var output_vcf = inputs.purecn_success_vcf_file[0];
        var filtration_metric = inputs.filtration_metric_file[0];
        var dnacopy_seg = inputs.dnacopy_seg_file[0];
        var archive_tar = inputs.archive_tar_file[0];
        var suffix = ".passed"
      } else if (inputs.purecn_success_vcf_file.length == 0 && inputs.purecn_fail_vcf_file.length == 1) {
        var output_vcf = inputs.purecn_fail_vcf_file[0];
        var filtration_metric = null;
        var dnacopy_seg = null;
        var archive_tar = null;
        var suffix = ".unhandled"
      }
      else {
        throw "The case is unhandled";
      }
      return {'output_vcf_file': output_vcf,
              'output_filtration_metric_file': filtration_metric,
              'output_dnacopy_seg_file': dnacopy_seg,
              'output_archive_tar_file': archive_tar,
              'suffix': suffix};
    }
