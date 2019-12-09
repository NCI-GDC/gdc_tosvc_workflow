class: CommandLineTool
cwlVersion: v1.0
id: gem indexer
requirements:
  - class: DockerRequirement
    dockerPull: namsyvo/gem-indexer:latest
  - class: InlineJavascriptRequirement
doc: |
  index gem file

inputs:
  - id: thread_num
    type: int
    default: 40
    inputBinding:
      position: 1
      prefix: -T
  - id: content?
    type: string
    default: dna
    inputBinding:
      position: 2
      prefix: -c
  - id: reffile
    type: File
    inputBinding:
      position: 3
      prefix: -i
  - id: outfile?
    type: string
    inputBinding:
      position: 4
      prefix: -o

outputs:
  - id: gem_index
    type: File
    outputBinding:
      glob: $(inputs.outfile + ".gem")
  - id: gem_index_log
    type: File
    outputBinding:
      glob: $(inputs.outfile + ".log")