from math import max
from Shared import IndexError

@value
struct ArrayStack[T: AnyRegType](Sized):
    var n: Int
    var len: Int
    var a: Pointer[T]

    fn __init__(inout self, n: Int = 0):
        self.n = self.len = n
        self.a = Pointer[T].alloc(n)

    fn __getitem__(borrowed self, i: Int) raises -> T:
        if i < 0 or i >= self.n:
            raise IndexError
        return self.a.load(i)

    fn __setitem__(inout self, i: Int, x: T) raises:
        if i < 0 or i >= self.n:
            raise IndexError
        self.a.store(i, x)

    fn __del__(owned self):
        self.a.free()

    fn __len__(borrowed self) -> Int:
        return self.n

    fn resize(inout self):
        let len = max(1, self.n * 2)
        let b = Pointer[T]().alloc(len)
        for i in range(self.n):
            b.store(i, self.a.load(i))
        self.len = len
        self.a.free()
        self.a = b

    fn get(inout self, i: Int) raises -> T:
        return self[i]

    fn set(inout self, i: Int, x: T) raises:
        self[i] = x

    fn add(inout self, i: Int, x: T) raises:
        if i < 0 or i > self.n:
            raise IndexError
        if self.n + 1 > self.len:
            self.resize()
        for j in range(self.n + 1, i + 1, -1):
            self.a.store(j, self.a.load(j - 1))
        self.a.store(i, x)
        self.n += 1

    fn remove(inout self, i: Int) raises -> T:
        if i < 0 or i >= self.n:
            raise IndexError
        let x = self.a.load(i)
        for j in range(i, self.n - 1):
            self.a.store(j, self.a.load(j + 1))
        self.n -= 1
        if self.len >= 3 * self.n:
            self.resize()
        return x

    fn push(inout self, x: T) raises:
        self.add(self.n, x)

    fn pop(inout self) raises -> T:
        return self.remove(self.n - 1)
