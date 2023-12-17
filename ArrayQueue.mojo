from math import max
from Interfaces import Queue


struct ArrayQueue[T: DType](Stringable, Sized, Queue):
    var n: Int
    var j: Int
    var len: Int
    var a: DTypePointer[T]

    fn __init__(inout self):
        self.n = 0
        self.j = 0
        self.len = 1
        self.a = DTypePointer[T].alloc(1)

    fn __init__(inout self, n: Int):
        self.n = n
        self.j = 0
        self.len = n
        self.a = DTypePointer[T].alloc(n)

    fn resize(inout self):
        let len = max(1, self.n * 2)
        let b = DTypePointer[T]().alloc(len)

        for i in range(self.n):
            b.store(i, self.a.load((self.j + i) % self.len))
        self.j = 0
        self.len = len
        self.a.free()
        self.a = b

    fn get(self, i: Int) raises -> SIMD[T, 1]:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        return self.a.load((self.j + i) % self.len)

    fn set(inout self, i: Int, x: SIMD[T, 1]) raises:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        self.a.store((self.j + i) % self.len, x)

    fn add(inout self, x: SIMD[T, 1]):
        if self.n + 1 > self.len:
            self.resize()
        self.a.store((self.j + self.n) % self.len, x)
        self.n += 1

    fn remove(inout self) raises -> SIMD[T, 1]:
        if self.n == 0:
            raise Error("queue is empty")
        let x = self.a.load(self.j)
        self.j = (self.j + 1) % self.len
        self.n -= 1
        if self.len >= 3 * self.n:
            self.resize()
        return x

    fn size(self) -> Int:
        return self.n

    fn __len__(self) -> Int:
        return self.n

    fn __getitem__(inout self, i: Int) raises -> SIMD[T, 1]:
        return self.get(i)

    fn __setitem__(inout self, i: Int, x: SIMD[T, 1]) raises:
        self.set(i, x)

    fn __str__(self) -> String:
        var s = String("[")
        for i in range(self.n):
            s += str(self.a.load((self.j + i) % self.len))
            if i < self.n - 1:
                s += ", "
        s += "]"
        return s
