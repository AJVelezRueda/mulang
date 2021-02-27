from mulang import target
import pytest

def test_create_like_target():
    assert target.Like("Hola").value == "Hola"

def test_like_to_str():
    assert str(target.Like("Hola")) == "~Hola"

def test_except_to_str():
    assert str(target.Except("Hola")) == "^Hola"

def test_named_to_str():
    assert str(target.Named("Hola")) == "=Hola"

def test_plain_to_str():
    assert str(target.Plain("Hola")) == "Hola"

def test_anyone_to_str():
    assert str(target.Anyone()) == "*"