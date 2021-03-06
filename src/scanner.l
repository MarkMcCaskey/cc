%option noyywrap //we want scanning to stop at the end of the file
%{
#include <stdlib.h>
#include <assert.h>
#include "parser.tab.h" //figure out include dir later

#define OUT_FILE_SIZE 50 //arbitrary number, review later
	//C code here
%}

/* give patterns names here */

//one or more alphanum or _ starting with a letter or _
identifier ([a-zA-Z]|"_")(("_"|[a-zA-Z]|[0-9])*)
hexdigit ([0-9]|[a-fA-F])
octdigit ([0-7])

//TODO: revise and test these.  They look like they're wrong
character (\\.|[^\\'\n]) 
//' ]) ignore this.  I need to fix my Emacs
scharacter (\\.|[^\\"\n])
//"]) ignore this too
hcharacter ([^\n>])
qcharacter ([^\n"])
//"]) 

%%
//scanning here

//numbers
(0([0-7]+)                                   { return OCT_NUMBER; }
(0("x"|"X"){hexdigit}+)                      { return HEX_NUMBER; }
(([0-9]*"."[0-9]+)|[0-9]+".")                { return FLOAT_NUMBER; }
(({hexdigit}*"."{hexdigit}+)|{hexdigit}+".") { return HEX_FLOAT_NUMBER; }
{octdigit}                                   { return OCT_DIGIT; }
{hexdigit}                                   { return HEX_DIGIT; }
([1-9][0-9]*)                                { return DEC_NUMBER; }
{character}                                  { return CHAR; }
{scharacter}                                 { return SCHAR; }

//punctuators:
("<:"|"[")    { return OBRACKET; }
(":>"|"]")    { return CBRACKET; }
("<%"|"{")    { return OBRACE; }
("%>"|"}")    { return CBRACE; }
("%:%:"|"##") { return DOUBLE_HASH; }
("%:"|"#")    { return SINGLE_HASH; }

{hcharacter} { return HCHAR; }
{qcharacter} { return QCHAR; }

//keywords:
"auto"           { return AUTO; }
"break"          { return BREAK; }
"case"           { return CASE; }
"const"          { return CONST; }
"continue"       { return CONTINUE; }
"default"        { return DEFAULT; }
"double"         { return DOUBLE; }
"do"             { return DO; }
"else"           { return ELSE; }
"enum"           { return ENUM; }
"extern"         { return EXTERN; }
"float"          { return FLOAT; }
"for"            { return FOR; }
"goto"           { return GOTO; }
"if"             { return IF; }
"inline"         { return INLINE; }
"int"            { return INT; }
"long"           { return LONG; }
"register"       { return REGISTER; }
"restrict"       { return RESTRICT; }
"return"         { return RETURN; }
"short"          { return SHORT; }
"signed"         { return SIGNED; }
"sizeof"         { return SIZEOF; }
"static"         { return STATIC; }
"struct"         { return STRUCT; }
"switch"         { return SWITCH; }
"typedef"        { return TYPEDEF; }
"union"          { return UNION; }
"unsigned"       { return UNSIGNED; }
"void"           { return VOID; }
"volatile"       { return VOLATILE; }
"while"          { return WHILE; }
"_Alignas"       { return _ALIGNAS; }
"_Alignof"       { return _ALIGNOF; }
"_Atomic"        { return _ATOMIC; }
"_Bool"          { return _BOOL; }
"_Complex"       { return _COMPLEX; }
"_Generic"       { return _GENERIC; }
"_Imaginary"     { return _IMAGINARY; }
"_Noreturn"      { return _NORETURN; }
"_Static_assert" { return _STATIC_ASSERT; }
"_Thread_local"  { return _THREAD_LOCAL; }

%%
 //C code here
int main( int argc, char** argv )
{
	FILE* out_file;
	char out_file_name[OUT_FILE_SIZE] = {};

	if( argc < 2 )
	{
		/*
		 * Print help text here
		 */
		//Temporary error message:
		fprintf( stderr, "%s: fatal error - not enough arguments!\n",
			 argv[0] );
		exit( EXIT_FAILURE );
	}


	//Implement arguments with getopt


	exit( EXIT_SUCCESS );
}
