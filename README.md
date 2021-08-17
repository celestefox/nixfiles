# nixfiles-base

A base Nix setup derived from [kittywitch/nixfiles](kittywitch/nixfiles), using [arcnmx/tf-nix](https://github.com/arcnmx/tf-nix) for deployment, [arcnmx/ci](https://github.com/arcnmx/ci) for CI and [nmattia/niv](https://github.com/nmattia/niv) for dependency management.

## Getting Started

Please ripgrep for "SETUP". I may have missed some things.

## Commands

### Deployment

* `<targetName>-apply`
* `<targetName>-tf`

### Host Building

* `nix build -f . network.nodes.<hostName>.deploy.system`
