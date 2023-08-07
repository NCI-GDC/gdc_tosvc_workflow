class: ExpressionTool
cwlVersion: v1.0
id: determine_coverage_file
requirements:
  - class: InlineJavascriptRequirement
doc: |
  determine which coverage file to pick

inputs:
  coverage_loess: File?
  coverage: File

outputs:
  purecn_coverage: File

expression: |
   ${
      if (inputs.coverage_loess != null) {
        var purecn_coverage = inputs.coverage_loess
      } else {
        var purecn_coverage = inputs.coverage
      }
      return {'purecn_coverage': purecn_coverage};
    }
