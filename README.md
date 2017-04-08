# Awake
A Wake-on-Lan library in Swift

### Usage:
```swift
let computer = Awake.Device(MAC: "AA:AA:AA:AA:AA:AA", BroadcastAddr: "255.255.255.255", Port: 9)
Awake.target(device: computer)
```

## License
[MIT License](http://opensource.org/licenses/MIT)

## Author
Jesper Lindberg [@lindbergjesper](http://twitter.com/lindbergjesper/)
