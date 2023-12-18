from memory.unsafe import bitcast

struct Node[T: DType]:
    var value: SIMD[T, 1]
    var nxt: Pointer[Node[T]]

    fn __init__(inout self, value: SIMD[T, 1], owned nxt: Pointer[Node[T]]):
        self.value = value
        self.nxt = nxt

    fn __getitem__(self, i: Int) -> SIMD[T, 1]:
        return self.value

    fn __setitem__(inout self, i: Int, x: SIMD[T, 1]):
        self.value = x

    fn __copyinit__(inout self, other: Node[T]):
        self.value = other.value
        self.nxt = other.nxt

    fn __moveinit__(inout self, owned other: Node[T]):
        self.value = other.value
        self.nxt = other.nxt

    fn __eq__(self, other: Node[T]) -> Bool:
        return self.value == other.value and self.nxt == other.nxt

        
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
