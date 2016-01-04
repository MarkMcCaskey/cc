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

 //number tokens
%token DEC_NUMBER HEX_NUMBER OCT_NUMBER FLOAT_NUMBER HEX_FLOAT_NUMBER
%token CHAR SCHAR HCHAR QCHAR OCT_DIGIT HEX_DIGIT

 //other tokens

%%
 //parsing goes here

constant: integer_constant
        | floating_constant
        | enumeration_constant
        | character_constant

//integer:

integer_constant: DEC_NUMBER integer_suffix
                | OCT_NUMBER integer_suffix
                | HEX_NUMBER integer_suffix

integer_suffix: unsigned_suffix long_suffix
              | unsigned_suffix long_long_suffix
              | long_suffix unsigned_suffix
              | long_long_suffix unsigned_suffix
              |

unsigned_suffix: "u" | "U"
long_suffix: "l" | "L"
long_long-suffix "ll" | "LL"

//float:

floating_constant: decimal_floating_constant
                 | hexadecimal_floating_constant

decimal_floating_constant: FLOAT_NUMBER exponent_part_o floating_suffix_o
                         | DEC_NUMBER exponent_part floating_suffix_o

hexadecimal_floating_constant: HEX_FLOAT_NUMBER binary_exponent_part floating_suffix_o
                             | HEX_NUMBER binary_exponent_part floating_suffix_o

exponent_part_o: exponent_part | 
floating_suffix_o: floating_suffix | 

exponent_part: "e" sign_o DEC_NUMBER
             | "E" sign_o DEC_NUMBER

sign_o: sign | 
sign: "+" | "-"

binary_exponent_part: "p" sign_o DEC_NUMBER
                    | "P" sign_o DEC_NUMBER

floating_suffix: "f" | "l" | "F" | "L"

 //enum:

enumeration_constant: IDENTIFIER

 //character:

character_constant: "'"  c_char_seq "'"
                  | "L'" c_char_seq "'"
                  | "u'" c_char_seq "'"
                  | "U'" c_char_seq "'"

c_char_seq: c_char
          | c_char_seq c_char

c_char: CHAR | escape_seq

escape_seq: simple_escape_seq
          | octal_escape_seq
          | hexadecimal_escape_seq
 //| universal_character_name?

simple_escape_seq: "\\\'" | "\\\"" | "\\?" | "\\\\" | "\\a" | "\\b" | "\\f"
                 | "\\n" | "\\r" | "\\t" | "\\v"

octal_escape_seq: "\\" OCT_DIGIT
                | "\\" OCT_DIGIT OCT_DIGIT
                | "\\" OCT_DIGIT OCT_DIGIT OCT_DIGIT

hexadecimal_escape_seq: "\\x" HEX_DIGIT
                      | hexadecimal_escape_seq HEX_DIGIT


 //string literals:

string_literal: encoding_prefix_o "\"" s_char_seq_o "\""

encoding_prefix_o: encoding_prefix | 
encoding_prefix: "u8" | "u" | "U" | "L"

s_char_seq: s_char
          | s_char_seq s_char

s_char: SCHAR
      | escape_seq

 //header names:

header_name: "<" h_char_seq ">"
           | "\"" q_char_seq "\""

h_char_seq: HCHAR
          | h_char_seq HCHAR

q_char_seq: QCHAR
          | q_char_seq QCHAR
%%
