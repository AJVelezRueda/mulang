class Like():
    def __init__(self, value):
        self.value = value
    
    def __str__(self):
        return f"~{self.value}"

class Except():
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return f"^{self.value}"


class Named():
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return f"={self.value}"

class Plain():
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return self.value

class Anyone():
    def __str__(self):
        return "*"
