from Shared import IndexError


@value
@register_passable
struct Node[T: DType]:
    var value: SIMD[T, 1]
    var next: Pointer[Node[T]]

