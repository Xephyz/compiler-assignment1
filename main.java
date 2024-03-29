import org.antlr.v4.runtime.tree.ParseTreeVisitor;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import org.antlr.v4.runtime.CharStreams;

import java.util.*;
import java.io.IOException;

public class main {
	public static void main(String[] args) throws IOException {

		// we expect exactly one argument: the name of the input file
		if (args.length != 1) {
			System.err.println("\n");
			System.err.println("Simple calculator\n");
			System.err.println("=================\n\n");
			System.err.println("Please give as input argument a filename\n");
			System.exit(-1);
		}
		String filename = args[0];

		// open the input file
		CharStream input = CharStreams.fromFileName(filename);
		//new ANTLRFileStream (filename); // depricated

		// create a lexer/scanner
		simpleCalcLexer lex = new simpleCalcLexer(input);

		// get the stream of tokens from the scanner
		CommonTokenStream tokens = new CommonTokenStream(lex);

		// create a parser
		simpleCalcParser parser = new simpleCalcParser(tokens);

		// and parse anything from the grammar for "start"
		ParseTree parseTree = parser.start();

		// Construct an interpreter and run it on the parse tree
		Interpreter interpreter = new Interpreter();


		Double result = interpreter.visit(parseTree);

		//System.out.println("The result is: " + result);

	}
}

// We write an interpreter that implements interface
// "simpleCalcVisitor<T>" that is automatically generated by ANTLR
// This is parameterized over a return type "<T>" which is in our case
// simply a Double.

class Interpreter extends AbstractParseTreeVisitor<Double> implements simpleCalcVisitor<Double> {

	// An environment mapping variablenames to double values (initially empty)
	public static HashMap<String, Double> env = new HashMap<String, Double>();

	public Double visitStart(simpleCalcParser.StartContext ctx) {
		// New implementation: visit all assignments:
		/*for (simpleCalcParser.AssignContext a:ctx.as)
	    visit(a);*/
		for (simpleCalcParser.StmtContext a : ctx.s)
			visit(a);
		//return visit(ctx.e);
		return 0.0;
	}

	public Double visitParenthesis(simpleCalcParser.ParenthesisContext ctx) {
		return visit(ctx.e);
	}

	public Double visitVariable(simpleCalcParser.VariableContext ctx) {
		// New implementation: look up the value of the variable in the environment env:
		String varname = ctx.x.getText();
		Double d = env.get(varname);
		if (d == null) {
			System.err.println("Variable " + varname + " is not defined.\n");
			System.exit(-1);
		}
		return d;
	}

	public Double visitAddSub(simpleCalcParser.AddSubContext ctx) {
		if (ctx.op.getText().equals("+"))
			return visit(ctx.e1) + visit(ctx.e2);
		else
			return visit(ctx.e1) - visit(ctx.e2);
	}

	public Double visitMultDiv(simpleCalcParser.MultDivContext ctx) {
		if (ctx.op.getText().equals("*"))
			return visit(ctx.e1) * visit(ctx.e2);
		else
			return visit(ctx.e1) / visit(ctx.e2);
	}

	public Double visitConstant(simpleCalcParser.ConstantContext ctx) {
		return Double.parseDouble(ctx.c.getText());
	}

	public Double visitSignedConstant(simpleCalcParser.SignedConstantContext ctx) {
		return Double.parseDouble(ctx.getText());
	}

	public Double visitAssignment(simpleCalcParser.AssignmentContext ctx) {
		// New implementation: evaluate the expression and store it in the environment for the given
		// variable name
		String varname = ctx.x.getText();
		Double v = visit(ctx.e);
		env.put(varname, v);

		return v;
	}

	public Double visitIf(simpleCalcParser.IfContext ctx) {
		if (visit(ctx.c) == 1.0) {
			return visit(ctx.p);
		}
		return 0.0;
	}

	public Double visitIfElse(simpleCalcParser.IfElseContext ctx) {
		if (visit(ctx.c) == 1.0) return visit(ctx.p1);
		return visit(ctx.p2);
	}

	public Double visitWhile(simpleCalcParser.WhileContext ctx) {
		while (visit(ctx.c) == 1.0) {
			visit(ctx.p);
		}
		return 0.0;
	}

	public Double visitStatements(simpleCalcParser.StatementsContext ctx) {
		visit(ctx.s1);
		visit(ctx.s2);
		return 0.0;
	}

	public Double visitEpsilon(simpleCalcParser.EpsilonContext ctx) {
		return 0.0;
	}

	public Double visitNegation(simpleCalcParser.NegationContext ctx) {
		if (visit(ctx.c) == 1.0) return 0.0;
		else return 1.0;
	}

	public Double visitComparison(simpleCalcParser.ComparisonContext ctx) {
		if (ctx.op.getText().equals("==")) {
			if (visit(ctx.e1).equals(visit(ctx.e2))) {
				return 1.0;
			} else {
				return 0.0;
			}
		}
		if (ctx.op.getText().equals("!=")) {
			if (visit(ctx.e1) != visit(ctx.e2)) {
				return 1.0;
			} else {
				return 0.0;
			}
		}
		if (ctx.op.getText().equals("<")) {
			if (visit(ctx.e1) < visit(ctx.e2)) {
				return 1.0;
			} else {
				return 0.0;
			}
		}
		if (ctx.op.getText().equals(">")) {
			if (visit(ctx.e1) > visit(ctx.e2)) {
				return 1.0;
			} else {
				return 0.0;
			}
		}
		if (ctx.op.getText().equals("<=")) {
			if (visit(ctx.e1) <= visit(ctx.e2)) {
				return 1.0;
			} else {
				return 0.0;
			}
		}
		if (ctx.op.getText().equals(">=")) {
			if (visit(ctx.e1) >= visit(ctx.e2)) {
				return 1.0;
			} else {
				return 0.0;
			}
		}
		return 0.0;
	}

	public Double visitAnd(simpleCalcParser.AndContext ctx) {
		if (visit(ctx.c1) == 1.0 && visit(ctx.c2) == 1.0) {
			return 1.0;
		}
		return 0.0;
	}

	public Double visitOr(simpleCalcParser.OrContext ctx) {
		if (visit(ctx.c1) == 1.0 || visit(ctx.c2) == 1.0) {
			return 1.0;
		}
		return 0.0;
	}

	public Double visitOneliner(simpleCalcParser.OnelinerContext ctx) {
		visit(ctx.s);
		return 0.0;
	}

	public Double visitScope(simpleCalcParser.ScopeContext ctx) {
		visit(ctx.s);
		return 0.0;
	}

	public Double visitPrintStr(simpleCalcParser.PrintStrContext ctx) {
		String str_in = ctx.str.getText();
		String str_out = str_in.substring(1, str_in.length() - 1);

		System.out.println(str_out);
		return 0.0;
	}

	public Double visitPrintVar(simpleCalcParser.PrintVarContext ctx) {
		System.out.println(visit(ctx.e));
		return 0.0;
	}
}

