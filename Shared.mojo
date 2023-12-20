alias IndexError = Error("IndexError")

trait ComparableCollectionElement(CollectionElement):
    fn __eq__(self, other: Self) -> Bool:
        ...

    fn __ne__(self, other: Self) -> Bool:
        ...

    fn __lt__(self, other: Self) -> Bool:
        ...
    
    fn __gt__(self, other: Self) -> Bool:
        ...

    fn __le__(self, other: Self) -> Bool:
        ...

    fn __ge__(self, other: Self) -> Bool:
        ...