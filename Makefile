ANTLRJAR = /usr/local/lib/antlr-4.7.2-complete.jar

export CLASSPATH := .:$(ANTLRJAR):${CLASSPATH}
antlr4 = java -jar $(ANTLRJAR)
grun   = java org.antlr.v4.gui.TestRig

SRCFILES = main.java
GEN_DIR = .antlr

all:
	make simpleCalcListener.java
	make main.class

main.class:	$(SRCFILES) simpleCalc.g4
	javac -d $(GEN_DIR)  $(SRCFILES) $(GEN_DIR)/*.java

simpleCalcListener.java:	simpleCalc.g4
	$(antlr4) -o $(GEN_DIR) -visitor simpleCalc.g4

test:	main.class
	cd .antlr; java main ../simpleCalc_input.txt

tree:	$(GENERATED) simpleCalc.g4
	javac $(GEN_DIR)/*.java
	cd .antlr; $(grun) simpleCalc start -tree -gui < ../simpleCalc_input.txt


## Original makefile below:
# ANTLRJAR = /usr/local/lib/antlr-4.7.2-complete.jar

# export CLASSPATH := .:$(ANTLRJAR):${CLASSPATH}
# antlr4 = java -jar $(ANTLRJAR)
# grun   = java org.antlr.v4.gui.TestRig

# SRCFILES = main.java
# GENERATED = simpleCalcListener.java simpleCalcBaseListener.java simpleCalcParser.java simpleCalcBaseVisitor.java simpleCalcVisitor.java simpleCalcLexer.java

# all:
# 	make main.class

# main.class:	$(SRCFILES) $(GENERATED) simpleCalc.g4
# 	javac  $(SRCFILES) $(GENERATED)

# simpleCalcListener.java:	simpleCalc.g4
# 	$(antlr4) -visitor simpleCalc.g4

# test:	main.class
# 	java main simpleCalc_input.txt

# tree:	$(GENERATED) simpleCalc.g4
# 	javac $(GENERATED)
# 	$(grun) simpleCalc start -tree -gui < simpleCalc_input.txt
