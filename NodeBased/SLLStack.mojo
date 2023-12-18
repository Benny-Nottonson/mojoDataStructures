from Shared import IndexError

@value
@register_passable
struct Node[T: DType]:
    var value: SIMD[T, 1]
    var nxt: Pointer[Self]
        
        
struct SLLStack[T: DType](Stringable, Sized):
    var head: Pointer[Node[T]]
    var tail: Pointer[Node[T]]
    var null: Pointer[Node[T]]
    var n: Int

    fn __init__(inout self):
        self.null = self.head = self.tail = Pointer[Node[T]].get_null()
        self.n = 0

    fn push(inout self, value: SIMD[T, 1]):
        let node = Pointer[Node[T]].alloc(1)
        node.store(Node[T](value, self.head))
        self.head = node
        if self.n == 0:
            self.tail = node
        self.n += 1

    fn pop(inout self) raises -> SIMD[T, 1]:
        if self.n == 0:
            raise Error("Stack is empty")
        let node = self.head
        self.head = node.load().nxt
        if self.n == 1:
            self.tail = self.head
        self.n -= 1
        return node.load().value

    fn size(self) -> Int:
        return self.n

    fn __str__(self) -> String:
        var s = String("[")
        var node = self.head
        while node != self.null:
            s += node.load().value.__str__()
            node = node.load().nxt
            if node != self.null:
                s += ", "
        s += "]"
        return s

    fn __len__(self) -> Int:
        return self.n


fn main():
    let a = SLLStack[DType.int32]()
    print(a)

    