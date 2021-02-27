class Standard():
    def __init__(self, binding, inspection):
        self.binding = binding
        self.inspection = inspection

    def is_standard(self):
        return True

    def is_custom(self):
        return False
    
    def to_tuple(self):
        return (self.binding, str(self.inspection))


