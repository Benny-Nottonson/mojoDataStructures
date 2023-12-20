from Shared import IndexError
from memory.unsafe import bitcast

"""
Can be implemented once traits support Parametric Types
trait LinkedList[T: CollectionElement](Sized, Movable, Copyable):

"""

@value
struct Node[T: CollectionElement](CollectionElement):
    var value: T
    var next: Pointer[Self]


@value
struct SLList[T: CollectionElement]:
    ...

@value
struct SLLStack[T: CollectionElement]:
    var head: Node[T]
    var tail: Node[T]
    var size: Int

    fn push(inout self, value: T):
        var u = Node(value, Pointer[Node[T]].get_null())
        if self.size == 0:
            self.head = u
            self.tail = u
        else:
            u.next = Pointer[Node[T]].address_of(self.head)
            self.head = u


@value
struct SLLQueue[T: CollectionElement]:
    ...