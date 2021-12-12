#ifndef COOL_LEXER_H
#define COOL_LEXER_H

#include "token.h"
#include <vector>

class A {
public:
    const A &a;
};

class Lexer {
public:
    std::vector<Token> tokenize(const std::string& text) const;
};


#endif //COOL_LEXER_H
