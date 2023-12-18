from math import max
from Shared import IndexError

trait ListBased(Sized, Movable, Copyable):
    fn __getitem__(borrowed self, i: Int) raises -> CollectionElement:
        ...
        
    fn __setitem__(inout self, i: Int, x: CollectionElement) raises:
        ...

    fn __len__(borrowed self) -> Int:
        ...

    fn resize(inout self):
        ...

    fn add(inout self, i: Int, x: CollectionElement) raises:
        ...

    fn remove(inout self, i: Int) raises -> CollectionElement:
        ...
    


@value
struct ArrayList[T: CollectionElement](ListBased):
    var n: Int
    var j: Int
    var a: DynamicVector[T]

    fn __getitem__(borrowed self, i: Int) raises -> CollectionElement:
        if i < 0 or i >= self.n:
            raise IndexError
        return self.a[(self.j + i) % self.a.capacity]

    fn __setitem__(inout self, i: Int, x: CollectionElement) raises:
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

    fn add(inout self, i: Int, x: CollectionElement) raises:
        if i < 0 or i > self.n:
            raise IndexError
        if self.n + 1 > self.a.capacity:
            self.resize()
        if i < self.n // 2:
            self.j = (self.j - 1) % self.a.capacity
            for k in range(i):
                self.a[(self.j + k) % self.a.capacity] = self.a[
                    (self.j + k + 1) % self.a.capacity
                ]
        else:
            for k in range(self.n, i, -1):
                self.a[(self.j + k) % self.a.capacity] = self.a[
                    (self.j + k - 1) % self.a.capacity
                ]
        self.n += 1

    fn remove(inout self, i: Int) raises -> CollectionElement:
        if i < 0 or i >= self.n:
            raise IndexError
        let x = self.a[(self.j + i) % self.a.capacity]
        if i < self.n // 2:
            for k in range(i, 0, -1):
                self.a[(self.j + k) % self.a.capacity] = self.a[
                    (self.j + k - 1) % self.a.capacity
                ]
            self.j = (self.j + 1) % self.a.capacity
        else:
            for k in range(i, self.n - 1):
                self.a[(self.j + k) % self.a.capacity] = self.a[
                    (self.j + k + 1) % self.a.capacity
                ]
        self.n -= 1
        if self.a.capacity >= 3 * self.n:
            self.resize()
        return x

    fn append(inout self, x: T):
        if self.n + 1 > self.a.capacity:
            self.resize()
        self.a[(self.j + self.n) % self.a.capacity] = x
        self.n += 1


@value
struct ArrayQueue[T: CollectionElement](ListBased):
    var n: Int
    var j: Int
    var a: DynamicVector[T]

    fn __getitem__(borrowed self, i: Int) raises -> CollectionElement:
        if i < 0 or i >= self.n:
            raise IndexError
        return self.a[(self.j + i) % self.a.capacity]

    fn __setitem__(inout self, i: Int, x: CollectionElement) raises:
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

    fn add(inout self, i: Int, x: CollectionElement) raises:
        if self.n + 1 > self.a.capacity:
            self.resize()
        self.a[(self.j + self.n) % self.a.capacity] = x
        self.n += 1

    fn remove(inout self, i: Int) raises -> CollectionElement:
        if self.n == 0:
            raise IndexError
        let x = self.a[self.j]
        self.j = (self.j + 1) % self.a.capacity
        self.n -= 1
        if self.a.capacity >= 3 * self.n:
            self.resize()
        return x

    fn append(inout self, x: T):
        if self.n + 1 > self.a.capacity:
            self.resize()
        self.a[(self.j + self.n) % self.a.capacity] = x
        self.n += 1


@value
struct ArrayStack[T: CollectionElement](ListBased):
    var n: Int
    var a: DynamicVector[T]

    fn __getitem__(borrowed self, i: Int) raises -> CollectionElement:
        if i < 0 or i >= self.n:
            raise IndexError
        return self.a[i]

    fn __setitem__(inout self, i: Int, x: CollectionElement) raises:
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

    fn add(inout self, i: Int, x: CollectionElement) raises:
        if i < 0 or i > self.n:
            raise IndexError
        if self.n + 1 > self.a.capacity:
            self.resize()
        for j in range(self.n + 1, i + 1, -1):
            self.a[j] = self.a[j - 1]
        self.a[i] = x
        self.n += 1

    fn remove(inout self, i: Int) raises -> CollectionElement:
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
