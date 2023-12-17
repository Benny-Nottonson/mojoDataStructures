from ArrayList import ArrayList
from ArrayStack import ArrayStack
from ArrayQueue import ArrayQueue

let builtInStructs = [
    Bool,
    ListLiteral,
    VariadicList,
    VariadicListMem,
    CoroutineContext,
    Coroutine,
    RaisingCoroutine,
    DType,
    Error,
    FileHandle,
    FloatLiteral,
    Int,
    IntLiteral,
    Attr,
    SIMD,
    String,
    StringLiteral,
    StringRef,
    Tuple,
    Buffer,
    AddressSpace,
    Pointer,
    AnyPointer,
    DTypePointer,
    Atomic,
    Path,
    PythonObject,
    Tensor,
    DimList,
    StaticIntTuple,
    StaticTuple,
    DynamicVector,
]

let builtInTraits = [
    Destructable,
    Intable,
    IntableRaising,
    Sized,
    SizedRaising,
    Stringable,
    StringableRaising,
    CollectionElement,
]

let customStructsComplete = [
    ArrayList,
    ArrayStack,
    ArrayQueue,
]

let customStructsIncomplete = [
    # BinaryHeap,
]

fn main():
    let a = ArrayQueue[DType.int16]()
    