# Blockchain Module

This module includes provisions an EC2 with a blockchain server installed, including the following:

- [Terraform Security Group Module](https://github.com/terraform-aws-modules/terraform-aws-security-group)
- [Terraform EC2 Module](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance)
- [AWS EBS Volume](https://www.terraform.io/docs/providers/aws/r/ebs_volume.html)
- [Template File](https://www.terraform.io/docs/providers/template/d/file.html)

## Requirements
- [Terraform v0.11.10](https://www.terraform.io/downloads.html)

## Usage
```hcl
module "bitcoin_node" {
  source = "git::https://github.com/NFhbar/aws-blockchain-module"

  instance_count  = "${var.instance_count}"
  name            = "${var.name}-${var.environment}"
  ami             = "${var.ami}"
  instance_type   = "${var.instance_type}"
  vpc_id          = "${var.vpc.vpc_id}"
  cidr_blocks     = "${var.vpc.vpc_cidr_block}"
  subnet          = "${var.vpc.public_subnets[0]}"
  blockchain      = "${var.blockchain}"
  blockchain_port = "${var.blockchain_port}"
  testnet         = "${var.testnet}"
  size            = "${var.size}"
  ssh             = "${var.ssh}"
  sshkey          = "${var.ssh_key}"
  user            = "${var.user}"
  pass            = "${var.pass}"
}
```

## Blockchain Specific Template File
This module installs a specific blockchain using the templates files in [templates](./templates). Currently only `bitcoin` is supported.

## Example
See an example usage in [examples](./examples).

## Tests
Tests are run using [Terratest](https://github.com/gruntwork-io/terratest).

To run the test suite:
```
$ dep init
$ dep ensure -vendor-only
$ cd test/ && go test -v
```
