parser: y.tab.c lex.yy.c
	@echo "You will have executable file named 'parser'."
	@echo "You can test with ' ./parser < testX.txt where X is the test number'."
	gcc -o parser y.tab.c
y.tab.c: ekmek.y lex.yy.c
	yacc ekmek.y
lex.yy.c: mint.l
	lex mint.l
clean:
	rm -f lex.yy.c y.tab.c parser