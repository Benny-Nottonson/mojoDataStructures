struct Iterator[T: DType]:
    var storage: DTypePointer[T]
    var offset: Int
    var max: Int
    
    fn __init__(inout self, storage: DTypePointer[T], max: Int):
        self.offset = 0
        self.max = max
        self.storage = storage
    
    fn __len__(self) -> Int:
        return self.max - self.offset
    
    fn __next__(inout self) -> SIMD[T, 1]:
        let ret = self.storage.load(self.offset)
        self.offset += 1
        return ret