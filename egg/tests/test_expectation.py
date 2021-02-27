import pytest
from mulang import expectation

def test_standard_expectation_are_standard():
    assert expectation.Standard("*","Assigns").is_standard()
    
def test_standard_expectation_is_not_custom():
    assert not expectation.Standard("*","Assigns").is_custom()


def test_custom_expectation_is_not_standard():
    assert not expectation.Custom().is_standard()
    
def test_custom_expectation_is_custom():
    assert expectation.Custom().is_custom()