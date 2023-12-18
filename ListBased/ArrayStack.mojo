from math import max
from Shared import IndexError

@value
struct ArrayStack[T: CollectionElement](Sized, Movable, Copyable):
    var n: Int
    var a: DynamicVector[T]

    fn __getitem__(borrowed self, i: Int) raises -> T:
        if i < 0 or i >= self.n:
            raise IndexError
        return self.a[i]

    fn __setitem__(inout self, i: Int, x: T) raises:
        if i < 0 or i >= self.n:
            raise IndexError
        self.a[i] = x

    fn __len__(borrowed self) -> Int:
        return self.n

    fn resize(inout self):
        let len = max(1, self.n * 2)
        var b = DynamicVector[T](len)
        b.reserve(len)
        b.data = self.a.data
        self.a = b

    fn add(inout self, i: Int, x: T) raises:
        if i < 0 or i > self.n:
            raise IndexError
        if self.n + 1 > self.a.capacity:
            self.resize()
        for j in range(self.n + 1, i + 1, -1):
            self.a[j] = self.a[j - 1]
        self.a[i] = x
        self.n += 1

    fn remove(inout self, i: Int) raises -> T:
        if i < 0 or i >= self.n:
            raise IndexError
        let x = self.a[i]
        for j in range(i, self.n - 1):
            self.a[j] = self.a[j + 1]
        self.n -= 1
        if self.a.capacity >= 3 * self.n:
            self.resize()
        return x

    fn push(inout self, x: T) raises:
        self.add(self.n, x)

    fn pop(inout self) raises -> T:
        return self.remove(self.n - 1)
