## USBCore
importing this package to your Swift code will make C libusb functions available to your Swift code.

  - add this package as a dependency to your Xcode project
  - add import statement to the top of your file [**import Clibusb**]

### Platform:
development platform is macOS v14.
it should work on earlier versions of macOS >= v12 but I am running v14.

### Usage:
you can use the library functions inside your Swift code and it should look and feel natural because all function have been renamed to camelCase.

### Required
you must have libusb installed on your system

  [brew install libusb]



