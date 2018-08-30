#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: purecn_vcf_file
    type: File?

outputs:
  - id: success_purecn
    type:
      type: array
      items: int
  - id: fail_purecn 
    type:
      type: array
      items: int

expression: |
   ${
      if (inputs.purecn_vcf_file != null) {
        var success_purecn_array = [1];
        var fail_purecn_array = [];
      } else {
        var success_purecn_array = [];
        var fail_purecn_array = [1];
      }
      return {'success_purecn': success_purecn_array, 'fail_purecn': fail_purecn_array};
    }
