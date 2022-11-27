# asciidoc book template

This is a template that resembles the configuration I've used for past book work with asciidoc. Notably, it optimizes for the way I'd want to write my files rather than what's been required of me in the past:

* Writing a chapter should be as free of noise as possible. No boilerplate attributes or messing with levels.
* Output to HTML, PDF, and EPUB by default
* Include as many bits as possible of the book as first-class parts and special parts rather than deferring those to extra-asciidoc processes.

## Setup

This is often a very tricky part, and I've done my best to alleviate as much pain as can be safely assumed without much effort into automation and inference about your particular platform. This setup should mostly be platform agnostic, but I am working on a MacBook with an M1 chip.

### Prerequisites

1. You'll need Make.
1. You'll need a Ruby environment. I recommend [asdf](https://asdf-vm.com/).
1. You'll need Bundler. I like using `bundle config --local path .bundle/` to isolate the gems for the project.
1. If you want to use any equations in your content you'll need the prerequisites for `asciidoc-mathematical`. If you don't need it, you can remove it from your `Gemfile` and delete `Gemfile.lock` before installing dependencies. Otherwise, follow [their instructions](https://github.com/asciidoctor/asciidoctor-mathematical#installation). You may run into a fair amount of trouble at this step on macOS with Homebrew. I ended up needing to run `brew install zstd` and then `bundle config --local build.mathematical "--with-opt-dir=/opt/homebrew/opt/zstd --with-ldflags=-L/opt/homebrew/opt/zstd/lib"` to fix the compilation of `mathematical` on macOS Mojave with M1 chip.
1. Create a repository from this template or otherwise make a copy of its contents.
1. Change to the root directory of the project.

### Installation

1. Run `bundle install`.

### Usage

The hard part is writing the book, mainly, but the following sections describe how to work with the tools.

#### Building files

You can build all files in all formats using Make. You can build all files by running `make` with no arguments. You can also build a specific output file by running `make <format>/<file>.<ext>`. As an example, you can build the full book in EPUB format by running `make epub/book.epub`.

Because building all files takes a while, and because not all changes get picked up by the dependencies described in `Makefile`, I often run `make clean && make -j4` to clear all built files and regenerate them with four processes.

#### Quality

You can run `make check` to highlight some common things to avoid when writing technical books; these are mainly words to avoid that could upset or confuse the reader. You can change or enhance these checks in `Makefile`. Maybe it should be separated out into its own script for ease of development.

#### Customizing

You'll need to fill in your own name and email address in `book.adoc`.

You'll need to replace `default-cover.svg` with a book cover image of your own. See [asciidoc-epub3's documentation](https://docs.asciidoctor.org/epub3-converter/latest/) for more details.
