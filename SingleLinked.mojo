from Shared import IndexError

# Will not work until recursive types are supported, or non registery pointers work
"""
Can be implemented once traits support Parametric Types
trait SingleLinked[T: CollectionElement](Sized, Movable, Copyable):

"""

@value
struct Node[T: CollectionElement]:
    ...

@value
struct List[T: CollectionElement]:
    ...

@value
struct Stack[T: CollectionElement]:
    ...

@value
struct Queue[T: CollectionElement]:
    ...