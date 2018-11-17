run:
	yacc -d test.y
	lex -l test.l
	gcc y.tab.c -ll
	./a.out < samp2.c
	

clean:
	rm lex.yy.c y.tab.c y.tab.h a.out;
