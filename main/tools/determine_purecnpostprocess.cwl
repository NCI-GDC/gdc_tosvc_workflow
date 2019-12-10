class: ExpressionTool
cwlVersion: v1.0
id: determine_purecnpostprocess
requirements:
  - class: InlineJavascriptRequirement
doc: |
  determine if purecnpostprocess

inputs:
  - id: input
    type: [File, "null"]

outputs:
  - id: success
    type:
      type: array
      items: int
  - id: fail
    type:
      type: array
      items: int

expression: |
   ${
      if (inputs.input != null) {
        var success_array = [1];
        var fail_array = [];
      } else {
        var success_array = [];
        var fail_array = [1];
      }
      return {'success_purecn': success_array,
              'fail_purecn': fail_array};
    }
