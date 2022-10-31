# Creating an AWS IAM Role for use from a ReleaseHub Service Account

This Terraform module is provided as a reference demonstrating how to create a
role with a policy allowing it to be assumed from a ReleaseHub service account.

## Basic Usage:

You can use this module directly to create a role:

1. Edit `main.tf` to replace the sample role policy with your own.
2. Apply this module specifying the required inputs (see
   [`./inputs.tf`](./inputs.tf))
3. Copy the `role_arn` from the Terraform outputs
4. Update your Application Template to add one or more `service_accounts` (see
   [docs](https://docs.releasehub.com/reference-documentation/application-settings/application-template/schema-definition#service-accounts)),
   setting the `cloud_role` to the role ARN from the previous step.

## Advanced Usage

For more complex use cases, copy this module into your own IaC repository and
adapt it to suit your needs. See the [AWS IRSA
docs](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
for more information.


## Input Variables

* `iam_role_name` - Name of the IAM role to create and assoicate with the
  service account
* `releasehub_cluster_context` - Name of the ReleaseHub cluster
* `releasehub_service_account_names` - Name of the ReleaseHub service account
  you want to allow to assume this IAM role
