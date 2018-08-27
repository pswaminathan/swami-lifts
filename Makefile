.PHONY: all build clean commit deploy serve help

HUGO := hugo

# All input files
FILES=$(shell find content layouts static themes -type f)

help:
	@echo "Usage: make <command>"
	@echo "  build   Builds the blog"
	@echo "  serve   Runs a hugo web server, watching for changes"
	@echo "  clean   Cleans all build files"
	@echo "  deploy  Builds the blog, commits it, and pushes it live"
	@echo ""
	@echo "New article:"
	@echo "  hugo new post/the_title"
	@echo "  $$EDITOR content/post/the_title.md"
	@echo "  make serve"
	@echo "  open "

all: build

build:
	HUGO_ENV=production $(HUGO)

clean:
	cd public && git reset --hard && git clean -df

commit:
	cd public && git add --all && git commit -m "Publishing to gh-pages"

deploy: clean build commit
	git push origin gh-pages

serve:
	$(HUGO) server -D