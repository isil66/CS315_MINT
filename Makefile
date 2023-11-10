parser: y.tab.c lex.yy.c
	@echo "You will have executable file named 'parser'."
	@echo "You can test with ' ./parser < testX.txt where X is the test number'."
	@echo "Test 1, Test 3, Test 4 include some syntax errors to show how our language works."
	@echo "You can see the problematic lines on the testX.txt file as line comments."
	gcc -o parser y.tab.c
y.tab.c: ekmek.y lex.yy.c
	yacc ekmek.y
lex.yy.c: mint.l
	lex mint.l
clean:
	rm -f lex.yy.c y.tab.c parser