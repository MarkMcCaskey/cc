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

//revise this later:
//character (\\.|[^\\"])

//one or more numbers with an optional sign
integer ("-"?[0-9]+)

%%
//scanning here
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
