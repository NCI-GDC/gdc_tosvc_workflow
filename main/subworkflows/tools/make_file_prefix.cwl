#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: job_uuid
    type: string
  - id: experimental_strategy
    type: string
  - id: projectid
    type: [string, "null"]
  - id: callerid
    type: [string, "null"]

outputs:
  - id: output
    type: string

expression: |
  ${
     var exp = inputs.experimental_strategy.toLowerCase().replace(/[\-]/g, " ").replace(/\s+/g, '_');
     var pid = inputs.projectid ? inputs.projectid + '.': '';
     var cid = inputs.callerid ? '.' + inputs.callerid.replace(/[\-]/g, " ").replace(/\s+/g, '_') : '';
     var pfx = pid + inputs.job_uuid + '.' + exp + cid; 
     return {'output': pfx};
   }
