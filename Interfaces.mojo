trait Iterator:
    fn __next__(inout self):
        ...
    
    fn __iter__(inout self):
        ...

trait Sized:
    fn __len__(inout self):
        ...