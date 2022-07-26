# Terraform k3s

# Prerequsities

- docker installed and running
- k3d installed
- terraform installed

# Run

```sh

$ cd 01-create-k3s
$ terraform init
$ terraform apply # if you want to use your own demo name do `terraform apply -var"demo_name=<your-demo-name>"
```

```sh
$ cd 02-deploy-app
$ terraform init
$ terraform apply # if you want to use your own demo name do `terraform apply -var"demo_name=<your-demo-name>"
```

Open Browser on `localhost:8080`
