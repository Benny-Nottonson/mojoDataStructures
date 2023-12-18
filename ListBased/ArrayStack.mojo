from math import max


struct ArrayStack[T: DType](Stringable, Sized):
    var n: Int
    var len: Int
    var a: DTypePointer[T]

    fn __init__(inout self, n: Int = 0):
        self.n = self.len = n
        self.a = DTypePointer[T].alloc(n)

    fn __getitem__(borrowed self, i: Int) raises -> SIMD[T, 1]:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        return self.a.load(i)

    fn __setitem__(inout self, i: Int, x: SIMD[T, 1]) raises:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        self.a.store(i, x)

    fn __del__(owned self):
        self.a.free()

    fn __len__(borrowed self) -> Int:
        return self.n

    fn __copyinit__(inout self, other: Self) -> None:
        self.n = other.n
        self.len = other.len
        self.a = DTypePointer[T].alloc(self.len)
        memcpy(self.a, other.a, self.len)

    fn __moveinit__(inout self, owned other: Self) -> None:
        self.n = other.n
        self.len = other.len
        self.a = other.a
        memcpy[T](self.a, other.a, self.len)

    fn __str__(self) -> String:
        var s = String("[")
        for i in range(self.n):
            s += str(self.a.load(i))
            if i < self.n - 1:
                s += ", "
        s += "]"
        return s

    fn resize(inout self):
        let len = max(1, self.n * 2)
        let b = DTypePointer[T]().alloc(len)
        for i in range(self.n):
            b.store(i, self.a.load(i))
        self.len = len
        self.a.free()
        self.a = b

    fn get(inout self, i: Int) raises -> SIMD[T, 1]:
        return self[i]

    fn set(inout self, i: Int, x: SIMD[T, 1]) raises:
        self[i] = x

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
    