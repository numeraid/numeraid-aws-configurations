
# Best practices for code base structure and organization

<a name="structure"></a>

Proper code base structure and organization is critical as Terraform usage grows across large teams and enterprises. A well-architected code base enables collaboration at scale while enhancing maintainability. This section provides recommendations on Terraform modularity, naming conventions, documentation, and coding standards that support quality and consistency.

Guidance includes breaking configuration into reusable modules by environment and components, establishing naming conventions by using prefixes and suffixes, documenting modules and clearly explaining inputs and outputs, and applying consistent formatting rules by using automated style checks.

Additional best practices cover logically organizing modules and resources in a structured hierarchy, cataloging public and private modules in documentation, and abstracting unnecessary implementation details in modules to simplify usage.

By implementing code base structure guidelines around modularity, documentation, standards, and logical organization, you can support broad collaboration across teams while keeping Terraform maintainable as usage spreads across an organization. By enforcing conventions and standards, you can avoid the complexity of a fragmented code base.

## Implement a standard repository structure

<a name="repo-structure"></a>

We recommend that you implement the following repository layout. Standardizing on these consistency practices across modules improves discoverability, transparency, organization, and reliability while enabling reuse across many Terraform configurations.

+ **Root module or directory**: This should be the primary entry point for both Terraform [root](https://developer.hashicorp.com/terraform/language/files#the-root-module) and [re-usable](https://developer.hashicorp.com/terraform/language/modules/develop) modules and is expected to be unique. If you have a more complex architecture, you can use nested modules to create lightweight abstractions. This helps you describe infrastructure in terms of its architecture instead of directly, in terms of physical objects.
+ **README**: The root module and any nested modules should have README files. This file must be named `README.md`. It should contain a description of the module and what it should be used for. If you want to include an example of using this module with other resources, put it in an `examples` directory. Consider including a diagram that depicts the infrastructure resources the module might create and their relationships. Use [terraform-docs](https://github.com/terraform-docs/terraform-docs) to automatically generate inputs or outputs of the module.
+ **main.tf**: This is the primary entry point. For a simple module, all resources might be created in this file. For a complex module, resource creation might be spread across multiple files, but any nested module calls should be in the `main.tf` file.
+ **variables.tf** and **outputs.tf**: These files contain the declarations for variables and outputs. All variables and outputs should have one-sentence or two-sentence descriptions that explain their purpose. These descriptions are used for documentation. For more information, see the HashiCorp documentation for [variable configuration](https://developer.hashicorp.com/terraform/language/values/variables) and [output configuration](https://developer.hashicorp.com/terraform/language/values/outputs).
  + All variables must have a defined type.
  + The variable declaration can also include a default argument. If the declaration includes a default argument, the variable is considered to be optional, and the default value is used if you don't set a value when you call the module or run Terraform. The default argument requires a literal value and cannot reference other objects in the configuration. To make a variable required, omit a default in the variable declaration and consider whether setting `nullable = false` makes sense.
  + For variables that have environment-independent values (such as `disk_size`), provide default values.
  + For variables that have environment-specific values (such as `project_id`), don't provide default values. In this case, the calling module must provide meaningful values.
  + Use empty defaults for variables such as empty strings or lists only when leaving the variable empty is a valid preference that the underlying APIs don't reject.
  + Be judicious in your use of variables. Parameterize values that only if they must vary for each instance or environment. When you decide whether to expose a variable, ensure that you have a concrete use case for changing that variable. If there's only a small chance that a variable might be needed, don't expose it.
    + Adding a variable with a default value is backward compatible.
    + Removing a variable is backward incompatible.
    + In cases where a literal is reused in multiple places, you should use a local value without exposing it as a variable.
  + Don't pass outputs directly through input variables, because doing so prevents them from being properly added to the dependency graph. To ensure that [implicit dependencies](https://learn.hashicorp.com/terraform/getting-started/dependencies.html) are created, make sure that outputs reference attributes from resources. Instead of referencing an input variable for an instance directly, pass the attribute.
+ **locals.tf**: This file contains local values that assign a name to an expression, so a name can be used multiple times within a module instead of repeating the expression. Local values are like a function's temporary local variables. The expressions in local values aren't limited to literal constants; they can also reference other values in the module, including variables, resource attributes, or other local values, in order to combine them.
+ **providers.tf**: This file contains the [terraform block](https://developer.hashicorp.com/terraform/language/block/terraform) and [provider blocks](https://developer.hashicorp.com/terraform/language/providers/configuration#provider-configuration-1). `provider` blocks must be declared only in root modules by consumers of modules.

  If you're using HCP Terraform, also add an empty [cloud block](https://developer.hashicorp.com/terraform/cli/cloud/settings#the-cloud-block). The `cloud` block should be configured entirely through [environment variables](https://developer.hashicorp.com/terraform/cli/cloud/settings#environment-variables) and [environment variable credentials](https://developer.hashicorp.com/terraform/cli/config/config-file#environment-variable-credentials) as part of a CI/CD pipeline.
+ **versions.tf**: This file contains the [required\_providers](https://developer.hashicorp.com/terraform/language/providers/requirements#requiring-providers) block. All Terraform modules must declare which providers it requires so that Terraform can install and use these providers.
+ **data.tf**: For simple configuration, put [data sources](https://developer.hashicorp.com/terraform/language/data-sources) next to the resources that reference them. For example, if you are fetching an image to be used in launching an instance, place it alongside the instance instead of collecting data resources in their own file. If the number of data sources becomes too large, consider moving them to a dedicated `data.tf` file.
+ **.tfvars files**: For root modules, you can provide non-sensitive variables by using a `.tfvars` file. For consistency, name the variable files `terraform.tfvars`. Place common values at the root of the repository, and environment-specific values within the `envs/` folder.
+ **Nested modules**: Nested modules should exist under the `modules/` subdirectory. Any nested module that has a `README.md` is considered usable by an external user. If a `README.md` doesn't exist, the module is considered for internal use only. Nested modules should be used to split complex behavior into multiple small modules that users can carefully pick and choose.

  If the root module includes calls to nested modules, these calls should use relative paths such as `./modules/sample-module` so that Terraform will consider them to be part of the same repository or package instead of downloading them again separately.

  If a repository or package contains multiple nested modules, they should ideally be composable by the caller instead of directly calling each other and creating a deeply nested tree of modules.
+ **Examples**: Examples of using a reusable module should exist under the `examples/` subdirectory at the root of the repository. For each example, you can add a README to explain the goal and usage of the example. Examples for submodules should also be placed in the root `examples/` directory.

  Because examples are often copied into other repositories for customization, module blocks should have their source set to the address an external caller would use, not to a relative path.
+ **Service named files**: Users often want to separate Terraform resources by service in multiple files. This practice should be discouraged as much as possible, and resources should be defined in `main.tf` instead. However, if a collection of resources (for example, IAM roles and policies) exceeds 150 lines, it's reasonable to break it into its own files, such as `iam.tf`. Otherwise, all resource code should be defined in the `main.tf`.
+ **Custom scripts**: Use scripts only when necessary. Terraform doesn't account for, or manage, the state of resources that are created through scripts. Use custom scripts only when Terraform resources don't support the desired behavior. Place custom scripts called by Terraform in a `scripts/` directory.
+ **Helper scripts**: Organize helper scripts that aren't called by Terraform in a `helpers/` directory. Document helper scripts in the `README.md` file with explanations and example invocations. If helper scripts accept arguments, provide argument checking and `--help` output.
+ **Static files**: Static files that Terraform references but doesn't run (such as startup scripts loaded onto EC2 instances) must be organized into a `files/` directory. Place lengthy documents in external files, separate from their HCL. Reference them with the [file() function](https://www.terraform.io/language/functions/file).
+ **Templates**: For files that the Terraform [templatefile function](https://www.terraform.io/docs/configuration/functions/templatefile.html) reads in, use the file extension `.tftpl`. Templates must be placed in a `templates/` directory.

### Root module structure

<a name="root-module-structure.0245b1cf-6aa3-5611-b232-154ec29b0328"></a>

Terraform always runs in the context of a single root module*.* A complete Terraform configuration consists of a root module and the tree of child modules (which includes the modules that are called by the root module, any modules called by those modules, and so on).

Terraform root module layout basic example:

```
.
├── data.tf
├── envs
│   ├── dev
│   │   └── terraform.tfvars
│   ├── prod
│   │   └── terraform.tfvars
│   └── test
│       └── terraform.tfvars
├── locals.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── README.md
├── terraform.tfvars
├── variables.tf
└── versions.tf
```

### Reusable module structure

<a name="reusable-module-structure.be28599e-a76f-59ff-a2c1-9f623d5fc391"></a>

Reusable modules follow the same concepts as root modules. To define a module, create a new directory for it and place the `.tf` files inside, just as you would define a root module. Terraform can load modules either from local relative paths or from remote repositories. If you expect a module to be reused by many configurations, place it in its own version control repository. It's important to keep the module tree relatively flat to make it easier to reuse the modules in different combinations.

Terraform reusable module layout basic example:

```
.
├── data.tf
├── examples
│   ├── multi-az-new-vpc
│   │   ├── data.tf
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── README.md
│   │   ├── terraform.tfvars
│   │   ├── variables.tf
│   │   ├── versions.tf
│   │   └── vpc.tf
│   └── single-az-existing-vpc
│   │   ├── data.tf
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── README.md
│   │   ├── terraform.tfvars
│   │   ├── variables.tf
│   │   └── versions.tf
├── iam.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── README.md
├── variables.tf
└── versions.tf
```

## Structure for modularity

<a name="modularity"></a>

In principle, you can combine any resources and other constructs into a module, but overusing nested and reusable modules can make your overall Terraform configuration harder to understand and maintain, so use these modules in moderation.

When it makes sense, break your configuration into reusable modules that raise the level of abstraction by describing a new concept in your architecture that is constructed from resource types.

When you modularize your infrastructure into reusable definitions, aim for logical sets of resources instead of individual components or overly complex collections.

### Don't wrap single resources

<a name="don9999999999999999apos-t-wrap-single-resources.fe03df4e-5912-5ce0-b543-7de0ea1ee4a1"></a>

You shouldn't create modules that are thin wrappers around other single resource types. If you have trouble finding a name for your module that's different from the name of the main resource type inside it, your module probably isn't creating a new abstraction―it's adding unnecessary complexity. Instead, use the resource type directly in the calling module.

### Encapsulate logical relationships

<a name="encapsulate-logical-relationships.3f6fb397-42a0-5a1d-983e-fac4bb74cb35"></a>

Group sets of related resources such as networking foundations, data tiers, security controls, and applications. A reusable module should encapsulate infrastructure pieces that work together to enable a capability.

### Keep inheritance flat

<a name="keep-inheritance-flat.5e0e59bc-ca98-5c46-bf0c-f19a7cdf704a"></a>

When you nest modules in subdirectories, avoid going more than one or two levels deep. Deeply nested inheritance structures complicate configurations and troubleshooting. Modules should build on other modules―not build tunnels through them.

By focusing modules on logical resource groupings that represent architecture patterns, teams can quickly configure reliable infrastructure foundations. Balance abstraction without over-engineering or over-simplification.

### Reference resources in outputs

<a name="reference-resources-in-outputs.9b8f281a-d39c-5e2f-98a5-c5048f3f401e"></a>

For every resource that's defined in a reusable module, include at least one output that references the resource. Variables and outputs let you infer dependencies between modules and resources. Without any outputs, users cannot properly order your module in relation to their Terraform configurations.

Well-structured modules that provide environment consistency, purpose-driven groupings, and exported resource references enable organization-wide Terraform collaboration at scale. Teams can assemble infrastructure from reusable building blocks.

### Don't configure providers

<a name="don9999999999999999apos-t-configure-providers.96a7e473-9959-5a1e-8f8a-5c0cebb555dd"></a>

Although shared modules inherit providers from calling modules, modules should not configure provider settings themselves. Avoid specifying provider configuration blocks in modules. This configuration should only be declared once globally.

### Declare required providers

<a name="declare-required-providers.359e768b-44ee-59db-8195-f07c9bf54a33"></a>

Although provider configurations are shared between modules, shared modules must also declare their own [provider requirements](https://developer.hashicorp.com/terraform/language/providers/requirements). This practice enables Terraform to ensure that there is a single version of the provider that's compatible with all modules in the configuration, and to specify the source address that serves as the global (module-agnostic) identifier for the provider. However, module-specific provider requirements don't specify any of the configuration settings that determine what remote endpoints the provider will access, such as an AWS Region.

By declaring version requirements and avoiding hardcoded provider configuration, modules provide portability and reusability across Terraform configurations using shared providers.

For shared modules, define the minimum required provider versions in a [required\_providers block](https://developer.hashicorp.com/terraform/language/modules/develop/providers#provider-version-constraints-in-modules) in `versions.tf`.

To declare that a module requires a particular version of the AWS provider, use a `required_providers` block inside a `terraform` block:

```
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}
```

If a shared module supports only a specific version of the AWS provider, use the *pessimistic constraint operator* (`~>` ), which allows only the rightmost version component to increment:

```
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
```

In this example, `~> 4.0` allows the installation of `4.57.1` and `4.67.0` but not `5.0.0`. For more information, see [Version Constraint Syntax](https://developer.hashicorp.com/terraform/language/expressions/version-constraints#version-constraint-syntax) in the HashiCorp documentation.

## Follow naming conventions

<a name="naming-conventions"></a>

Clear, descriptive names simplify your understanding of relationships between resources in the module and the purpose of configuration values. Consistency with style guidelines enhances readability for both module users and maintainers.

### Follow guidelines for resource naming

<a name="follow-guidelines-for-resource-naming.42d68b47-41c2-5944-b695-f38bfdd4e05f"></a>

+ Use *snake\_case* (where lowercase terms are separated by underscores) for all resource names to match Terraform style standards. This practice ensures consistency with the naming convention for resource types, data source types, and other predefined values. This convention doesn't apply to name [name arguments](https://www.terraform.io/docs/glossary#argument).
+ To simplify references to a resource that is the only one of its type (for example, a single load balancer for an entire module), name the resource `main` or `this` for clarity.
+ Use meaningful names that describe the purpose and context of the resource, and that help differentiate between similar resources (for example, `primary` for the main database and `read_replica` for a read replica of the database).
+ Use singular, not plural names.
+ Don't repeat the resource type in the resource name.

### Follow guidelines for variable naming

<a name="follow-guidelines-for-variable-naming.49afde7f-d58c-58cb-8704-9e73ae66c64c"></a>

+ Add units to the names of inputs, local variables, and outputs that represent numeric values such as disk size or RAM size (for example, `ram_size_gb` for RAM size in gigabytes). This practice makes the expected input unit clear for configuration maintainers.
+ Use binary units such as MiB and GiB for storage sizes, and decimal units such as MB or GB for other metrics.
+ Give Boolean variables positive names such as `enable_external_access`.

## Use attachment resources

<a name="attachment-resources"></a>

Some resources have pseudo-resources embedded as attributes in them. Where possible, you should avoid using these embedded resource attributes and use the unique resource to attach that pseudo-resource instead. These resource relationships can cause cause-and-effect issues that are unique for each resource.

Using an embedded attribute (avoid this pattern):

```
resource "aws_security_group" "allow_tls" {
  ...
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
```

Using attachment resources (preferred):

```
resource "aws_security_group" "allow_tls" {
  ...
}

resource "aws_security_group_rule" "example" {
  type              = "ingress"
  description      = "TLS from VPC"
  from_port        = 443
  to_port          = 443
  protocol         = "tcp"
  cidr_blocks      = [aws_vpc.main.cidr_block]
  ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  security_group_id = aws_security_group.allow_tls.id
}
```

## Use default tags

<a name="default-tags"></a>

Assign tags to all resources that can accept tags. The Terraform AWS Provider has an [aws\_default\_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) data source that you should use inside the root module.

Consider adding necessary tags to all resources that are created by a Terraform module. Here's a list of possible tags to attach:

+ **Name**: Human-readable resource name
+ **AppId**: The ID for the application that uses the resource
+ **AppRole**: The resource's technical function; for example, "webserver" or "database"
+ **AppPurpose**: The resource's business purpose; for example, "frontend ui" or "payment processor"
+ **Environment**: The software environment, such as dev, test, or prod
+ **Project**: The projects that use the resource
+ **CostCenter**: Who to bill for resource usage

## Meet Terraform registry requirements

<a name="registry-reqs"></a>

A module repository must meet all of the following requirements so it can be published to a Terraform registry.

You should always follow these requirements even if you aren't planning to publish the module to a registry in the short term. By doing so, you can publish the module to a registry later without having to change the configuration and structure of the repository.

+ Repository name: For a module repository, use the three-part name `terraform-aws-<NAME>`, where `<NAME>` reflects the type of infrastructure the module manages. The `<NAME>` segment can contain additional hyphens (for example, `terraform-aws-iam-terraform-roles`).
+ Standard module structure: The module must adhere to the standard repository structure. This allows the registry to inspect your module and generate documentation, track resource usage, and more.
  + After you create the Git repository, copy the module files to the root of the repository. We recommend that you place each module that is intended to be reusable in the root of its own repository, but you can also reference modules from subdirectories.
  + If you're using HCP Terraform, publish the modules that are intended to be shared to your organization registry. The registry handles downloads and controls access with HCP Terraform API tokens, so consumers do not need access to the module's source repository even when they run Terraform from the command line.
+ Location and permissions: The repository must be in one of your configured [version control system (VCS) providers](https://developer.hashicorp.com/terraform/cloud-docs/vcs), and the HCP Terraform VCS user account must have administrator access to the repository. The registry needs administrator access to create the webhooks to import new module versions.
+ x.y.z tags for releases: At least one release tag must be present for you to publish a module. The registry uses release tags to identify module versions. Release tag names must use [semantic versioning](https://semver.org/), which you can optionally prefix with a `v` (for example,, `v1.1.0` and `1.1.0`). The registry ignores tags that do not look like version numbers. For more information about publishing modules, see the [Terraform documentation](https://developer.hashicorp.com/terraform/cloud-docs/registry/publish-modules#publishing-a-new-module).

For more information, see [Preparing a Module Repository](https://developer.hashicorp.com/terraform/cloud-docs/registry/publish-modules#preparing-a-module-repository) in the Terraform documentation.

## Use recommended module sources

<a name="module-sources"></a>

Terraform uses the `source` argument in a module block to find and download the source code for a child module.

We recommend that you use local paths for closely related modules that have the primary purpose of factoring out repeated code elements, and using a native Terraform module registry or a VCS provider for modules that are intended to be shared by multiple configurations.

The following examples illustrate the most common and recommended [source types](https://developer.hashicorp.com/terraform/language/modules/sources) for sharing modules. Registry modules support [versioning](https://developer.hashicorp.com/terraform/language/modules/syntax#version). You should always provide a specific version, as shown in the following examples.

### Registry

<a name="registry.48717537-354d-5d4f-8914-7ed346ec3cd8"></a>

#### Terraform registry

<a name="terraform-registry-.dac9b36d-1bdc-5ca9-b2a9-5a3cdb75262b"></a>

```
module "lambda" {
  source = "github.com/terraform-aws-modules/terraform-aws-lambda.git?ref=e78cdf1f82944897ca6e30d6489f43cf24539374" #--> v4.18.0

  ...

}
```

By pinning commit hashes, you can avoid drift from public registries that are vulnerable to supply chain attacks.

#### HCP Terraform

<a name="hcp-terraform-.0a5ac85d-5b0d-5673-b505-dd666ff3b1ea"></a>

```
module "eks_karpenter" {
  source = "app.terraform.io/my-org/eks/aws"
  version = "1.1.0"

  ...

  enable_karpenter = true
}
```

#### Terraform Enterprise

<a name="terraform-enterprise-.092223c3-d1f8-5e33-9eb6-fd60a71e775a"></a>

```
module "eks_karpenter" {
  source = "terraform.mydomain.com/my-org/eks/aws"
  version = "1.1.0"

  ...

  enable_karpenter = true
}
```

### VCS providers

<a name="vcs-providers.406088a6-91e6-573f-9e3a-73e726f15524"></a>

VCS providers support the `ref` argument for selecting a specific revision, as shown in the following examples.

#### GitHub (HTTPS)

<a name="github--https--.a66bbc62-c2cf-5c7c-9ae3-182a099d2390"></a>

```
module "eks_karpenter" {
  source = "github.com/my-org/terraform-aws-eks.git?ref=v1.1.0"

  ...

  enable_karpenter = true
}
```

#### Generic Git repository (HTTPS)

<a name="generic-git-repository--https--.8930108a-8b87-5662-8718-ab363a28913c"></a>

```
module "eks_karpenter" {
  source = "git::https://example.com/terraform-aws-eks.git?ref=v1.1.0"

  ...

  enable_karpenter = true
}
```

#### Generic Git repository (SSH)

<a name="generic-git-repository--ssh--.93e38904-a835-589c-8a6c-32b58d0521be"></a>

**Warning**  
You need to configure credentials to access private repositories.

```
module "eks_karpenter" {
  source = "git::ssh://username@example.com/terraform-aws-eks.git?ref=v1.1.0"

  ...

  enable_karpenter = true
}
```

## Follow coding standards

<a name="coding-standards"></a>

Apply consistent Terraform formatting rules and styles across all configuration files. Enforce standards by using automated style checks in CI/CD pipelines. When you embed coding best practices into team workflows, configurations remain readable, maintainable, and collaborative as usage spreads widely across an organization.

### Follow style guidelines

<a name="follow-style-guidelines.8361ae48-67ee-52a4-ba22-481be2b0e993"></a>

+ Format all Terraform files (`.tf` files) with the [terraform fmt](https://developer.hashicorp.com/terraform/cli/commands/fmt) command to match HashiCorp style standards.
+ Use the [terraform validate](https://developer.hashicorp.com/terraform/cli/commands/validate) command to verify the syntax and structure of your configuration.
+ Statically analyze code quality by using [TFLint](https://github.com/terraform-linters/tflint). This linter checks for Terraform best practices beyond just formatting and fails builds when it encounters errors.

### Configure pre-commit hooks

<a name="configure-pre-commit-hooks.b48fdbb6-f66c-5024-be22-da0bf9828afa"></a>

Configure client-side pre-commit hooks that run `terraform fmt`, `tflint`, `checkov`, and other code scans and style checks before you allow commits. This practice helps you validate standards conformance earlier in developer workflows.

Use pre-commit frameworks such as [pre-commit](https://pre-commit.com/) to add Terraform linting, formatting, and code scanning as hooks on your local machine. Hooks run on each Git commit and fail the commit if checks don't pass.

Moving style and quality checks to local pre-commit hooks provides rapid feedback to developers before changes are introduced. Standards become part of the coding workflow.
