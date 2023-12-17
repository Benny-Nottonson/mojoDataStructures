from math import max
from sys.intrinsics import PrefetchOptions
from Iterator import Iterator

struct ArrayList[T: DType](Stringable):
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
            let el = self.a.load((self.j + i) % self.len)
            b.store(i, el)
        self.j = 0
        self.len = len
        self.a.free()
        self.a = b
        
    fn get(inout self, i: Int) raises -> SIMD[T, 1]:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        return self.a.load((self.j + i) % self.len)

    fn set(inout self, i: Int, x: SIMD[T, 1]) raises:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        self.a.store((self.j + i) % self.len, x)

    fn add(inout self, i: Int, x: SIMD[T, 1]) raises:
        if i < 0 or i > self.n:
            raise Error("index out of bounds")
        if self.n + 1 > self.len:
            self.resize()
        if i < self.n // 2:
            self.j = (self.j - 1) % self.len
            for k in range(i):
                self.a.store((self.j + k) % self.len, self.a.load((self.j + k + 1) % self.len))
        else:
            for k in range(self.n, i, -1):
                self.a.store((self.j + k) % self.len, self.a.load((self.j + k - 1) % self.len))
        self.a.store((self.j + i) % self.len, x)
        self.n += 1

    fn remove(inout self, i: Int) raises -> SIMD[T, 1]:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        let x = self.a.load((self.j + i) % self.len)
        if i < self.n // 2:
            for k in range(i, 0, -1):
                self.a.store((self.j + k) % self.len, self.a.load((self.j + k - 1) % self.len))
            self.j = (self.j + 1) % self.len
        else:
            for k in range(i, self.n - 1):
                self.a.store((self.j + k) % self.len, self.a.load((self.j + k + 1) % self.len))
        self.n -= 1
        if self.len >= 3 * self.n:
            self.resize()
        return x
        
    fn append(inout self, x: SIMD[T, 1]) raises:
        self.add(self.n, x)

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