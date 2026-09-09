/*

Although shared modules inherit providers from calling modules, modules should not configure provider settings themselves. 
Avoid specifying provider configuration blocks in modules. 
This configuration should only be declared once globally.

*/

provider "aws" {
  region = var.aws_region
}