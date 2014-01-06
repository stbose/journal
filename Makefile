
PANDOC=		pandoc 
TEMPLATE=	template.html
PYTHON=		python

default: test.html

%.html : %.md 
	$(PANDOC) $< -s --mathjax --template $(TEMPLATE) -o $@


index : 
	$(PYTHON) makeindex.py

#test.html: test.md template.html
#	pandoc test.md -s --mathjax --template template.html -o test.html


#index.html: index.md template.html 
#	pandoc index.md -s --template template.html -o index.html
