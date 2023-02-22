class: CommandLineTool
cwlVersion: v1.0
id: purecn_normaldb
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/purecn_docker:f0456fe84f64b058373ea386d6e860704ce88c4e
  - class: InitialWorkDirRequirement
    listing: |
      ${
        var inputlist = [];
        for (var i=0; i<inputs.inputcoveragefiles.length; i++) {
           var newentry = {"entry": inputs.inputcoveragefiles[i],
                           "entryname": inputs.inputcoveragefiles[i].basename,
                           "writeable": false};
           inputlist.push(newentry);
        }
        return inputlist;
      }
  - class: InlineJavascriptRequirement
doc: |
  purecn normalDB

inputs:
  inputcoveragefiles:
    type:
      type: array
      items: File

  coveragefiles:
    type: File
    inputBinding:
      prefix: --coveragefiles

  force:
    type: boolean
    default: true
    inputBinding:
      prefix: --force

  genome:
    type: string
    default: hg38
    inputBinding:
      prefix: --genome

  outdir:
    type: string
    default: .
    inputBinding:
      prefix: --outdir

outputs:
  bed:
    type: File?
    outputBinding:
      glob: "low_coverage_targets_*.bed"

  png:
    type: File
    outputBinding:
      glob: "interval_weights_*.png"

  rds:
    type: File
    outputBinding:
      glob: "normalDB_*.rds"

  txt:
    type: File
    outputBinding:
      glob: "interval_weights_*.txt"

baseCommand: [Rscript, /usr/local/lib/R/site-library/PureCN/extdata/NormalDB.R]
