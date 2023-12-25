from Shared import IndexError
from collections.vector import InlinedFixedVector
from math import max

"""
trait Array[T: AnyRegType](Sized, Movable, Copyable, AnyRegType):
    fn __getitem__(borrowed self, i: Int) raises -> T:
        ...
        
    fn __setitem__(inout self, i: Int, x: T) raises:
        ...

    fn __len__(borrowed self) -> Int:
        ...

    fn __str__(borrowed self) -> String:
        ...

    fn __copyinit__(inout self, other: List[T]):
        ...

    fn __moveinit__(inout self, owned other: List[T]):
        ...

    fn resize(inout self):
        ...

    fn add(inout self, i: Int, x: T) raises:
        ...

    fn remove(inout self, i: Int) raises -> T:
        ...
"""


struct List[T: AnyRegType = Int](Sized, Movable, Copyable, CollectionElement):
    var n: Int
    var j: Int
    var a: InlinedFixedVector[T]

    fn __init__(inout self, n: Int = 0):
        self.n = n
        self.j = 0
        self.a = InlinedFixedVector[T](n)

    fn __moveinit__(inout self, owned other: List[T]):
        self.n = other.n
        self.j = other.j
        self.a = other.a

    fn __copyinit__(inout self, other: List[T]):
        self.n = other.n
        self.j = other.j
        self.a = other.a

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
        let length = max(1, self.n * 2)
        var b = InlinedFixedVector[T](length)
        for k in range(self.n):
            b[k] = self.a[(self.j + k) % self.a.capacity]
        self.a = b

    fn add(inout self, i: Int, x: T) raises:
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

    fn remove(inout self, i: Int) raises -> T:
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


struct Queue[T: AnyRegType = Int](Sized, Movable, Copyable, CollectionElement):
    var n: Int
    var j: Int
    var a: InlinedFixedVector[T]

    fn __init__(inout self, n: Int = 0):
        self.n = n
        self.j = 0
        self.a = InlinedFixedVector[T](n)

    fn __moveinit__(inout self, owned other: Queue[T]):
        self.n = other.n
        self.j = other.j
        self.a = other.a

    fn __copyinit__(inout self, other: Queue[T]):
        self.n = other.n
        self.j = other.j
        self.a = other.a

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
        let length = max(1, self.n * 2)
        var b = InlinedFixedVector[T](length)
        for k in range(self.n):
            b[k] = self.a[(self.j + k) % self.a.capacity]
        self.a = b

    fn add(inout self, i: Int, x: T) raises:
        if self.n + 1 > self.a.capacity:
            self.resize()
        self.a[(self.j + self.n) % self.a.capacity] = x
        self.n += 1

    fn remove(inout self, i: Int) raises -> T:
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


struct Stack[T: AnyRegType = Int](Sized, Movable, Copyable, CollectionElement):
    var n: Int
    var a: InlinedFixedVector[T]

    fn __init__(inout self, n: Int = 0):
        self.n = n
        self.a = InlinedFixedVector[T](n)

    fn __moveinit__(inout self, owned other: Stack[T]):
        self.n = other.n
        self.a = other.a

    fn __copyinit__(inout self, other: Stack[T]):
        self.n = other.n
        self.a = other.a

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
        var b = InlinedFixedVector[T](len)
        for k in range(self.n):
            b[k] = self.a[k]
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

    fn push(inout self, x: T):
        if self.n + 1 > self.a.capacity:
            self.resize()
        self.a[self.n] = x
        self.n += 1

    fn pop(inout self) raises -> T:
        return self.remove(self.n - 1)