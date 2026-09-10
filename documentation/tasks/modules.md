# Terraform modules

## Configuration language

### Root module and child modules

A Terraform workspace can contain configuration files in its root directory. Those files are called the root module. When you use a `module` block, you are creating a child module that is referenced from the root module.

This project uses the root module in the `terraform/` directory and splits the infrastructure into reusable child modules under `terraform/modules/`.

```text
Numeraid infrastructure
├── Root module
│   ├── main.tf
│   ├── variables.tf
│   ├── locals.tf
│   ├── providers.tf
│   ├── versions.tf
│   └── outputs.tf
│
└── Child modules
    ├── networking
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── versions.tf
    │
    └── security
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── versions.tf
    
```

### Why this structure is useful

- The root module controls the overall project configuration.
- Each child module handles a specific part of the AWS stack.
- Inputs and outputs pass values between modules, which keeps responsibilities separated and easier to manage.
- The `networking` module creates the VPC, subnets, gateways, and routing.
