from Interfaces import Stack, Node

struct SLLList[T: DType]:
    var head: DTypePointer[DType.address]
    var tail: DTypePointer[DType.address]
    var size: Int
    
    fn __init__(inout self):
        self.head = DTypePointer[DType.address].get_null()
        self.tail = DTypePointer[DType.address].get_null()
        self.size = 0

    fn push(inout self, data: DTypePointer[T]):
        let node = DTypePointer[T].alloc(2)