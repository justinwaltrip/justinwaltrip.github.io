# AGENTS.md

Personal site (justinwaltrip.com) built with Hugo and a forked `hugo-coder` theme (git submodule in `themes/hugo-coder`).

## Commands

- `dev` / `hugo server -D` — local dev server
- `hugo` — build to `public/` (gitignored)
- `check` / `pre-commit run --all-files` — lint

## Screenshots

Run `hugo server -D` in the background, wait for `localhost:1313`, then use headless Chrome:

```sh
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu \
  --hide-scrollbars --window-size=1440,1000 --screenshot=out.png http://localhost:1313/
```

Headless Chrome on macOS seems to have a minimum window width, so narrow `--window-size` values (e.g. 390) probably crop instead of showing the real mobile layout. Use Chrome device mode to check mobile.

## Layout

- `config.toml` — site config, menu, social links
- `content/` — pages (`About.md`, `Projects.md`, `Contact.md`) and `posts/`
- `layouts/`, `assets/scss/custom.scss` — overrides of theme templates/styles; prefer these over editing the theme submodule
- `static/` — images and other static files

## Workflow

- Commit directly to `main`. Pushing to `main` deploys to GitHub Pages (`.github/workflows/hugo.yml`), so only push when asked.
