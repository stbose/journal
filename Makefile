
PANDOC=		pandoc 
TEMPLATE=	templates/template.html
PYTHON=		python
ENTRIES_HOME=	/Users/stbose/rt/notebook/entries
LN=		ln 

html/%.html : md_entries/%.md 
	$(PANDOC) $< -s --mathjax --template $(TEMPLATE) -o $@


link_entries: 
	$(LN) -s $(ENTRIES_HOME)/* md_entries/

index : 
	$(PYTHON) makeindex.py

html_clean: 
	rm -vf html/*.html
