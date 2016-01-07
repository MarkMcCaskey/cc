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
%token OBRACKET CBRACKET OBRACE CBRACE DOUBLE_HASH SINGLE_HASH

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
          | universal_character_name?

 /*
  * Universal_character_name:
  * must be > 0x00A0 (excluding 0x0024, 0x0040, and 0x0060) and
  * not in the range of 0xD800-0xDFFF
  */
universal_character_name: "\\u" hex_quad | "\\U" hex_quad hex_quad

hex_quad: HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT

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

token: keyword
     | identifier
     | constant
     | string_literal
     | punctuator

 //review white space below:
preprocessing_token: header_name
                   | identifier
                   | pp_number
                   | character_constant
                   | string_literal
                   | punctuator
                   | " "
                   | "\t"
                   | "\n"
                   | "\v"
                   | "\r"

 //review if these should be explicitly checked in scanner
punctuator: OBRACKET | CBRACKET | "(" | ")" | OBRACE | CBRACE | "."
                     | "->" | "++" | "--" | "&" | "*" | "+" | "-"
                     | "~" | "!" | "/" | "%" | "<<" | ">>" | "<" | ">"
                     | "<=" | ">=" | "==" | "!=" | "^" | "|" | "&&" | "||"
                     | "?" | ":" | ";" | "..." | "=" | "*=" | "/=" | "%=" |
                     | "+=" | "-=" | "<<=" | ">>=" "&=" | "^=" | "|="
                     | "," | SINGLE_HASH | DOUBLE_HASH

 //this needs to be fixed
pp_number: DEC_NUMBER
         | "." DEC_NUMBER
         | pp_number DEC_NUMBER
         | pp_number identifier_nondigit
         | pp_number "e" sign
         | pp_number "E" sign
         | pp_number "p" sign
         | pp_number "P" sign
         | pp_number "."



 //expressions

primary_expression: identifier
                  | constant
                  | string_literal
                  | "(" expression ")"
                  | generic_selection

generic_selection:
_GENERIC "(" assignment_expression "," generic_assoc_list ")"

generic_assoc_list: generic_association
                  | generic_assoc_list "," generic_association

generic_association: type_name ":" assignment_expression
                   | DEFAULT ":" assignment_expression


 //punctuators need to be handled better
postfix_expression: primary_expression
                  | postfix_expression OBRACKET expression CBRACKET
                  | postfix_expression "(" argument_expression_list_o ")"
                  | postfix_expression "." identifier
                  | postfix_expression "->" identifier
                  | postfix_expression "++"
                  | postfix_expression "--"
                  | "(" type_name ")" OBRACE initializer_list CBRACE
                  | "(" type_name ")" OBRACE initializer_list "," CBRACE

argument_expression_list_o: argument_expression_list |
argument_expression_list: assignment_expression
                        | argument_expression_list "," assignment_expression


unary_expression: postfix_expression
                | "++" unary_expression
                | "--" unary_expression
                | unary_operator cast_expression
                | SIZEOF unary_expression
                | SIZEOF "(" type_name ")"
                | _ALIGNOF "(" type_name ")"

unary_operator: "&" | "*" | "+" | "-" | "~" | "!"


cast_expression: unary_expression
               | "(" type_name ")" cast_expression

multplicative_expression: cast_expression
                        | multiplicative_expression "*" cast_expression
                        | multiplicative_expression "/" cast_expression
                        | multiplicative_expression "%" cast_expression

additive_expression: multiplicative_expression
                   | additive_expression "+" multiplicative_expression
                   | additive_expression "-" multiplicative_expression

shift_expression: additive_expression
                | shift_expression "<<" additive_expression
                | shift_expression ">>" additive_expression

relational_expression: shift_expression
                     | relational_expression "<"  shift_expression
                     | relational_expression ">"  shift_expression
                     | relational_expression "<=" shift_expression
                     | relational_expression ">=" shift_expression

equality_expression: relational_expression
                   | equality_expression "==" relational_expression
                   | equality_expression "!=" relational_expression

AND_expression: equality_expression
              | AND_expression "&" equality_expression

exclusive_OR_expression: AND_expression
                       | exclusive_OR_expression "^" AND_expression

inclusive_OR_expression: exclusive_OR_expression
                       | inclusive_OR_expression "|" exclusive_OR_expression

logical_AND_expression: inclusive_OR_expression
                      | logical_AND_expression "&&" inclusive_OR_expression

logical_OR_expression: logical_AND_expression
                     | logical_OR_expression "||" logical_AND_expression

conditional_expression: logical_OR_expression
                      | logical_OR_expression "?" expression ":" conditional_expression



%%
