%{
#include <stdlib.h>
#include <assert.h>
	//C code here
%}

%union {
	//symbol type
	int ival;
	char* string;
 }

%token //need to find and list tokens here

%%
 //parsing goes here
%%
