from utils.vector import InlinedFixedVector
from math import log2, max

struct BinaryHeap[T: CollectionElement]:
    var data: DynamicVector[T]
    var n: Int

    fn __init__(inout self):
        self.data = DynamicVector[T](1)
        self.n = 0

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
        self.data[self.n] = x
        self.n += 1
        self.sift_up(self.n - 1)

    fn remove(inout self) -> T:
        self.n -= 1
        self._swap(0, self.n)
        self.sift_down(0)
        return self.data[self.n]

    fn _swap(inout self, i: Int, j: Int):
        let tmp = self.data[i]
        self.data[i] = self.data[j]
        self.data[j] = tmp

    fn sift_up(inout self, i: Int):
        if i == 0:
            return
        let p = self.parent(i)
        if self.data[i] < self.data[p]:
            self._swap(i, p)
            self.sift_up(p)