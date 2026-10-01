%{
  import java.io.*;
%}


%token INT, DOUBLE, BOOLEAN, IDENT, VOID, AND, NUM, IF, ELSE, WHILE

%right '='
%nonassoc '>'
%left AND
%left '+' '-'
%left '*' '/'

%%

Prog : Tipo IDENT Resto
    ;

Resto : ';' Prog
    | ',' LId ';' Prog
    | '(' ListaParametrosOuVazio ')' Bloco ListaFuncoes
    ;

Tipo : INT
    | DOUBLE
    | BOOLEAN
    ;

LId : LId ',' IDENT
    | IDENT
    ;

ListaFuncoes : ListaFuncoes Funcao
    |
    ;

Funcao : TipoOuVoid IDENT '(' ListaParametrosOuVazio ')' Bloco
    ;

TipoOuVoid : VOID
    | Tipo
    ;

ListaParametrosOuVazio : ListaParametros
    |
    ;


ListaParametros : Tipo IDENT
    | Tipo IDENT ',' ListaParametros
    ;

Bloco :  '{' LCmd '}'

LCmd :  Cmd LCmd
    |
    ;

Cmd : Bloco
    | IF '(' E ')' Cmd
    | IF '(' E ')' Cmd ELSE Cmd
    | WHILE '(' E ')' Cmd
    |  E ';'
    ;

E : E '=' E
    | E '+' E
    | E '*' E
    | E '/' E
    | E '>' E
    | E AND E
    | NUM
    | IDENT
    | '(' E ')'
    ;

%%

  private Yylex lexer;
  private int lines = 0;


  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
      lines += lexer.getLine();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e.getMessage());
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: " + error + " on char: " + yychar + ", on line " + lines);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }


  static boolean interactive;

  public void setDebug(boolean debug) {
    yydebug = debug;
  }


  public static void main(String args[]) throws IOException {
    System.out.println("");

    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
    }
    else {
      // interactive mode
      System.out.println("[Quit with CTRL-D]");
      System.out.print("> ");
      interactive = true;
	    yyparser = new Parser(new InputStreamReader(System.in));
    }

    yyparser.yyparse();

  //  if (interactive) {
      System.out.println();
      System.out.println("done!");
  //  }
  }
