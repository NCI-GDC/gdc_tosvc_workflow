cwlVersion: v1.0
class: ExpressionTool
requirements:
  InlineJavascriptRequirement: {}
doc: Extract file matching pattern '*rds' from a given directory

inputs:
  dir:
    type: Directory
    inputBinding:
      position: 1

outputs:
  rds_file:
    type: File

expression: |
  ${
    // Go through listing and find the file ending with .rds
    var rdsFiles = inputs.dir.listing.filter(function(entry) {
      return entry.basename.endsWith('.rds');
    });

    // Return the first file found or null
    return {
      "rds_file": rdsFiles.length > 0 ? rdsFiles[0] : null
    };
  }
