# Sample code for Terraform driving APIC

## Usage:

```bash
# create your own 01-workload.auto.tfvars
$ cp 01-workload.auto.tfvars-sample 01-workload.auto.tfvars

# and fill it with vSphere credentials
$ vi 01-workload.auto.tfvars
 
# run terrform plan to check if everything is alright
$ terraform plan

# then apply
$ terraform apply
```
