module Syntax where

data Expr
  = Neg Expr
  | And Expr Expr
  | Or  Expr Expr
  | One
  | Zero
  deriving (Eq, Ord, Show)
