from math import max


struct ArrayQueue[T: DType](Stringable, Sized):
    var n: Int
    var j: Int
    var len: Int
    var a: DTypePointer[T]

    fn __init__(inout self, n: Int = 0):
        self.n = n
        self.j = 0
        self.len = n
        self.a = DTypePointer[T].alloc(n)

    fn __getitem__(borrowed self, i: Int) raises -> SIMD[T, 1]:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        return self.a.load((self.j + i) % self.len)

    fn __setitem__(borrowed self, i: Int, x: SIMD[T, 1]) raises:
        if i < 0 or i >= self.n:
            raise Error("index out of bounds")
        self.a.store((self.j + i) % self.len, x)

    fn __del__(owned self):
        self.a.free()

    fn __len__(borrowed self) -> Int:
        return self.n

    fn __copyinit__(inout self, other: Self) -> None:
        self.n = other.n
        self.j = other.j
        self.len = other.len
        self.a = DTypePointer[T].alloc(self.len)
        memcpy(self.a, other.a, self.len)

    fn __moveinit__(inout self, owned other: Self) -> None:
        self.n = other.n
        self.j = other.j
        self.len = other.len
        self.a = other.a
        memcpy[T](self.a, other.a, self.len)

    fn __str__(self) -> String:
        var s = String("[")
        for i in range(self.n):
            s += str(self.a.load((self.j + i) % self.len))
            if i < self.n - 1:
                s += ", "
        s += "]"
        return s

    fn resize(inout self):
        let len = max(1, self.n * 2)
        let b = DTypePointer[T]().alloc(len)
        for i in range(self.n):
            b.store(i, self.a.load((self.j + i) % self.len))
        self.j = 0
        self.len = len
        self.a.free()
        self.a = b

    fn get(inout self, i: Int) raises -> SIMD[T, 1]:
        return self[i]

    fn set(inout self, i: Int, x: SIMD[T, 1]) raises:
        self[i] = x

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

    fn append(inout self, x: SIMD[T, 1]):
        self.add(x)