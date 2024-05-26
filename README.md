
# TableGrid

A custom grid-based layout to mimic `Table` in SwiftUI.

## Goals

- Provide more customization options vs. SwiftUI's macOS `Table` API
- Opaque styling, vs. `Grid`, which exposes individual views
  - (e.g., can't put a .background() on a GridRow without some [modifier tricks](https://gist.github.com/peterkos/91bbb501273c9f54ef5a4d5b3c7b1273))

## Example

```swift
// This is a work in progress!
TableGrid {
    TableGridHeader {
        Text("hello")
        Text("there")
    }
    TableGridRow {
        Text("one.one")
        Text("one.two")
    }
    TableGridRow {
        Text("two.one")
        Text("two.twoooooo")
    }
}
```
