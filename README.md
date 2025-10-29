# nix-toolbox

> Personal collection of Nix devshells, packages, and infrastructure tooling

A reusable Nix flake providing standardized development environments and utilities for infrastructure-as-code workflows.

## Features

- **Development Shells** - Pre-configured environments with validation hooks
- **Custom Packages** - Infrastructure-specific tools (GKE auth, etc.)
- **Reusable Modules** - Claude Code skills, VS Code workspace configs
- **Quality Automation** - Pre-commit hooks for code formatting and linting

## Quick Start

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- Supported systems: `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, `aarch64-darwin`

### Usage

Enter the default development shell:
```bash
nix develop
```

Or use a specific environment:
```bash
# Terraform/OpenTofu development
nix develop .#terraform

# Terragrunt development
nix develop .#terragrunt
```

### Automatic Shell Loading

Enable [direnv](https://direnv.net/) for automatic environment activation:
```bash
echo "use flake" > .envrc
direnv allow
```

## Development Shells

### Default Shell
Basic infrastructure environment:
- Alejandra (Nix formatter)
- Pre-commit hooks

### Terraform Shell
Terraform/OpenTofu development with automated validation:
- OpenTofu CLI
- Pre-commit hooks:
  - Alejandra (Nix formatting)
  - Prettier (Markdown, YAML, JSON)
  - shfmt (Shell scripts)
  - tflint (Terraform linting)
  - terraform-format (code formatting)
  - terraform-validate (syntax validation)
- terraform-docs
- glab (GitLab CLI)

### Terragrunt Shell
Terragrunt-focused environment with similar tooling to the Terraform shell.

## Custom Packages

### gke-gcloud-auth-plugin
Google Kubernetes Engine authentication plugin for kubectl (v34.0.0).

Build and install:
```bash
nix build .#gke-gcloud-auth-plugin
./result/bin/gke-gcloud-auth-plugin --version
```

## Modules

### Claude Code Skills
Define custom AI skills for Claude Code integration:
```nix
{
  claude-code-skills = {
    my-skill = {
      description = "Custom skill description";
      tools = ["Read" "Write"];
      prompt = "Skill instructions...";
    };
  };
}
```

### VS Code Workspace
Automated workspace configuration with launch settings and editor configs.

## Project Structure

```
.
├── flake.nix              # Main flake definition
├── devshells/             # Development environments
│   ├── default/           # Basic shell
│   ├── terraform/         # Terraform shell
│   └── terragrunt/        # Terragrunt shell
├── packages/              # Custom packages
│   └── gke-gcloud-auth-plugin/
├── modules/               # Reusable modules
│   ├── claude-code-skills.nix
│   └── vscode.nix
├── overlays/              # Nixpkgs overlays
├── checks/                # Format validation
└── lib/                   # Shared utilities
    └── versioning.nix     # Semantic version helpers
```

## Using in Other Projects

Reference this flake in your own `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-toolbox.url = "github:AddG0/nix-toolbox";
  };

  outputs = { self, nixpkgs, nix-toolbox }: {
    # Use the packages
    packages.x86_64-linux.default = nix-toolbox.packages.x86_64-linux.gke-gcloud-auth-plugin;

    # Or extend the devShells
    devShells.x86_64-linux.default = nix-toolbox.devShells.x86_64-linux.terraform;
  };
}
```

## Development

### Running Checks
```bash
nix flake check
```

### Formatting Code
```bash
nix fmt
```

## License

MIT License - see [LICENSE](LICENSE) file for details.
