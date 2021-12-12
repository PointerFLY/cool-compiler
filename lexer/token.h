//
// Created by Ma Linghao on 23/11/21.
//

#ifndef COOL_TOKEN_H
#define COOL_TOKEN_H

#include <string>

enum class TokenType {
    IF,
    ELSE,
    FI,
    CLASS,
    FALSE,
    IN,
    INHERITS,
    ISVOID,
    LET,
    LOOP,
    POOL,
    THEN,
    WHILE,
    CASE,
    ESAC,
    NEW,
    OF,
    NOT,
    TRUE,
    DARROW,
    STRING_LITERAL,
    INT_LITERAL,
    ASSIGN,
    LE,
    ERROR,
    LET_STMT,
    TYPEID,
    OBJECTID,
    BOOL_LITERAL,
    FLOAT_LITERAL,
};

class Token {
public:
    TokenType type;
    std::string value;
//
//    bool boolValue() const;
//    bool intValue() const;
};


#endif //COOL_TOKEN_H
