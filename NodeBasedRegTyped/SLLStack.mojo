from Shared import IndexError


@value
@register_passable
struct Node[T: AnyRegType]:
    var value: T
    var next: Pointer[Self]


struct SLLStack[T: AnyRegType]:
    var head: Node[T]
    var tail: Node[T]
    var n: Int

