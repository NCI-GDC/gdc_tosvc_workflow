class: ExpressionTool
cwlVersion: v1.0
id: make_file_prefix
requirements:
  - class: InlineJavascriptRequirement
doc: |
  make file name prefix

inputs:
  job_uuid: string
  experimental_strategy: string
  projectid: string?
  callerid: string?
  run_with_normaldb:
    type: int[]?

outputs:
  output: string

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
