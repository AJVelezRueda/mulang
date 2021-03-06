module Language.Mulang.Inspector.Bound (
  bind,
  bound,
  uncounting,
  containsBoundDeclaration,
  countBoundDeclarations,
  BoundConsult,
  BoundCounter,
  BoundInspection) where

import  Data.List.Extra (has)
import  Data.Count (Count, counts)

import  Language.Mulang.Consult (Consult)
import  Language.Mulang.Inspector.Matcher (Matcher)
import  Language.Mulang.Inspector.Primitive (Inspection, positive)
import  Language.Mulang.Identifier (IdentifierPredicate)
import  Language.Mulang.Generator (boundDeclarations)

type BoundConsult a = IdentifierPredicate -> Consult a
type BoundCounter = BoundConsult Count
type BoundInspection = BoundConsult Bool

bind :: Consult a -> BoundConsult a
bind = const

bound :: (Consult a -> Consult b) -> BoundConsult a -> BoundConsult b
bound = (.)

containsBoundDeclaration :: Inspection -> BoundInspection
containsBoundDeclaration f b  = has f (boundDeclarations b)

countBoundDeclarations :: Inspection -> BoundCounter
countBoundDeclarations f b  = counts f (boundDeclarations b)

uncounting :: (Matcher -> BoundCounter) -> Matcher -> BoundInspection
uncounting counter matcher = bound positive (counter matcher)
