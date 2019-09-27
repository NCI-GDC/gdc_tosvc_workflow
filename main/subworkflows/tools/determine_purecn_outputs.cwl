#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: purecn_fail_vcf_file
    type:
      type: array
      items: [File, "null"]

  - id: purecn_success_vcf_file
    type:
      type: array
      items: [File, "null"]

  - id: filtration_metric_file
    type:
      type: array
      items: [File, "null"]

  - id: dnacopy_seg_file
    type:
      type: array
      items: [File, "null"]

  - id: archive_tar_file
    type:
      type: array
      items: [File, "null"]

outputs:
  - id: vcf
    type: File

  - id: filtration_metric
    type: [File, "null"]

  - id: dnacopy_seg
    type: [File, "null"]

  - id: tar
    type: [File, "null"]

expression: |
   ${
      if (inputs.purecn_success_vcf_file.length == 1 && inputs.purecn_fail_vcf_file.length == 0) {
        var output_vcf = inputs.purecn_success_vcf_file[0];
        var filtration_metric = inputs.filtration_metric_file[0];
        var dnacopy_seg = inputs.dnacopy_seg_file[0];
        var archive_tar = inputs.archive_tar_file[0];
      } else if (inputs.purecn_success_vcf_file.length == 0 && inputs.purecn_fail_vcf_file.length == 1) {
        var output_vcf = inputs.purecn_fail_vcf_file[0];
        var filtration_metric = null;
        var dnacopy_seg = null;
        var archive_tar = null;
      }
      else {
        throw "The case is unhandled";
      }
      return {'vcf': output_vcf, 'filtration_metric': filtration_metric,
              'dnacopy_seg': dnacopy_seg, 'tar': archive_tar};
    }
