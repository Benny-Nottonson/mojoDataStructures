from Interfaces import Stack, Node
struct SLLNode[T: DType]:
    var data: DTypePointer[T]

    fn __init__(inout self):
        self.data = DTypePointer[T].alloc(0)

    fn __init__(inout self, data: DTypePointer[T]):
        self.data = DTypePointer[T].alloc(1)
        self.data.store(0, data.load(0))

    fn __init__(inout self, data: DTypePointer[T], owned next: DTypePointer[T]):
        self.data = DTypePointer[T].alloc(2)
        self.data.store(0, data.load(0))
        self.data.store(1, next.address_of(1))

struct SLLStack[T: DType](Stringable, Sized, Stack):
    var head: DTypePointer[T]
    var tail: DTypePointer[T]
    var size: Int

    fn __init__(inout self):
        self.size = 0
