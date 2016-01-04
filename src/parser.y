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

//Keywords may not have to be tokens.  Review this later
%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM
%token EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN
%token SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED
%token VOID VOLATILE WHILE _ALIGNAS _ALIGNOF _ATOMIC _BOOL _COMPLEX
%token _GENERIC _IMAGINARY _NORETURN _STATIC_ASSERT _THREAD_LOCAL

%%
 //parsing goes here
%%
