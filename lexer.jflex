package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \r | \n | \r\n
Whitespace = [ \t] | {Newline}
Number     = [1-9][0-9]+
Digit      = [0-9] 

/* comments */
Comment = {TraditionalComment}
TraditionalComment = "/*" {CommentContent} \*+ "/"
CommentContent = ( [^*] | \*+[^*/] )*

ident = [a-zA-Z][a-zA-Z0-9_]*

/*literals*/
Integer = {Number}


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

/*keywords*/

<YYINITIAL> {

  "else"       {return symbolFactory.newSymbol("ELSE", ELSE); }
  "if"         {return symbolFactory.newSymbol("IF", IF); }
  "int"        {return symbolFactory.newSymbol("INT", INT); }
  "return"     {return symbolFactory.newSymbol("RETURN", RETURN); }
  "void"       {return symbolFactory.newSymbol("VOID", VOID); }
  "while"      {return symbolFactory.newSymbol("WHILE", WHILE); }
    
  {Comment}    {/*ignore*/}
  {Whitespace} {                              }
  ";"          { return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"          { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"          { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"          { return symbolFactory.newSymbol("TIMES", TIMES); }
  "n"          { return symbolFactory.newSymbol("UMINUS", UMINUS); }
  "("          { return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"          { return symbolFactory.newSymbol("RPAREN", RPAREN); }
    "/"        { return symbolFactory.newSymbol("DEVIDED_BY", DEVIDED_BY); }
  "<"          { return symbolFactory.newSymbol("LESS", LESS); }
  "<="         { return symbolFactory.newSymbol("LESS_OR_EQUAL", LESS_OR_EQUAL); }
  ">"          { return symbolFactory.newSymbol("GREATER", GREATER); }
  ">="         { return symbolFactory.newSymbol("GREATER_OR_EQUAL", GREATER_OR_EQUAL); }
  "=="         { return symbolFactory.newSymbol("EQUALS", EQUALS); }
  "!="         { return symbolFactory.newSymbol("NOT_EQUAL", NOT_EQUAL); }
  "="          { return symbolFactory.newSymbol("ASSIGNMENT", ASSIGNMENT); }
  ","          { return symbolFactory.newSymbol("COMMA", COMMA); }
  "["          { return symbolFactory.newSymbol("LSQPAR", LSQPAR); }
  "]"          { return symbolFactory.newSymbol("RSQPAR", RSQPAR); }
  "{"          { return symbolFactory.newSymbol("LCURLBRACE", LCURLBRACE); }
  "}"          { return symbolFactory.newSymbol("RCURLBRACE", RCURLBRACE); }
  
  {Number}     { return symbolFactory.newSymbol("NUM", NUM, Integer.parseInt(yytext())); }
    
  {Digit}     { return symbolFactory.newSymbol("DIGIT", DIGIT, Integer.parseInt(yytext())); }
  {ident}      { return symbolFactory.newSymbol("ID", ID); }    

}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
