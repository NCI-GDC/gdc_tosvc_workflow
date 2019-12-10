class: ExpressionTool
cwlVersion: v1.0
id: determine_baitsfile
requirements:
  - class: InlineJavascriptRequirement
doc: |
  determine which baitsfile to use

inputs:
  origin: File
  modified: File[]?

outputs:
  baits_bed:
    type: File

expression: |
   ${
     if (inputs.modified.length == 1 && inputs.modified[0] != null){
       var bed = inputs.modified[0]
     } else {
       var bed = inputs.origin
     }
      return {'baits_bed': bed}
    }
