@value
struct Node[T: DType]:
    var value: SIMD[T, 1]
    var nxt: Pointer[Node[T]]

    fn __eq__(borrowed self, other: Node[T]) -> Bool:
        return self.value == other.value and self.nxt == other.nxt

    fn __ne__(borrowed self, other: Node[T]) -> Bool:
        return self.value != other.value or self.nxt != other.nxt
        
struct SLLQueue[T: DType]:
    var head: Node[T]
    var tail: Node[T]
    var n: Int

    fn __init__(inout self):
        self.head = Node[T](SIMD[T, 1](0), Pointer[Node[T]].get_null())
        self.tail = Node[T](SIMD[T, 1](0), Pointer[Node[T]].get_null())
        self.n = 0

    fn add(inout self, x: SIMD[T, 1]):
        var u = Node[T](x, Pointer[Node[T]].get_null())
        if self.n == 0:
            self.head = u
        else:
            self.tail.nxt = Pointer[Node[T]].address_of(u)
        self.tail = u
        self.n += 1

    fn remove(inout self) -> SIMD[T, 1]:
        if self.n == 0:
            return SIMD[T, 1](0)
        var x = self.head.value
        self.head = self.head.nxt
        self.n -= 1
        if self.n == 0:
            self.tail = Node[T](SIMD[T, 1](0), Pointer[Node[T]].get_null())
        return x
