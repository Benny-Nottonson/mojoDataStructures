from Shared import IndexError, IdealCollectionElement
from math import log2, floor

# Will not work until CollectionElement has implemented comparison operators
# https://github.com/modularml/mojo/issues/1526

@value
struct BinaryHeap[T: IdealCollectionElement]:
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

    @staticmethod
    fn left(i: Int) -> Int:
        return 2 * i + 1

    @staticmethod
    fn right(i: Int) -> Int:
        return 2 * i + 2

    @staticmethod
    fn parent(i: Int) -> Int:
        return (i - 1) // 2

    fn add(inout self, x: T):
        if self.n == self.a.capacity:
            self.resize()
        self.a[self.n] = x
        self.n += 1
        self.sift_up(self.n - 1)

    fn remove(inout self) raises -> T:
        if self.n == 0:
            raise IndexError
        let x = self.a[0]
        self.n -= 1
        self.a[0] = self.a[self.n]
        self.sift_down(0)
        return x

    fn depth(borrowed self, u: T) -> Int:
        return self.depth_aux(0, u)

    fn depth_aux(borrowed self, i: Int, u: T) -> Int:
        if i >= self.n:
            return -1
        if self.a[i] == u:
            return 0
        let l = self.depth_aux(self.left(i), u)
        if l >= 0:
            return l + 1
        let r = self.depth_aux(self.right(i), u)
        if r >= 0:
            return r + 1
        return -1

    fn height(borrowed self) -> Int:
        return floor(log2[DType.int64, 1](self.n + 1)).value

    fn bf_order(borrowed self) raises -> DynamicVector[T]:
        if self.n == 0:
            raise IndexError
        return self.a

    fn in_order(borrowed self) raises -> DynamicVector[T]:
        if self.n == 0:
            raise IndexError
        let v = DynamicVector[T](self.n)
        self.in_order_aux(0, v)
        return v

    fn in_order_aux(borrowed self, i: Int, owned v: DynamicVector[T]) raises:
        if i >= self.n:
            return
        self.in_order_aux(self.left(i), v)
        v.append(self.a[i])
        self.in_order_aux(self.right(i), v)

    fn pre_order(borrowed self) raises -> DynamicVector[T]:
        if self.n == 0:
            raise IndexError
        let v = DynamicVector[T](self.n)
        self.pre_order_aux(0, v)
        return v

    fn pre_order_aux(borrowed self, i: Int, owned v: DynamicVector[T]) raises:
        if i >= self.n:
            return
        v.append(self.a[i])
        self.pre_order_aux(self.left(i), v)
        self.pre_order_aux(self.right(i), v)

    fn post_order(borrowed self) raises -> DynamicVector[T]:
        if self.n == 0:
            raise IndexError
        let v = DynamicVector[T](self.n)
        self.post_order_aux(0, v)
        return v

    fn post_order_aux(borrowed self, i: Int, owned v: DynamicVector[T]) raises:
        if i >= self.n:
            return
        self.post_order_aux(self.left(i), v)
        self.post_order_aux(self.right(i), v)
        v.append(self.a[i])

    fn sift_up(inout self, i: Int):
        let p = self.parent(i)
        if i > 0 and self.a[i] > self.a[p]:
            self.a[i], self.a[p] = self.a[p], self.a[i]
            self.sift_up(p)

    fn sift_down(inout self, i: Int):
        let l = self.left(i)
        let r = self.right(i)
        var m = i
        if l < self.n and self.a[l] > self.a[m]:
            m = l
        if r < self.n and self.a[r] > self.a[m]:
            m = r
        if m != i:
            self.a[i], self.a[m] = self.a[m], self.a[i]
            self.sift_down(m)

    fn resize(inout self):
        let b = DynamicVector[T](self.n * 2)
        for i in range(self.n):
            b[i] = self.a[i]
        self.a = b