# justinwaltrip.com

Personal website for Justin Waltrip — legal technology founder and AI engineer. Built with [Hugo](https://gohugo.io/) and a custom fork of the [hugo-coder](https://github.com/luizdepra/hugo-coder) theme.

## Development

Requires [Nix](https://nixos.org/) with flakes enabled.

```sh
# Enter the dev shell (installs Hugo + pre-commit hooks)
direnv allow

# Start the development server
dev

# Run pre-commit checks
check
```

Or without Nix:

```sh
git submodule update --init --recursive
hugo server -D
```

## Build

```sh
hugo
```

Output is written to `public/`. The site is deployed to GitHub Pages via the workflow in `.github/workflows/hugo.yml` on every push to `main`.
