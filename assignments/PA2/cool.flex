/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

int comment_level = 0;
int string_len = 0;
bool string_contains_null = false;
bool string_too_long = false;

%}

/*
 * Define names for regular expressions here.
 */

%x LINE_COMMENT
%x BLOCK_COMMENT
%x STRING

%%

 /*
  * White space
  */

[\n]                      { curr_lineno += 1; }
[\f\r\t\v ]+              {}

 /*
  *  Nested comments
  */

"--"                        { BEGIN LINE_COMMENT; }
<LINE_COMMENT>\n            { curr_lineno += 1; BEGIN INITIAL; }
<LINE_COMMENT>.             {}

"(*"                        {
    comment_level += 1;
    BEGIN BLOCK_COMMENT; 
}
"*)" {
  cool_yylval.error_msg = "Unmatched *)";
  return (ERROR);
}
<BLOCK_COMMENT>"(*"         { comment_level += 1; }
<BLOCK_COMMENT>"*)"         {
  comment_level -= 1;
  if (comment_level == 0) {
    BEGIN INITIAL;
  }
}
<BLOCK_COMMENT>\n           { curr_lineno += 1; }
<BLOCK_COMMENT>.            {}
<BLOCK_COMMENT><<EOF>>	    {
  cool_yylval.error_msg = "EOF in comment";
  BEGIN INITIAL; 
  return (ERROR);
}

 /*
  *  The multiple-character operators.
  */

"=>"		                    { return DARROW; }
"<-"                        { return ASSIGN; }
"<="                        { return LE;     }

 /* 
  *  The single-character operators.
  */

"{"			{ return '{'; }
"}"			{ return '}'; }
"("			{ return '('; }
")"			{ return ')'; }
"~"			{ return '~'; }
","			{ return ','; }
";"			{ return ';'; }
":"			{ return ':'; }
"+"			{ return '+'; }
"-"			{ return '-'; }
"*"			{ return '*'; }
"/"			{ return '/'; }
"%"			{ return '%'; }
"."			{ return '.'; }
"<"			{ return '<'; }
"="			{ return '='; }
"@"			{ return '@'; }

 /*
  *  Keywords are case-insensitive except for the values true and false,
  *  which must begin with a lower-case letter.
  */

(?i:class)                { return CLASS; }
(?i:else)                 { return ELSE; }
(?i:fi)                   { return FI; }
(?i:if)                   { return IF; }
(?i:in)                   { return IN; }
(?i:inherits)             { return INHERITS; }
(?i:let)                  { return LET; }
(?i:loop)                 { return LOOP; }
(?i:pool)                 { return POOL; }
(?i:then)                 { return THEN; }
(?i:while)                { return WHILE; }
(?i:case)                 { return CASE; }
(?i:esac)                 { return ESAC; }
(?i:of)                   { return OF; }
(?i:new)                  { return NEW; }
(?i:not)                  { return NOT; }
(?i:isvoid)               { return ISVOID; }

t(?i:rue)                 {
  cool_yylval.boolean = 1;
  return BOOL_CONST; 
}

f(?i:alse)                {
  cool_yylval.boolean = 0;
  return BOOL_CONST;
}

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

\"                        {
  memset(string_buf, 0, sizeof(string_buf));
  string_len = 0;
  string_too_long = false;
  string_contains_null = false;
  BEGIN STRING; 
}
<STRING>\"                {
  if (string_too_long) {
    cool_yylval.error_msg = "String constant too long";
    BEGIN INITIAL;
    return ERROR;
  } 
  if (string_contains_null) {
    cool_yylval.error_msg = "String contains null character";
    BEGIN INITIAL;
    return ERROR;
  }

  cool_yylval.symbol = stringtable.add_string(string_buf);
  BEGIN INITIAL;
  return STR_CONST;
}
<STRING><<EOF>>	          {
  cool_yylval.error_msg = "EOF in string constant";
  BEGIN INITIAL;
  return (ERROR);
}
<STRING>\\\n              { curr_lineno += 1; }
<STRING>\n                {
  curr_lineno += 1;
  cool_yylval.error_msg = "Unterminated string constant";
  BEGIN INITIAL; // Assume the programmer forget the close-quote
  return ERROR;
}
<STRING>\\.               {
  if (string_len >= MAX_STR_CONST) {
    string_too_long = true;
  } else {
    switch (yytext[1]) {
      case 'b': string_buf[string_len++] = '\b'; break;
      case 't': string_buf[string_len++] = '\t'; break;
      case 'n': string_buf[string_len++] = '\n'; break;
      case 'f': string_buf[string_len++] = '\f'; break;
      case '0': {
        string_buf[string_len++] = '\0';
        string_contains_null = true;
        break;
      }
      default: string_buf[string_len++] = yytext[1];
    }
  }
}
<STRING>.                 {
  if (string_len >= MAX_STR_CONST) {
    string_too_long = true;
  } else {
    string_buf[string_len++] = yytext[0];
  }
}

 /*
  *  Identififers
  */
  
[A-Z][a-zA-Z0-9_]*        {
  cool_yylval.symbol = idtable.add_string(yytext);
  return TYPEID; 
}               
[a-z][a-zA-Z0-9_]*        {
  cool_yylval.symbol = idtable.add_string(yytext);
  return OBJECTID; 
}

 /*
  *  Integer constants
  */ 

[0-9]+                    { 
  cool_yylval.symbol = inttable.add_string(yytext);
  return INT_CONST; 
}

 /*
  *  Error 
  */

.                         {
  cool_yylval.error_msg = strdup(yytext);
  return ERROR;
}

%%
