from mulang import expectation
from mulang import Inspection
import pytest

def test_standard_expectation_are_standard():
    assert expectation.Standard("*", Inspection("Assigns")).is_standard()
    
def test_standard_expectation_is_not_custom():
    assert not expectation.Standard("*", Inspection("Assigns")).is_custom()

def test_custom_expectation_is_not_standard():
    assert not expectation.Custom().is_standard()
    
def test_custom_expectation_is_custom():
    assert expectation.Custom().is_custom()

def test_expectation_to_tuple():
    assert expectation.Standard("*", Inspection("Assigns", negated=True)).to_tuple() == ("*", "Not:Assigns")