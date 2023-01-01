# AlipaySDK-in-xcframework
 A xcframework based WechaSDK ***Support M1 simulator***

Using WechaSDK version: 2.0.0


## Background
The offical WechaSDK for IOS been built for 
- IOS
    - armv7
    - arm64
- IOS-Simulator
    - x86_64

&nbsp;&nbsp;On M1 machine, the simulator run with arm64 by default, in general cases, you may exclude arm64 on simulator run to avoid compile problems. but when you want develop react native probject, there is lot of dependencies require arm64 and not easy to change.

&nbsp;&nbsp;Simple idea was that use xcframework to include multiple platform libs, but it is not easy, since there is no ios-sim arm64 build for now.

&nbsp;&nbsp;If you trying to grab all single arch out, and merge like armv7+arm64 and arm64+x86_64, there will be an error "binaries with multiple platforms are not supported".

&nbsp;&nbsp;after seeking alot, I found one solution from https://github.com/bogo/arm64-to-sim, we could just hack the ios-arm64 to ios-sim-arm64, it solves my problem.

### prepare (mac machine)
```
git clone https://github.com/bogo/arm64-to-sim.git
cd arm64-to-sim
swift build -c release --arch arm64 --arch x86_64
cd .build/apple/Products/Release
sudo cp arm64-to-sim /usr/local/bin/
```


### to build the xcframework
```
source build.sh
```