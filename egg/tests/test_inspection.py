from mulang import Inspection
from mulang import target
import pytest


def test_create_inspection():
    an_inspection = Inspection("Assigns", negated=False, matcher=None, target=None)
    assert an_inspection.typ == "Assigns"
    assert not an_inspection.negated
    assert an_inspection.matcher == None
    assert an_inspection.target == None

def test_create_inspection_with_default_args():
    an_inspection = Inspection("Assigns")
    assert an_inspection.typ == "Assigns"
    assert not an_inspection.negated
    assert an_inspection.matcher == None
    assert an_inspection.target == None

def test_str_of_simplest_inspection():
    assert str(Inspection("Assigns")) == "Assigns"

def test_str_of_a_negated_inspection():
    assert str(Inspection("Assigns", negated=True)) == "Not:Assigns"

def test_str_of_a_inspection_with_target():
    assert str(Inspection("Assigns", target=target.Named("Hola"))) == "Assigns:=Hola"

def test_str_of_a_inspection_with_like_target():
    assert str(Inspection("Assigns", target=target.Like("Hola"))) == "Assigns:~Hola"

def test_str_of_a_inspection_with_anyone_target():
    assert str(Inspection("Assigns", target=target.Anyone())) == "Assigns:*"
