#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  no_normaldb_vcf_file:
    type:
      type: array
      items: File
  normaldb_vcf_file:
    type:
      type: array
      items: File
  sample_info_file:
    type:
      type: array
      items: File
  dnacopy_seg_file:
    type:
      type: array
      items: File
  archive_tar_file:
    type:
      type: array
      items: File

outputs:
  output_vcf_file:
    type: File
  output_sample_info_file:
    type: File
  output_dnacopy_seg_file:
    type: File
  output_archive_tar_file:
    type: File

expression: |
   ${
      if (inputs.no_normaldb_vcf_file.length == 1 && inputs.normaldb_vcf_file.length == 0)  {
        var output_vcf = inputs.no_normaldb_vcf_file[0];
        var sample_info = null;
        var dnacopy_seg = null;
        var archive_tar = null;
      }
      else if (inputs.no_normaldb_vcf_file.length == 0 && inputs.normaldb_vcf_file.length == 1) {
        var output_vcf = inputs.normaldb_vcf_file[0];
        var sample_info = inputs.sample_info_file[0];
        var dnacopy_seg = inputs.dnacopy_seg_file[0];
        var archive_tar = inputs.other_files[0];
      }
      else {
        throw "The case is unhandled";
      }
      return {'output_vcf_file': output_vcf, 'output_sample_info_file': sample_info, 'output_dnacopy_seg_file': dnacopy_seg, 'output_archive_tar_file': archive_tar};
    }