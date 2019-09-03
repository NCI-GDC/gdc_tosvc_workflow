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
  - id: project_id
    type: string?
  - id: caller_id
    type: string?

outputs:
  - id: output
    type: string

expression: |
  ${
     var exp = inputs.experimental_strategy.toLowerCase().replace(/[\-]/g, " ").replace(/\s+/g, '_');
     var pid = inputs.project_id ? inputs.project_id + '.': '';
     var cid = inputs.caller_id ? '.' + inputs.caller_id.replace(/[\-]/g, " ").replace(/\s+/g, '_') : '';
     var pfx = pid + inputs.job_uuid + '.' + exp + cid; 
     return {'output': pfx};
   }
