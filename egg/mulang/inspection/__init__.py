class Inspection():
    def __init__(self, typ, negated=False, target=None, matcher=None):
        self.negated = negated
        self.typ = typ
        self.target = target
        self.matcher = matcher

    def __str__(self):
        return f"{self.__negated_str__()}{self.typ}"

    def __negated_str__(self):
        return "Not:" if self.negated else ""
     
