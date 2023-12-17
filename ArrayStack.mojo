from math import max

struct ArrayStack[T: DType](Stringable, Sized):
    var n: Int
    var len: Int
    var a: DTypePointer[T]

    fn __init__(inout self):
        self.n = 0
        self.len = 1
        self.a = DTypePointer[T].alloc(1)

    fn __init__(inout self, n: Int):
        self.n = n
        self.len = n
        self.a = DTypePointer[T].alloc(n)

    fn resize(inout self):
        let len = max(1, self.n * 2)
        let b = DTypePointer[T]().alloc(len)
        for i in range(self.n):
            b.store(i, self.a.load(i))
        self.len = len
        self.a.free()
        self.a = b
    
    fn get(inout self, i: Int) raises -> SIMD[T, 1]:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        return self.a.load(i)

    fn set(inout self, i: Int, x: SIMD[T, 1]) raises:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        self.a.store(i, x)

    fn add(inout self, i: Int, x: SIMD[T, 1]) raises:
        if i < 0 or i > self.n:
            raise Error("index out of bounds")
        if self.n + 1 > self.len:
            self.resize()
        for j in range(self.n + 1, i + 1, -1):
            self.a.store(j, self.a.load(j - 1))
        self.a.store(i, x)
        self.n += 1

    fn remove(inout self, i: Int) raises -> SIMD[T, 1]:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        let x = self.a.load(i)
        for j in range(i, self.n - 1):
            self.a.store(j, self.a.load(j + 1))
        self.n -= 1
        if self.len >= 3 * self.n:
            self.resize()
        return x

    fn push(inout self, x: SIMD[T, 1]) raises:
        self.add(self.n, x)

    fn pop(inout self) raises -> SIMD[T, 1]:
        return self.remove(self.n - 1)

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
            s += str(self.a.load(i))
            if i < self.n - 1:
                s += ", "
        s += "]"
        return s