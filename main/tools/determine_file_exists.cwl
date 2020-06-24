class: ExpressionTool
cwlVersion: v1.0
id: determine_file_exists
requirements:
  - class: InlineJavascriptRequirement
doc: |
  determine if file exists

inputs:
  purecn_vcf_file: File?

outputs:
  success_purecn:
    type:
      type: array
      items: int
  fail_purecn:
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
      return {'success_purecn': success_purecn_array,
              'fail_purecn': fail_purecn_array};
    }
