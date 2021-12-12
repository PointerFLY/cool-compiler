//
// Created by Ma Linghao on 23/11/21.
//

#include "lexer.h"
#include <string_view>

std::vector<Token> Lexer::tokenize(const std::string& text) const {
    std::vector<Token> vec;
    Token token;
    token.type = TokenType::ASSIGN;
    token.value = "=";
    vec.emplace_back(token);
    return vec;
}