from Shared import IndexError
from memory.unsafe import bitcast


# Will not work until recursive types are supported, or non registery pointers work
"""
Can be implemented once traits support Parametric Types
trait LinkedList[T: CollectionElement](Sized, Movable, Copyable):

"""

@value
struct Node[T: CollectionElement](CollectionElement):
    var value: T
    var next: Self

    fn __copyinit__(inout self, other: Self):
        self.value = other.value
        self.next = other.next

    fn __moveinit__(inout self, owned other: Self):
        self.value = other.value
        self.next = other.next

@value
struct SLList[T: CollectionElement]:
    ...

@value
struct SLLStack[T: CollectionElement]:
    var head: Node[T]
    var tail: Node[T]
    var size: Int

    fn push(inout self, value: T):
        var u = Node(value, None)
        if self.size == 0:
            self.head = u
            self.tail = u
        else:
            u.next = Pointer[Node[T]].address_of(self.head)
            self.head = u


@value
struct SLLQueue[T: CollectionElement]:
    ...