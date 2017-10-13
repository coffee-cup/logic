module Parser where

import Text.Parsec
import Text.Parsec.String (Parser)

import qualified Text.Parsec.Expr as Ex
import qualified Text.Parsec.Token as Tok

import Data.Functor.Identity

import Lexer
import Syntax

binary :: String -> (a -> a -> a) -> Ex.Assoc -> Ex.Operator String () Identity a
binary name f = Ex.Infix (reservedOp name >> return f)

prefix :: String -> (a -> a) -> Ex.Operator String () Identity a
prefix name f = Ex.Prefix (reservedOp name >> return f)

postfix :: String -> (a -> a) -> Ex.Operator String () Identity a
postfix name f = Ex.Postfix (reservedOp name >> return f)

table :: Ex.OperatorTable String () Identity Expr
table = [
      [ prefix "!" Neg, prefix "not" Neg ]
    , [ binary "&" And Ex.AssocRight, binary "|" Or Ex.AssocRight,
        binary "and" And Ex.AssocRight, binary "or" Or Ex.AssocRight ]
  ]

value :: String -> Parser String
value s = do
  v <- string s
  Tok.whiteSpace lexer
  return v

one :: Parser Expr
one = do
  try (value "1") <|> try (value "true") <|> value "t" <?> "true"
  return One

zero :: Parser Expr
zero = do
  try (value "0") <|> try (value "false") <|> value "f" <?> "false"
  return Zero

expr :: Parser Expr
expr = Ex.buildExpressionParser table factor

factor :: Parser Expr
factor =
      try one
  <|> try zero
  <|> parens expr

contents :: Parser a -> Parser a
contents p = do
  Tok.whiteSpace lexer
  r <- p
  eof
  return r

parseExpr :: String -> Either ParseError Expr
parseExpr = parse (contents expr) "<stdin>"