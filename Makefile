

default: test.html
test.html: test.md
	pandoc test.md -s --mathjax --template template.html -o test.html
