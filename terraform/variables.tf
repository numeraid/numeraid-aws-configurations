/*

Guidelines for variable naming

- Add units to the names of inputs, local variables, and outputs that represent numeric values such as disk size or RAM size (for example, ram_size_gb for RAM size in gigabytes). This practice makes the expected input unit clear for configuration maintainers.
- Use binary units such as MiB and GiB for storage sizes, and decimal units such as MB or GB for other metrics.
- Give Boolean variables positive names such as enable_external_access.

*/

variable "aws_region" {
  description = "AWS Region where resources will be deployed"
  type = string
}