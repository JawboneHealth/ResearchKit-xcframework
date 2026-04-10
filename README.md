# ResearchKit XCFramework (SPM)

Pre-built `ResearchKit.xcframework` distributed via Swift Package Manager.

[ResearchKit](https://github.com/ResearchKit/ResearchKit) does not natively support SPM. This repo builds the framework from upstream source and distributes it as a binary target.

## Installation

Add to your Xcode project via **File → Add Package Dependencies**:

```
https://github.com/JawboneHealth/ResearchKit-xcframework
```

Or add to `Package.swift`:

```swift
.package(url: "https://github.com/JawboneHealth/ResearchKit-xcframework", from: "3.2.0")
```

## Updating to a new ResearchKit version

```bash
./build-xcframework.sh 3.2.0    # specify upstream tag
git add Binary/ Package.swift
git commit -m "Update ResearchKit.xcframework to 3.2.0"
git tag 3.2.0
git push origin main --tags
```

## Version mapping

Tags in this repo match upstream [ResearchKit releases](https://github.com/ResearchKit/ResearchKit/tags).
