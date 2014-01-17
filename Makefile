
PANDOC=		pandoc 
TEMPLATE=	templates/template.html
PYTHON=		python
ENTRIES_HOME=	$(HOME)/notebook/entries
LN=		ln 

html/%.html : md_entries/%.md 
	$(PANDOC) $< -s --mathjax --template $(TEMPLATE) -o $@


tex/% : md_entries/%.md 
	mkdir -p $@
	$(PANDOC) -s --filter pandoc-citeproc $< -o $@/main.tex


link_entries: 
	$(LN) -s $(ENTRIES_HOME)/* md_entries/

index : 
	$(PYTHON) makeindex.py

html_clean: 
	rm -vf html/*.html

.PHONY: tex/%
