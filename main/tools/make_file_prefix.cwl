class: ExpressionTool
cwlVersion: v1.0
id: make_file_prefix
requirements:
  - class: InlineJavascriptRequirement
doc: |
  make file name prefix

inputs:
  - id: job_uuid
    type: string
  - id: experimental_strategy
    type: string
  - id: projectid
    type: [string, "null"]
  - id: callerid
    type: [string, "null"]
  - id: run_with_normaldb
    type: int[]?

outputs:
  - id: output
    type: string

expression: |
  ${
     var exp = inputs.experimental_strategy.toLowerCase().replace(/[\-]/g, " ").replace(/\s+/g, '_');
     var pid = inputs.projectid ? inputs.projectid + '.': '';
     var cid = inputs.callerid ? '.' + inputs.callerid.replace(/[\-]/g, " ").replace(/\s+/g, '_') : '';
     if (Array.isArray(inputs.run_with_normaldb) && inputs.run_with_normaldb.length == 1){
       var ndb = ".with_normaldb"
     } else {
       var ndb = ".no_normaldb"
     }
     var pfx = pid + inputs.job_uuid + '.' + exp + cid + ndb;
     return {'output': pfx};
   }
