MANUSCRIPT_DIR = manuscript
CODE_THEME = base16.solarized
PDF_DIR = pdf
HTML_DIR = html
EPUB_DIR = epub
CODE_DIR = code
FONTS_DIR = fonts
STYLES_DIR = .
STYLE = manning

PATTERNS_TO_AVOID := easy \
	simple \
	simply \
	actual \
	actually \
	basically \
	effectively \
	especially \
	essentially \
	"in other words" \
	"in order (?:to|for)" \
	just \
	"of course" \
	really \
	"(?:this|which) means that" \
	thus \
	very \
	"i\.e\." \
	"e\.g\." \
	"there is" \
	"there are" \
	"for instance"

PATTERNS_TO_REPLACE := however \
	leverage \
	since \
	utilize \
	"(?<!a )while(?! ago)"

book = $(MANUSCRIPT_DIR)/book.adoc
all_docs = $(filter-out $(book), $(wildcard $(MANUSCRIPT_DIR)/*.adoc))
chapters = $(filter $(MANUSCRIPT_DIR)/CH%_hillard3_PubPyPack.adoc, $(all_docs))
matter = $(filter-out $(chapters), $(all_docs))

pdf_files = $(addprefix $(PDF_DIR)/, $(notdir $(all_docs:.adoc=.pdf)))
html_files = $(addprefix $(HTML_DIR)/, $(notdir $(all_docs:.adoc=.html)))
epub_files = $(addprefix $(EPUB_DIR)/, $(notdir $(all_docs:.adoc=.epub)))

all: $(pdf_files) $(html_files) $(epub_files) $(PDF_DIR)/$(notdir $(book:.adoc=.pdf)) $(HTML_DIR)/$(notdir $(book:.adoc=.html)) $(EPUB_DIR)/$(notdir $(book:.adoc=.epub))

html: $(html_files) $(HTML_DIR)/book.html
pdf: $(pdf_files) $(PDF_DIR)/book.pdf
epub: $(epub_files) $(EPUB_DIR)/book.epub

$(PDF_DIR)/book.pdf : $(book) $(all_docs)
$(PDF_DIR)/%.pdf : $(MANUSCRIPT_DIR)/%.adoc
	@echo `date "+%H:%M:%S"` Generating $@ from $<...
	@bundle exec asciidoctor-pdf \
		--trace \
		--attribute generate-index=true \
		--attribute experimental \
		--attribute sectnums \
		--attribute partnums \
		--attribute imagesdir=images \
		--attribute xref \
		--attribute xrefstyle=short \
		--attribute stem=latexmath \
		--attribute bibliography-database=dl4nlp.bib \
		--attribute bibliography-style=ieee \
		--attribute allow-uri-read=true \
		--attribute source-highlighter=rouge \
		--attribute rouge-style=$(CODE_THEME) \
		--attribute icons=font \
		--attribute figure-caption=Figure \
		--attribute listing-caption=Listing \
		--attribute table-caption=Table \
		--require asciidoctor-mathematical \
		--attribute mathematical-format=svg \
		--destination-dir $(PDF_DIR) \
		--doctype book \
		$<

$(HTML_DIR)/book.html : $(book) $(all_docs)
$(HTML_DIR)/%.html : $(MANUSCRIPT_DIR)/%.adoc
	@echo `date "+%H:%M:%S"` Generating $@ from $<...
	@bundle exec asciidoctor \
		--trace \
		--attribute experimental \
		--attribute sectnums \
		--attribute partnums \
		--attribute imagesdir=images \
		--attribute xref \
		--attribute xrefstyle=short \
		--attribute stem=latexmath \
		--attribute bibliography-database=dl4nlp.bib \
		--attribute bibliography-style=ieee \
		--attribute allow-uri-read=true \
		--attribute source-highlighter=rouge \
		--attribute rouge-style=$(CODE_THEME) \
		--attribute icons=font \
		--attribute figure-caption=Figure \
		--attribute listing-caption=Listing \
		--attribute table-caption=Table \
		--require asciidoctor-mathematical \
		--attribute mathematical-format=svg \
		--destination-dir $(HTML_DIR) \
		--doctype book \
		$<

$(EPUB_DIR)/book.epub : $(book) $(all_docs)
$(EPUB_DIR)/%.epub : $(MANUSCRIPT_DIR)/%.adoc
	@echo `date "+%H:%M:%S"` Generating $@ from $<...
	@bundle exec asciidoctor-epub3 \
		--trace \
		--attribute experimental \
		--attribute sectnums \
		--attribute partnums \
		--attribute imagesdir=images \
		--attribute xref \
		--attribute xrefstyle=short \
		--attribute stem=latexmath \
		--attribute bibliography-database=dl4nlp.bib \
		--attribute bibliography-style=ieee \
		--attribute allow-uri-read=true \
		--attribute source-highlighter=rouge \
		--attribute rouge-style=$(CODE_THEME) \
		--attribute icons=font \
		--attribute figure-caption=Figure \
		--attribute listing-caption=Listing \
		--attribute table-caption=Table \
		--require asciidoctor-mathematical \
		--attribute mathematical-format=svg \
		--destination-dir $(EPUB_DIR) \
		--doctype book \
		$<

.PHONY: clean
clean:
	rm -rf $(PDF_DIR)
	rm -rf $(HTML_DIR)
	rm -rf $(EPUB_DIR)

.PHONY: check
check:
	@echo Words to be avoided
	@echo -------------------
	@for word in $(PATTERNS_TO_AVOID); do rg --ignore-case "\b$$word\b" $(MANUSCRIPT_DIR) || true; done
	@echo
	@echo Words to be replaced
	@echo --------------------
	@for word in $(PATTERNS_TO_REPLACE); do rg --pcre2 --ignore-case "\b$$word\b" $(MANUSCRIPT_DIR) || true; done
