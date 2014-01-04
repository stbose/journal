

default: test.html
test.html: test.md template.html
	pandoc test.md -s --mathjax --template template.html -o test.html


index.html: index.md template.html 
	pandoc index.md -s --template template.html -o index.html
