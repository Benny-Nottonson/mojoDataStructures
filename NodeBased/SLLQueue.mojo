@value
struct Node[T: DType]:
    var value: SIMD[T, 1]
    var nxt: Pointer[Self]
        
struct SLLQueue[T: DType]:
    var head: Pointer[Node[T]]
    var tail: Pointer[Node[T]]
    var n: Int

    fn __init__(inout self):
        self.head = self.tail = Pointer[Node[T]].get_null()
        self.n = 0
