class: CommandLineTool
cwlVersion: v1.0
id: purecn_intervals
requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/purecn_docker:f0456fe84f64b058373ea386d6e860704ce88c4e
doc: |
  purecn intervals

inputs:
  fasta:
    type: File
    secondaryFiles: [.fai, ^.dict]

  genome:
    type: string
    default: hg38

  infile: File

  mappability: File

  force:
    type: boolean
    default: true

  offtarget:
    type: boolean
    default: true

  mintargetwidth: int?

outputs:
  interval:
    type: File
    outputBinding:
      glob: $(inputs.fasta.nameroot).$(inputs.infile.nameroot.split('.')[0]).$(inputs.genome).txt

  bed:
    type: File
    outputBinding:
      glob: $(inputs.fasta.nameroot).$(inputs.infile.nameroot.split('.')[0]).$(inputs.genome).bed

baseCommand: []
arguments:
  - position: 0
    shellQuote: false
    valueFrom: |-
      ${
        var cmd = [
          "Rscript",
          "/usr/local/lib/R/site-library/PureCN/extdata/IntervalFile.R",
          "--fasta",
          inputs.fasta.path,
          "--genome",
          inputs.genome,
          "--infile",
          inputs.infile.path,
          "--mappability",
          inputs.mappability.path,
          "--outfile",
          inputs.fasta.nameroot + "." + inputs.infile.nameroot.split('.')[0] + "." + inputs.genome + ".txt",
          "--export",
          inputs.fasta.nameroot + "." + inputs.infile.nameroot.split('.')[0] + "." + inputs.genome + ".bed"
        ]
        if ( inputs.force ) {
          cmd.push("--force")
        }
        if ( inputs.offtarget ) {
          cmd.push("--offtarget")
        }
        if ( inputs.mintargetwidth ) {
          cmd.push("--mintargetwidth")
          cmd.push(inputs.mintargetwidth)
        }
        return(cmd.join(' '))
      }

