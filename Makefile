
PANDOC=		pandoc 
TEMPLATE=	templates/template.html
PYTHON=		python


html/%.html : md_entries/%.md 
	$(PANDOC) $< -s --mathjax --template $(TEMPLATE) -o $@


index : 
	$(PYTHON) makeindex.py

html_clean: 
	rm -vf html/*.html
