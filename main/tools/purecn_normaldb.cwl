class: CommandLineTool
cwlVersion: v1.0
id: purecn_normaldb

requirements:
  DockerRequirement:
    dockerPull: docker.osdc.io/ncigdc/purecn_docker:f0456fe84f64b058373ea386d6e860704ce88c4e
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}

doc: |
  purecn normalDB

inputs:
  inputcoveragefiles:
    type:
      type: array
      items: File

  assay:
    type: string
    default: 'agilent_v6'
    inputBinding:
      prefix: --assay
      shellQuote: false

  genome:
    type: string
    default: hg38
    inputBinding:
      prefix: --genome
      shellQuote: false

  outdir:
    type: string
    default: normaldb
    inputBinding:
      prefix: --out-dir
      shellQuote: false

outputs:
  normaldb:
    type: Directory
    outputBinding:
      glob: normaldb

baseCommand: []
arguments:
  - position: 0
    shellQuote: false
    valueFrom: >-
      ${
        var paths = [];
        for (var i = 0; i < inputs.inputcoveragefiles.length; i++) {
            paths.push(inputs.inputcoveragefiles[i].path);
        }
        var list_content = paths.join("\n");
        var list_file = "generated_list.txt";
        var cmd = "echo '" + list_content + "' > " + list_file + "; ";
        cmd += "mkdir normaldb;"
        cmd += "Rscript /usr/local/lib/R/site-library/PureCN/extdata/NormalDB.R --coverage-files " + list_file + " --out-dir normaldb";
        return cmd;
      }
