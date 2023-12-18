from Shared import IndexError

@value
@register_passable
struct Node[T: DType]:
    var data: SIMD[T, 1]
    var next: Pointer[Self]

fn main():
    let a = Node[DType.int64](1, Pointer[Node[DType.int64]].get_null())
    
    
    