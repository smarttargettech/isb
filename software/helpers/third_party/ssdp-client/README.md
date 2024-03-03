# MY OWN CHANGES IN README START
# I patched this project significantly to use it with WIFI Shield!!!!

To compile it and use with OpenBCI_GUI_Helpers run:
```
gradle build
```
And copy generated jar from build folder to third-party folder
# MY OWN CHANGES IN README END

# ssdp-client
Java client for discovering UPNP devices with [SSDP (Simple Service Discovery Protocol)](https://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol "SSDP Wikipedia Page")

## How to use it ?

For exemple, if you want to discover all SONOS devices on your network.

_(for information, Sonos Service Type: "urn:schemas-upnp-org:device:ZonePlayer:1")_

```java
public static void main(String[] args) throws IOException {
    List<Device> devices = SSDPClient.discover(1000, "urn:schemas-upnp-org:device:ZonePlayer:1");
    System.out.println(devices.size() + " sonos devices found");
}
```

## People

The current lead maintainer is [Valentin Michalak] (https://github.com/vmichalak)

## Licence

[MIT](LICENCE)