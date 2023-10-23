# Terraform GoDaddy DNS A Module

This module allows you to set DNS A records for specified subdomains on GoDaddy, using the provided public IP address or by fetching the current public IP address if none is provided.

## Requirements

- Terraform v0.13+
- GoDaddy API key and secret

## Usage

To use this module, add the following code to your Terraform configuration:

```hcl
module "godaddy_dns" {
  source         = "git@github.com:bartaadalbert/tf-godaddy-A-module"
  gdd_access_key = "<Your GoDaddy Access Key>"
  gdd_secret_key = "<Your GoDaddy Secret Key>"
  domain         = "example.com"
  subdomain_list = ["sub1", "sub2"]
  public_ip      = "" # Leave empty to auto-fetch current public IP
}
```

## Inputs

| Name            | Description                                                              | Type           | Default       | Required |
|-----------------|--------------------------------------------------------------------------|----------------|---------------|----------|
| `gdd_access_key` | The access key for GoDaddy.                                             | `string`       | n/a           | yes      |
| `gdd_secret_key` | The secret key for GoDaddy.                                             | `string`       | n/a           | yes      |
| `domain`        | The main domain for which the subdomain records will be set.             | `string`       | `"nunapo.com"`| no       |
| `subdomain_list`| List of subdomains to set the IP for.                                    | `list(string)` | `["argo", "flux"]` | no |
| `public_ip`     | Public IP address to set for the subdomains. Auto-fetched if not provided.| `string`       | `""`          | no       |

## Outputs

| Name        | Description                              |
|-------------|------------------------------------------|
| `public_ip` | The current public IP address being used.|

## Notes

- If you don't provide a `public_ip`, the module will automatically fetch the current public IP address.
- The module will set the DNS A record for each subdomain specified in the `subdomain_list` to the provided `public_ip` or the fetched public IP if none is provided.
- On destroying the Terraform resources, the DNS A records for the specified subdomains will be deleted.


## Contributing

If you encounter issues or have suggestions for improvements, please open an issue or submit a pull request. Your contributions are welcome!

Modify this draft to align with your project's specific details and requirements, and make sure to update the source URL to match your actual Terraform module's repository location.