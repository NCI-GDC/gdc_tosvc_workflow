class: ExpressionTool
cwlVersion: v1.0
id: determine_purecn_gdcfiltration
requirements:
  - class: InlineJavascriptRequirement
doc: |
  determine if purecn done gdcfiltration

inputs:
  archive_tar_file:
    type:
      type: array
      items: ['null', File]

  dnacopy_seg_file:
    type:
      type: array
      items: ['null', File]

  filtration_metric_file:
    type:
      type: array
      items: ['null', File]

  normaldb_vcf_file:
    type:
      type: array
      items: ['null', File]

  no_normaldb_vcf_file:
    type:
      type: array
      items: ['null', File]

outputs:
  dnacopy_seg: File
  filtration_metric: File
  tar: File
  vcf: File

expression: |
   ${
      if (inputs.normaldb_vcf_file.length == 1 && inputs.no_normaldb_vcf_file.length == 0) {
        var output_vcf = inputs.normaldb_vcf_file[0];
        var filtration_metric = inputs.filtration_metric_file[0];
        var dnacopy_seg = inputs.dnacopy_seg_file[0];
        var archive_tar = inputs.archive_tar_file[0];
      } else if (inputs.normaldb_vcf_file.length == 0 && inputs.no_normaldb_vcf_file.length == 1) {
        var output_vcf = inputs.no_normaldb_vcf_file[0];
        var filtration_metric = null;
        var dnacopy_seg = null;
        var archive_tar = null;
      }
      else {
        throw "The case is unhandled";
      }
      return {'vcf': output_vcf,
              'filtration_metric': filtration_metric,
              'dnacopy_seg': dnacopy_seg,
              'tar': archive_tar};
    }
