## terraform-aws-vpc

Terraform module that manages AWS VPC.

This module creates:

- VPC
- Subnets (public and private)
- Route tables
- Internet gateway
- NAT gateway (with EIP)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| default\_tags | The default tags to apply to the resoures of the VPC | map | `<map>` | no |
| enable\_dns\_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC. Defaults true. | string | `"true"` | no |
| prefix\_name | The prefix name for the resources of the VPC | string | `"my"` | no |
| private\_subnet\_count | How much private subnets to create | string | `"2"` | no |
| private\_subnet\_mask\_newbits | The number of bits of the private subnet mask to add to the ones of the VPC's subnet mask. E.g: VPC's CIDR block: 10.0.0.0/8 (8 bits subnet mask); private subnet's CIDR block: 10.0.0.0/16 (16 bits subnet mask, 8 new bits). | string | `"8"` | no |
| public\_subnet\_count | How much public subnets to create | string | `"2"` | no |
| public\_subnet\_mask\_newbits | The number of bits of the public subnet mask to add to the ones of the VPC's subnet mask. E.g: VPC's CIDR block: 10.0.0.0/8 (8 bits subnet mask); private subnet's CIDR block: 10.0.0.0/16 (16 bits subnet mask, 8 new bits). | string | `"8"` | no |
| vpc\_cidr | The CIDR block of the VPC | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| private\_subnet\_ids |  |
| public\_subnet\_ids |  |
| vpc\_id |  |

