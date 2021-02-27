from mulang import target
import pytest

def test_create_like_target():
    assert target.Like("Hola").value == "Hola"