module Eval where

import Syntax

eval :: Expr -> Maybe Bool
eval x = case x of

  One -> Just True

  Zero -> Just False

  Neg e -> do
    b <- eval e
    return (not b)

  And e1 e2 -> do
    b1 <- eval e1
    b2 <- eval e2
    return (b1 && b2)

  Or e1 e2 -> do
    b1 <- eval e1
    b2 <- eval e2
    return (b1 || b2)