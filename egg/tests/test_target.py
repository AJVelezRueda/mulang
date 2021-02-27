from mulang import LikeTarget
import pytest

def test_create_like_target():
    assert LikeTarget("Hola").value == "Hola"