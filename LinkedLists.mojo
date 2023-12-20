from Shared import IndexError

"""
Can be implemented once traits support Parametric Types
trait LinkedList[T: CollectionElement](Sized, Movable, Copyable):

"""
@value
struct Node[T: CollectionElement](Movable, Copyable):
    var value: T
    var next: Pointer[Self]
    
    fn __copyinit__(inout self, other: Node[T]):
        self.value = other.value
        self.next = other.next

    fn __moveinit__(inout self, owned other: Node[T]):
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
        var node = Node[T](value, Pointer[Node[T]](Node[T]))
        if self.size == 0:
            self.head = node
            self.tail = node
        else:
            self.tail.next = node
            self.tail = node
        self.size += 1

@value
struct SLLQueue[T: CollectionElement]:
    ...