grammar simpleCalc;

start   : (as+=assign)* e=expr EOF ;

assign : x=ID '=' e=expr  ;

/* A grammar for arithmetic expressions */

expr : x=ID    	              # Variable
     | c=FLOAT	              # Constant
     | e1=expr '*' e2=expr    # Multiplication 
     | e1=expr op=OP e2=expr  # Addition
     | '(' e=expr ')'	      # Parenthesis
     | op=OP f=FLOAT          # SignedConstant
;

// Lexer:

OP : ('-'|'+') ;

ID    : ALPHA (ALPHA|NUM)* ;
FLOAT : NUM+ ('.' NUM+)? ;

ALPHA : [a-zA-Z_ÆØÅæøå] ;
NUM   : [0-9] ;

WHITESPACE : [ \n\t\r]+ -> skip;
COMMENT    : '//'~[\n]*  -> skip;
COMMENT2   : '/*' (~[*] | '*'~[/]  )*   '*/'  -> skip;
