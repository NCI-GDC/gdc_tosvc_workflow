### To generate a new purecn normaldb
* https://wiki.uchicago.edu/pages/viewpage.action?spaceKey=CDIS&title=Tumor-Only+Filtering+Workflow+Manual
1. clone repo
   * `git@github.com:NCI-GDC/gdc_tosvc_workflow.git`
1. cd `gdc_tosvc_workflow/normaldb`
1. The entrypoint for normaldb generation is `etl.cwl` (extract, transform, load)
1. Example inputs are:
   * `etl.nexterarapidcaptureexomev1.2.cptac-3.hg38.yml`
   * `etl.sureselectxthumanallexonv5,16.tcga-meso.hg38.yml`
   * `etl.xgenexomeresearchpanelv1.0.organoid-pancreatic.hg38.yml`
1. input fields that must be modified for each new kit:
   *. `bam_uuids`
   *. `bam_sizes`
   *. `bam_index_uuids`
   *. `bam_index_sizes`
   *. `project_id`
   *. `target_capture_kit`
1. save, git commit and push
1. rsync repo to a VM
   * `rsync -av -progress gdc_tosvc_workflow ${VM}/mnt/scratch/`
1. run workflow
   * `cd /mnt/scratch/`
   * `mkdir run && cd run/`
   * `nohup cwltool --debug --cachedir $(pwd)/cache/ --tmpdir-prefix $(pwd)/tmp/ /mnt/scratch/gdc_tosvc_workflow/normaldb/etl.cwl /mnt/scratch/gdc_tosvc_workflow/normaldb/etl.xgenexomeresearchpanelv1.0.organoid-pancreatic.hg38.yml &`
1. output will 4 files. in the above example:
   * `interval_weights.xgenexomeresearchpanelv1.0.organoid-pancreatic.hg38.png`
   * `interval_weights.xgenexomeresearchpanelv1.0.organoid-pancreatic.hg38.txt`
   * `low_coverage_targets.xgenexomeresearchpanelv1.0.organoid-pancreatic.hg38.bed`
   * `normalDB.xgenexomeresearchpanelv1.0.organoid-pancreatic.hg38.rds`
