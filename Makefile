.PHONY: all build clean commit deploy serve help init-pages

HUGO := hugo

# All input files
FILES=$(shell find content layouts static themes -type f)

help:
	@echo "Usage: make <command>"
	@echo "  build       Builds the blog"
	@echo "  serve       Runs a hugo web server, watching for changes"
	@echo "  clean       Cleans all build files"
	@echo "  deploy      Builds the blog, commits it, and pushes it live"
	@echo "  init-pages  Initial worktree setup for GitHub Pages"
	@echo ""
	@echo "New article:"
	@echo "  hugo new post/the_title"
	@echo "  $$EDITOR content/post/the_title.md"
	@echo "  make serve"
	@echo "  open "

all: clean build

build: clean
	HUGO_ENV=production $(HUGO)

clean:
	cd public && git reset --hard && git clean -df

commit:
	cd public && git add --all && git commit -m "Publishing to gh-pages"

deploy: clean build commit
	git push origin gh-pages

serve:
	$(HUGO) server -D

init-pages:
	# This is based on making the "public" folder (Hugo's default outputDir)
	# a worktree for the gh-pages branch. This is an elegant way to enable
	# GitHub pages while keeping master clean (i.e. without dirtying the history
	# with generated files). This is based on instructions at
	# https://gohugo.io/hosting-and-deployment/hosting-on-github/#deployment-of-project-pages-from-your-gh-pages-branch
	# FIXME: If your remote name is something other than "origin",
	# make sure you change the git commands accordingly.
	mkdir public
	touch .gitignore && grep 'public' .gitignore || echo 'public' >> .gitignore
	git diff-index --quiet HEAD --
	git checkout --orphan gh-pages
	git commit --allow-empty -m "Initializing gh-pages branch"
	git push origin gh-pages
	git worktree add -B gh-pages public origin/gh-pages
