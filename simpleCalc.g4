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
	| 'if' '(' cond ')' prog				# If
	| 'if' '(' cond ')' prog 'else' prog	# IfElse
	| 'while' '(' cond ')' prog				# While
;

stmts: stmt stmts
	| // epsilon
;

cond : '!' cond					# Negation
	| expr EQ expr				# Comparison
	| cond ('&&'|'||') cond		# AndOr
;

prog : stmt				# Oneliner
	| '{' stmts '}'		# Scope
;

// Lexer:

OP : ('-'|'+') ; // Plus/Minus operators
OP2: ('*'|'/') ; // Mutiply/Divide operators

EQ : ('=='|'!='|'<'|'>'|'<='|'>=') ; // Equality operators

ID    : ALPHA (ALPHA|NUM)* ;
FLOAT : NUM+ ('.' NUM+)? ;

ALPHA : [a-zA-Z_ÆØÅæøå] ;
NUM   : [0-9] ;

WHITESPACE : [ \n\t\r]+ -> skip;
COMMENT    : '//'~[\n]*  -> skip;
COMMENT2   : '/*' (~[*] | '*'~[/]  )*   '*/'  -> skip;
