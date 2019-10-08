grammar simpleCalc;

start   : (s+=stmt)* e=expr EOF ;

/* A grammar for arithmetic expressions */

expr : x=ID						# Variable
	 | op=OP f=FLOAT			# SignedConstant
	 | c=FLOAT					# Constant
	 | e1=expr op=OP2 e2=expr	# MultDiv
	 | e1=expr op=OP e2=expr	# AddSub
	 | '(' e=expr ')'			# Parenthesis
;

stmt : x=ID '=' e=expr						# Assignment
	| 'if' '(' cond ')' stmts				# If
	| 'if' '(' cond ')' stmts 'else' stmts	# IfElse
	| 'while' '(' cond ')' stmts			# While
;

stmts: stmt ';' stmts
	| stmt
	|
;

cond : expr ('=='|'!=') expr
	| expr ('<'|'>') expr
	| cond ('&&'|'||') cond
	| '!' cond
;

//prog : stmt ';'
//	| stmts
//;

// Lexer:

OP : ('-'|'+') ; // Plus/Minus operatorer
OP2: ('*'|'/') ; // Gange/Dividere operatorer

ID    : ALPHA (ALPHA|NUM)* ;
FLOAT : NUM+ ('.' NUM+)? ;

ALPHA : [a-zA-Z_ÆØÅæøå] ;
NUM   : [0-9] ;

WHITESPACE : [ \n\t\r]+ -> skip;
COMMENT    : '//'~[\n]*  -> skip;
COMMENT2   : '/*' (~[*] | '*'~[/]  )*   '*/'  -> skip;
