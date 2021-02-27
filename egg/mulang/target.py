class Base():
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return f"{self.prefix()}{self.value}"

class Like(Base):
    def prefix(self):
        return "~"

class Except(Base):
    def prefix(self):
        return "^"

class Named(Base):
    def prefix(self):
        return "="

class Plain(Base):
    def prefix(self):
        return ""

class Anyone():
    def __str__(self):
        return "*"
