grammar simpleCalc;

start   : (s+=stmt)* /*e=expr*/ EOF ;

/* A grammar for arithmetic expressions */

expr : x=ID						# Variable
	| op=OP f=FLOAT				# SignedConstant
	| c=FLOAT					# Constant
	| e1=expr op=OP2 e2=expr	# MultDiv
	| e1=expr op=OP e2=expr		# AddSub
	| '(' e=expr ')'			# Parenthesis
;

stmt : x=ID '=' e=expr						# Assignment
	| 'if' c=cond p1=prog 'else' p2=prog	# IfElse
	| 'if' c=cond p=prog					# If
	| 'while' c=cond p=prog					# While
	| 'print' str=STRING					# PrintStr
	| 'print' e=expr						# PrintVar
;

stmts: s1=stmt s2=stmts		# Statements
	| /* epsilon */			# Epsilon
;

cond : '!' c=cond						# Negation
	| e1=expr op=EQ e2=expr				# Comparison
	| c1=cond op='and' c2=cond			# And
	| c1=cond op='or' c2=cond			# Or
;

prog : s=stmt				# Oneliner
	| '{' s=stmts '}'		# Scope
;


// Lexer:

OP : ('-'|'+') ; // Plus/Minus operators
OP2: ('*'|'/') ; // Mutiply/Divide operators

EQ : ('=='|'!='|'<'|'>'|'<='|'>=') ; // Equality operators

ID    : ALPHA (ALPHA|NUM)* ;
STRING: '"' (ALPHA|NUM|' ')* '"';
FLOAT : NUM+ ('.' NUM+)? ;

ALPHA : [a-zA-Z_ÆØÅæøå] ;
NUM   : [0-9] ;

WHITESPACE : [ \n\t\r]+ -> skip;
COMMENT    : '//'~[\n]*  -> skip;
COMMENT2   : '/*' (~[*] | '*'~[/]  )*   '*/'  -> skip;
