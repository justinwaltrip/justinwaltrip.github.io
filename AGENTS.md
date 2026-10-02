# AGENTS.md

Personal site (justinwaltrip.com) built with Hugo and a forked `hugo-coder` theme (git submodule in `themes/hugo-coder`).

## Commands

- `dev` / `hugo server -D` — local dev server
- `hugo` — build to `public/` (gitignored)
- `check` / `pre-commit run --all-files` — lint

## Layout

- `config.toml` — site config, menu, social links
- `content/` — pages (`About.md`, `Projects.md`, `Contact.md`) and `posts/`
- `layouts/`, `assets/scss/custom.scss` — overrides of theme templates/styles; prefer these over editing the theme submodule
- `static/` — images and other static files

## Workflow

- Commit directly to `main`. Pushing to `main` deploys to GitHub Pages (`.github/workflows/hugo.yml`), so only push when asked.
