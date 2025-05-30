#!/bin/bash

determine_js_pkg_manager() {
  if [ -f yarn.lock ]; then
    echo "Using Yarn"
    manager="yarn"
  elif [ -f pnpm-lock.yaml ]; then
    echo "Using pnpm"
    manager="pnpm"
  else
    echo "No JS package manager detected"
    manager="none"
  fi
}

check_es6_files() {
  echo "Checking for .js.es6 files"
  if find . -type f -name '*.js.es6' | grep -q "."; then
    echo ".js.es6 files are no longer supported by this workflow. Rename them to '.js'"
    exit 1
  fi
}

run_eslint() {
  if [ "$manager" != "none" ]; then
    if test -f eslint.config.mjs; then
      "$manager" eslint --fix --no-error-on-unmatched-pattern {test,assets,admin/assets}/javascripts
    else
      "$manager" eslint --fix --ext .js,.gjs --no-error-on-unmatched-pattern {test,assets,admin/assets}/javascripts
    fi
  fi
}

run_stylelint() {
  if [ "$manager" != "none" ] && test -f stylelint.config.mjs; then
    pnpm stylelint --fix --allow-empty-input "assets/**/*.scss"
  fi
}

run_prettier() {
  if [ "$manager" != "none" ]; then
    "$manager" prettier --version
    if [ -n "$(find assets -type f \( -name '*.scss' -or -name '*.js' -or -name '*.gjs' -or -name '*.hbs' \) 2>/dev/null)" ]; then
      "$manager" prettier --write "assets/**/*.{scss,js,gjs,hbs}"
    fi
    if [ -n "$(find admin/assets -type f \( -name '*.scss' -or -name '*.js' -or -name '*.gjs' -or -name '*.hbs' \) 2>/dev/null)" ]; then
      "$manager" prettier --write "admin/assets/**/*.{scss,js,gjs,hbs}"
    fi
    if [ 0 -lt "$(find test -type f \( -name '*.js' -or -name '*.gjs' \) 2> /dev/null | wc -l)" ]; then
      "$manager" prettier --write "test/**/*.{js,gjs}"
    fi
  fi
}

run_ember_template_lint() {
  if [ "$manager" != "none" ]; then
    "$manager" ember-template-lint --fix --no-error-on-unmatched-pattern assets/javascripts admin/assets/javascripts
  fi
}

run_rubocop() {
  bundle exec rubocop -A .
}

run_syntax_tree() {
  if test -f .streerc; then
    bundle exec stree write Gemfile $(git ls-files '*.rb') $(git ls-files '*.rake') $(git ls-files '*.thor')
  else
    echo "Stree config not detected for this repository. Skipping."
  fi
}

main() {
  determine_js_pkg_manager
  check_es6_files
  run_eslint
  run_stylelint
  run_prettier
  run_ember_template_lint
  run_rubocop
  run_syntax_tree
}

main