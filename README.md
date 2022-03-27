# Awake
A Wake-on-Lan library in Swift

### Usage:
```swift
let computer = Awake.Device(MAC: "AA:AA:AA:AA:AA:AA", BroadcastAddr: "255.255.255.255", Port: 9)
Awake.target(device: computer)
```
or
```swift
let computer = Awake.Device(MAC: "AA:AA:AA:AA:AA:AA", BroadcastAddr: "hoge.ddns.org", Port: 9)
Awake.target(device: computer)
```
***Don't forget to add bellow values to ".entitlements"***
| Key | Type | Value |
| ---- | ---- | ---- |
| com.apple.security.network.client | Boolean | YES or 1 |

## License
[MIT License](http://opensource.org/licenses/MIT)

## Author
Jesper Lindberg [@lindbergjesper](http://twitter.com/lindbergjesper/)