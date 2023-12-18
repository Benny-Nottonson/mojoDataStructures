from math import max
from Shared import IndexError


@value
struct ArrayQueue[T: CollectionElement](Sized, Movable, Copyable):
    var n: Int
    var j: Int
    var a: DynamicVector[T]

    fn __getitem__(borrowed self, i: Int) raises -> T:
        if i < 0 or i >= self.n:
            raise IndexError
        return self.a[(self.j + i) % self.a.capacity]

    fn __setitem__(inout self, i: Int, x: T) raises:
        if i < 0 or i >= self.n:
            raise IndexError
        self.a[(self.j + i) % self.a.capacity] = x

    fn __len__(borrowed self) -> Int:
        return self.n

    fn resize(inout self):
        let len = max(1, self.n * 2)
        var b = DynamicVector[T](len)
        b.reserve(len)
        b.data = self.a.data
        self.a = b

    fn add(inout self, x: T):
        if self.n + 1 > self.a.capacity:
            self.resize()
        self.a[(self.j + self.n) % self.a.capacity] = x
        self.n += 1

    fn remove(inout self) raises -> T:
        if self.n == 0:
            raise IndexError
        let x = self.a[self.j]
        self.j = (self.j + 1) % self.a.capacity
        self.n -= 1
        if self.a.capacity >= 3 * self.n:
            self.resize()
        return x

    fn append(inout self, x: T):
        self.add(x)
