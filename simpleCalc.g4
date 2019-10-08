grammar simpleCalc;

start   : (s+=stmt)* e=expr EOF ;

/* A grammar for arithmetic expressions */

expr : x=ID						# Variable
	| op=OP f=FLOAT				# SignedConstant
	| c=FLOAT					# Constant
	| e1=expr op=OP2 e2=expr	# MultDiv
	| e1=expr op=OP e2=expr		# AddSub
	| '(' e=expr ')'			# Parenthesis
;

stmt : x=ID '=' e=expr								# Assignment
	| 'if' '(' c=cond ')' p=prog					# If
	| 'if' '(' c=cond ')' p1=prog 'else' p2=prog	# IfElse
	| 'while' '(' c=cond ')' p=prog					# While
;

stmts: stmt stmts
	| // epsilon
;

cond : '!' c=cond					# Negation
	| e1=expr op=EQ e2=expr			# Comparison
	| c1=cond ('&&'|'||') c2=cond	# AndOr
;

prog : s=stmt				# Oneliner
	| '{' s=stmts '}'		# Scope
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
