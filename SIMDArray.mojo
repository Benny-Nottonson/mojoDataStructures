from Shared import IndexError
from math import max

"""
Can be implemented once traits support Parametric Types
trait Array[T: CollectionElement](Sized, Movable, Copyable, CollectionElement):
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

@value
struct List[T: DType](Sized, Movable, Copyable, CollectionElement):
    var n: Int
    var j: Int
    var a: SIMD[T]

    fn __getitem__(borrowed self, i: Int) raises -> SIMD[T, 1]:
        if i < 0 or i >= self.n:
            raise IndexError
        return self.a[(self.j + i) % len(self.a)]

    fn __setitem__(inout self, i: Int, x: SIMD[T, 1]) raises:
        if i < 0 or i >= self.n:
            raise IndexError
        self.a[(self.j + i) % len(self.a)] = x

    fn __len__(borrowed self) -> Int:
        return self.n

    fn resize(inout self):
        # Do this without max in case of negative values
        self.a = SIMD[T](max(1, self.n * 2)).splat(0).max(self.a)

    fn add(inout self, i: Int, x: SIMD[T, 1]) raises:
        if i < 0 or i > self.n:
            raise IndexError
        if self.n + 1 > len(self.a):
            self.resize()
        if i < self.n // 2:
            self.j = (self.j - 1) % len(self.a)
            for k in range(i):
                self.a[(self.j + k) % len(self.a)] = self.a[
                    (self.j + k + 1) % len(self.a)
                ]
        else:
            for k in range(self.n, i, -1):
                self.a[(self.j + k) % len(self.a)] = self.a[
                    (self.j + k - 1) % len(self.a)
                ]
        self.n += 1

    fn remove(inout self, i: Int) raises -> SIMD[T, 1]:
        if i < 0 or i >= self.n:
            raise IndexError
        let x = self.a[(self.j + i) % len(self.a)]
        if i < self.n // 2:
            for k in range(i, 0, -1):
                self.a[(self.j + k) % len(self.a)] = self.a[
                    (self.j + k - 1) % len(self.a)
                ]
            self.j = (self.j + 1) % len(self.a)
        else:
            for k in range(i, self.n - 1):
                self.a[(self.j + k) % len(self.a)] = self.a[
                    (self.j + k + 1) % len(self.a)
                ]
        self.n -= 1
        if len(self.a) >= 3 * self.n:
            self.resize()
        return x

    fn append(inout self, x: SIMD[T, 1]):
        if self.n + 1 > len(self.a):
            self.resize()
        self.a[(self.j + self.n) % len(self.a)] = x
        self.n += 1