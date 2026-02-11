# 01-first-come example
The tiny example of the long jouney.

## Versions used in the course
```sh
- Terraform    - "1.6.1"
- AWS provider - ">= 5.0"
```

## Commands used in the Course

### initialize
```sh
terraform init
```    

### preview terraform actions
```sh
terraform plan
```

### apply configuration with variables
```sh
terraform apply
```

### destroy everything from .tf files
```sh
terraform destroy
```

### show resources and components from current state
```sh
terraform state list
```

### show current state of a specific resource/data
```sh
terraform state show aws_vpc.myapp-vpc    
```

### set avail_zone as custom .tf environment variable - before apply
```sh
export TF_VAR_avail_zone="us-east-1a"
```
