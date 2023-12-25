from Shared import IndexError
from collections.vector import UnsafeFixedVector
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
    var elements: Int
    var offset: Int
    var data: UnsafeFixedVector[T]

    fn __init__(inout self, n: Int = 0):
        self.elements = n
        self.offset = 0
        self.data = UnsafeFixedVector[T](n)

    fn __moveinit__(inout self, owned other: List[T]):
        self.elements = other.elements
        self.offset = other.offset
        self.data = other.data

    fn __copyinit__(inout self, other: List[T]):
        self.elements = other.elements
        self.offset = other.offset
        self.data = other.data

    fn __getitem__(borrowed self, i: Int) raises -> T:
        if i < 0 or i >= self.elements:
            raise IndexError
        return self.data[(self.offset + i) % self.data.capacity]

    fn __setitem__(inout self, i: Int, x: T) raises:
        if i < 0 or i >= self.elements:
            raise IndexError
        self.data[(self.offset + i) % self.data.capacity] = x

    fn __len__(borrowed self) -> Int:
        return self.elements

    fn resize(inout self):
        let length = max(1, self.elements * 2)
        let b = UnsafeFixedVector[T](length)
        for k in range(self.elements):
            b[k] = self.data[(self.offset + k) % self.data.capacity]
        self.data = b
        self.offset = 0

    fn add(inout self, i: Int, x: T) raises:
        if i < 0 or i > self.elements:
            raise IndexError
        if self.elements + 1 > self.data.capacity:
            self.resize()
        if i < self.elements // 2:
            self.offset = (self.offset - 1) % self.data.capacity
            for k in range(i):
                self.data[(self.offset + k) % self.data.capacity] = self.data[(self.offset + k + 1) % self.data.capacity]
        else:
            for k in range(self.elements, i, -1):
                self.data[(self.offset + k) % self.data.capacity] = self.data[(self.offset + k - 1) % self.data.capacity]
        self.data[(self.offset + i) % self.data.capacity] = x
        self.elements += 1

    fn remove(inout self, i: Int) raises -> T:
        if i < 0 or i >= self.elements:
            raise IndexError
        let x = self.data[(self.offset + i) % self.data.capacity]
        if i < self.elements // 2:
            for k in range(i, 0, -1):
                self.data[(self.offset + k) % self.data.capacity] = self.data[(self.offset + k - 1) % self.data.capacity]
            self.offset = (self.offset + 1) % self.data.capacity
        else:
            for k in range(i, self.elements - 1):
                self.data[(self.offset + k) % self.data.capacity] = self.data[(self.offset + k + 1) % self.data.capacity]
        self.elements -= 1
        if self.data.capacity >= 3 * self.elements:
            self.resize()
        return x
        
    fn append(inout self, x: T):
        if self.elements + 1 > self.data.capacity:
            self.resize()
        self.data[(self.offset + self.elements) % self.data.capacity] = x
        self.elements += 1


struct Queue[T: AnyRegType = Int](Sized, Movable, Copyable, CollectionElement):
    var elements: Int
    var offset: Int
    var data: UnsafeFixedVector[T]

    fn __init__(inout self, n: Int = 0):
        self.elements = n
        self.offset = 0
        self.data = UnsafeFixedVector[T](n)

    fn __moveinit__(inout self, owned other: Queue[T]):
        self.elements = other.elements
        self.offset = other.offset
        self.data = other.data

    fn __copyinit__(inout self, other: Queue[T]):
        self.elements = other.elements
        self.offset = other.offset
        self.data = other.data

    fn __getitem__(borrowed self, i: Int) raises -> T:
        if i < 0 or i >= self.elements:
            raise IndexError
        return self.data[(self.offset + i) % self.data.capacity]

    fn __setitem__(inout self, i: Int, x: T) raises:
        if i < 0 or i >= self.elements:
            raise IndexError
        self.data[(self.offset + i) % self.data.capacity] = x

    fn __len__(borrowed self) -> Int:
        return self.elements

    fn resize(inout self):
        let length = max(1, self.elements * 2)
        let b = UnsafeFixedVector[T](length)
        for k in range(self.elements):
            b[k] = self.data[(self.offset + k) % self.data.capacity]
        self.data = b
        self.offset = 0

    fn add(inout self, i: Int, x: T) raises:
        if self.elements + 1 > self.data.capacity:
            self.resize()
        self.data[(self.offset + self.elements) % self.data.capacity] = x
        self.elements += 1

    fn remove(inout self, i: Int) raises -> T:
        if self.elements == 0:
            raise IndexError
        let x = self.data[self.offset]
        self.offset = (self.offset + 1) % self.data.capacity
        self.elements -= 1
        if self.data.capacity >= 3 * self.elements:
            self.resize()
        return x

    fn append(inout self, x: T):
        if self.elements + 1 > self.data.capacity:
            self.resize()
        self.data[(self.offset + self.elements) % self.data.capacity] = x
        self.elements += 1


struct Stack[T: AnyRegType = Int](Sized, Movable, Copyable, CollectionElement):
    var elements: Int
    var data: UnsafeFixedVector[T]

    fn __init__(inout self, n: Int = 0):
        self.elements = n
        self.data = UnsafeFixedVector[T](n)

    fn __moveinit__(inout self, owned other: Stack[T]):
        self.elements = other.elements
        self.data = other.data

    fn __copyinit__(inout self, other: Stack[T]):
        self.elements = other.elements
        self.data = other.data

    fn __getitem__(borrowed self, i: Int) raises -> T:
        if i < 0 or i >= self.elements:
            raise IndexError
        return self.data[i]

    fn __setitem__(inout self, i: Int, x: T) raises:
        if i < 0 or i >= self.elements:
            raise IndexError
        self.data[i] = x

    fn __len__(borrowed self) -> Int:
        return self.elements

    fn resize(inout self):
        let length = max(1, self.elements * 2)
        let b = UnsafeFixedVector[T](length)
        for k in range(self.elements):
            b[k] = self.data[k]
        self.data = b

    fn add(inout self, i: Int, x: T) raises:
        if i < 0 or i > self.elements:
            raise IndexError
        if self.elements + 1 > self.data.capacity:
            self.resize()
        for k in range(self.elements, i, -1):
            self.data[k] = self.data[k - 1]
        self.data[i] = x
        self.elements += 1

    fn remove(inout self, i: Int) raises -> T:
        if i < 0 or i >= self.elements:
            raise IndexError
        let x = self.data[i]
        for k in range(i, self.elements - 1):
            self.data[k] = self.data[k + 1]
        self.elements -= 1
        if self.data.capacity >= 3 * self.elements:
            self.resize()
        return x

    fn push(inout self, x: T):
        if self.elements + 1 > self.data.capacity:
            self.resize()
        self.data[self.elements] = x
        self.elements += 1

    fn pop(inout self) raises -> T:
        if self.elements == 0:
            raise IndexError
        self.elements -= 1
        let x = self.data[self.elements]
        if self.data.capacity >= 3 * self.elements:
            self.resize()
        return x