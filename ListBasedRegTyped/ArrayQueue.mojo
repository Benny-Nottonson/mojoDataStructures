from math import max
from Shared import IndexError


@value
struct ArrayQueue[T: AnyRegType](Sized):
    var n: Int
    var j: Int
    var len: Int
    var a: Pointer[T]

    fn __init__(inout self, n: Int = 0):
        self.n = self.len = n
        self.j = 0
        self.a = Pointer[T].alloc(n)

    fn __getitem__(borrowed self, i: Int) raises -> T:
        if i < 0 or i >= self.n:
            raise IndexError
        return self.a.load((self.j + i) % self.len)

    fn __setitem__(borrowed self, i: Int, x: T) raises:
        if i < 0 or i >= self.n:
            raise IndexError
        self.a.store((self.j + i) % self.len, x)

    fn __del__(owned self):
        self.a.free()

    fn __len__(borrowed self) -> Int:
        return self.n

    fn resize(inout self):
        let len = max(1, self.n * 2)
        let b = Pointer[T]().alloc(len)
        for i in range(self.n):
            b.store(i, self.a.load((self.j + i) % self.len))
        self.j = 0
        self.len = len
        self.a.free()
        self.a = b

    fn get(inout self, i: Int) raises -> T:
        return self[i]

    fn set(inout self, i: Int, x: T) raises:
        self[i] = x

    fn add(inout self, x: T):
        if self.n + 1 > self.len:
            self.resize()
        self.a.store((self.j + self.n) % self.len, x)
        self.n += 1

    fn remove(inout self) raises -> T:
        if self.n == 0:
            raise IndexError
        let x = self.a.load(self.j)
        self.j = (self.j + 1) % self.len
        self.n -= 1
        if self.len >= 3 * self.n:
            self.resize()
        return x

    fn append(inout self, x: T):
        self.add(x)
