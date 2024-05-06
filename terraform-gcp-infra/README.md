## Terraform

### Steps to run terraform files

- Update values in _.tfvars_

1. `terraform validate`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`
5. `terraform destroy`

## Provider : Google Cloud Platform
### Useful Commands

- `gcloud auth login`
- `gcloud init` : Create new project. Note: Start billing on new project
- `gcloud config set compute/region us-east1`
- `gcloud config get-value compute/zone`
- `gcloud config list`
- `gcloud compute networks subnets describe webapp`

### Steps to initiate instance via Machine Image

1. Presently, get the image id manually from google cloud console
2. In .tfvars, provide the value to `image_name`

