// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  USBCore.swift
//
//
//  Created by Emerah on 10/08/2024.
//

import Foundation
import Clibusb

// MARK: - Typealiases
public typealias LibusbDevice = OpaquePointer
public typealias LibusbHandle = OpaquePointer
public typealias LibusbContext = OpaquePointer
public typealias LibusbVersion = libusb_version
public typealias LibusbInitOption = libusb_init_option
public typealias LibusbOption = libusb_option
public typealias LibusbLogLevel = libusb_log_level
public typealias LibusbLogCallbackMode = libusb_log_cb_mode
public typealias LibusbControlSetup = libusb_control_setup
public typealias LibusbTransfer = libusb_transfer
public typealias LibusbTransferFlags = libusb_transfer_flags
public typealias LibusbTransferType = libusb_transfer_type
public typealias LibusbTransferStatus = libusb_transfer_status
public typealias LibusbEndpointDescriptor = libusb_endpoint_descriptor
public typealias LibusbInterfaceDescriptor = libusb_interface_descriptor
public typealias LibusbInterface = libusb_interface
public typealias LibusbConfigurationDescriptor = libusb_config_descriptor
public typealias LibusbDeviceDescriptor = libusb_device_descriptor
public typealias LibusbInterfaceAssociationDescriptor = libusb_interface_association_descriptor
public typealias LibusbInterfaceAssociationDescriptorArray = libusb_interface_association_descriptor_array
public typealias LibusbClassCode = libusb_class_code
public typealias LibusbPlatformDescriptor = libusb_platform_descriptor
public typealias LibusbDescriptorType = libusb_descriptor_type
public typealias LibusbEndpointDirection = libusb_endpoint_direction
public typealias LibusbEndpointTransferType = libusb_endpoint_transfer_type
public typealias LibusbSupportedSpeed = libusb_supported_speed
public typealias LibusbStandardRequest = libusb_standard_request
public typealias LibusbRequestType = libusb_request_type
public typealias LibusbRequestRecipient = libusb_request_recipient
public typealias LibusbError = libusb_error
public typealias LibusbCapability = libusb_capability
public typealias LibusbHotplugEvent = libusb_hotplug_event
public typealias LibusbHotplugFlag = libusb_hotplug_flag
public typealias LibusbHotplugCallbackHandle = libusb_hotplug_callback_handle
public typealias LibusbPollFileDescriptor = libusb_pollfd
public typealias LibusbSpeed = libusb_speed

// MARK: - Callbacks
public typealias LibusbLogCallback = @convention(c) (LibusbContext?, LibusbLogLevel, UnsafePointer<CChar>?) -> Void
public typealias LibusbTransferCallback = @convention(c) (UnsafeMutablePointer<LibusbTransfer>?) -> Void
public typealias LibusbHotplugCallback = @convention(c) (LibusbContext?, LibusbDevice?, LibusbHotplugEvent, UnsafeMutableRawPointer?) -> Int32
public typealias LibusbPollFileDescriptorAddedCallback = @convention(c) (Int32, Int16, UnsafeMutableRawPointer?) -> Void
public typealias LibusbPollFileDescriptorRemovedCallback = @convention(c) (Int32, UnsafeMutableRawPointer?) -> Void

// MARK: - Library constants and flags

public struct Constants {
    // log level options
    public static let LOG_LEVEL_NONE = LIBUSB_LOG_LEVEL_NONE.rawValue // (0) : No messages ever emitted by the library (default)
    public static let LOG_LEVEL_ERROR = LIBUSB_LOG_LEVEL_ERROR.rawValue // (1) : Error messages are emitted
    public static let LOG_LEVEL_WARNING = LIBUSB_LOG_LEVEL_WARNING.rawValue // (2) : Warning and error messages are emitted
    public static let LOG_LEVEL_INFO = LIBUSB_LOG_LEVEL_INFO.rawValue // (3) : Informational, warning and error messages are emitted
    public static let LOG_LEVEL_DEBUG = LIBUSB_LOG_LEVEL_DEBUG.rawValue // (4) : All messages are emitted
    
    // log calback mode
    public static let LOG_CALLBACK_GLOBAL = LIBUSB_LOG_CB_GLOBAL.rawValue // Callback function handling all log messages.
    public static let LOG_CALLBACK_CONTEXT_SPECIFIC = LIBUSB_LOG_CB_CONTEXT.rawValue // Callback function handling context related log messages.
    
    // library options [see online doc]
    public static let OPTION_LOG_LEVEL = LIBUSB_OPTION_LOG_LEVEL.rawValue
    public static let OPTION_USE_USBDK = LIBUSB_OPTION_USE_USBDK.rawValue
    public static let OPTION_NO_DEVICE_DISCOVERY = LIBUSB_OPTION_NO_DEVICE_DISCOVERY.rawValue
    public static let OPTION_LOG_CALLBACK = LIBUSB_OPTION_LOG_CB.rawValue
    
    // device speed
    public static let SPEED_UNKNOWN = LIBUSB_SPEED_UNKNOWN.rawValue // The OS doesn't report or know the device speed.
    public static let SPEED_LOW = LIBUSB_SPEED_LOW.rawValue // The device is operating at low speed (1.5MBit/s).
    public static let SPEED_FULL = LIBUSB_SPEED_FULL.rawValue // The device is operating at full speed (12MBit/s).
    public static let SPEED_HIGH  = LIBUSB_SPEED_HIGH.rawValue // The device is operating at high speed (480MBit/s).
    public static let SPEED_SUPER = LIBUSB_SPEED_SUPER.rawValue // The device is operating at super speed (5000MBit/s).
    public static let SPEED_SUPER_PLUS = LIBUSB_SPEED_SUPER_PLUS.rawValue // The device is operating at super speed plus (10000MBit/s).
    
    // usb standard request
    public static let REQUEST_GET_STATUS = LIBUSB_REQUEST_GET_STATUS.rawValue // Request status of the specific recipient.
    public static let REQUEST_CLEAR_FEATURE = LIBUSB_REQUEST_CLEAR_FEATURE.rawValue // Clear or disable a specific feature.
    public static let REQUEST_SET_FEATURE = LIBUSB_REQUEST_SET_FEATURE.rawValue // Set or enable a specific feature.
    public static let REQUEST_SET_ADDRESS = LIBUSB_REQUEST_SET_ADDRESS.rawValue // Set device address for all future accesses.
    public static let REQUEST_GET_DESCRIPTOR = LIBUSB_REQUEST_GET_DESCRIPTOR.rawValue // Get the specified descriptor.
    public static let REQUEST_SET_DESCRIPTOR = LIBUSB_REQUEST_SET_DESCRIPTOR.rawValue // Used to update existing descriptors or add new descriptors.
    public static let REQUEST_GET_CONFIGURATION = LIBUSB_REQUEST_GET_CONFIGURATION.rawValue // Get the current device configuration value.
    public static let REQUEST_SET_CONFIGURATION = LIBUSB_REQUEST_SET_CONFIGURATION.rawValue // Set device configuration.
    public static let REQUEST_GET_INTERFACE = LIBUSB_REQUEST_GET_INTERFACE // Return the selected alternate setting for the specified interface.
    public static let REQUEST_SET_INTERFACE = LIBUSB_REQUEST_SET_INTERFACE.rawValue // Select an alternate interface for the specified interface.
    public static let REQUEST_SYNCH_FRAME = LIBUSB_REQUEST_SYNCH_FRAME.rawValue // Set then report an endpoint's synchronization frame.
    public static let REQUEST_SET_SEL = LIBUSB_REQUEST_SET_SEL.rawValue // Sets both the U1 and U2 Exit Latency.
    public static let SET_ISOCH_DELAY = LIBUSB_SET_ISOCH_DELAY.rawValue // Delay from the time a host transmits a packet to the time it is received by the device.
    
    // request type
    public static let REQUEST_TYPE_STANDARD = LIBUSB_REQUEST_TYPE_STANDARD.rawValue // Standard.
    public static let REQUEST_TYPE_CLASS = LIBUSB_REQUEST_TYPE_CLASS.rawValue // Class.
    public static let REQUEST_TYPE_VENDOR = LIBUSB_REQUEST_TYPE_VENDOR.rawValue // Vendor.
    public static let REQUEST_TYPE_RESERVED = LIBUSB_REQUEST_TYPE_RESERVED.rawValue // Reserved.
    
    // request recipient
    public static let RECIPIENT_DEVICE = LIBUSB_RECIPIENT_DEVICE.rawValue // Device.
    public static let RECIPIENT_INTERFACE = LIBUSB_RECIPIENT_INTERFACE.rawValue // Interface.
    public static let RECIPIENT_ENDPOINT = LIBUSB_RECIPIENT_ENDPOINT.rawValue // Endpoint.
    public static let RECIPIENT_OTHER = LIBUSB_RECIPIENT_OTHER.rawValue // Other.
    
    // error codes
    public static let SUCCESS = LIBUSB_SUCCESS.rawValue // Success (no error)
    public static let ERROR_IO = LIBUSB_ERROR_IO.rawValue // Input/output error.
    public static let ERROR_INVALID_PARAM = LIBUSB_ERROR_INVALID_PARAM.rawValue // Invalid parameter.
    public static let ERROR_ACCESS = LIBUSB_ERROR_ACCESS.rawValue // Access denied (insufficient permissions)
    public static let ERROR_NO_DEVICE = LIBUSB_ERROR_NO_DEVICE.rawValue // No such device (it may have been disconnected)
    public static let ERROR_NOT_FOUND = LIBUSB_ERROR_NOT_FOUND.rawValue // Entity not found.
    public static let ERROR_BUSY = LIBUSB_ERROR_BUSY.rawValue // Resource busy.
    public static let ERROR_TIMEOUT = LIBUSB_ERROR_TIMEOUT.rawValue // Operation timed out.
    public static let ERROR_OVERFLOW = LIBUSB_ERROR_OVERFLOW.rawValue // Overflow.
    public static let ERROR_PIPE = LIBUSB_ERROR_PIPE // Pipe error.
    public static let ERROR_INTERRUPTED = LIBUSB_ERROR_INTERRUPTED.rawValue // System call interrupted (perhaps due to signal)
    public static let ERROR_NO_MEM = LIBUSB_ERROR_NO_MEM.rawValue // Insufficient memory.
    public static let ERROR_NOT_SUPPORTED = LIBUSB_ERROR_NOT_SUPPORTED.rawValue // Operation not supported or unimplemented on this platform.
    public static let ERROR_OTHER = LIBUSB_ERROR_OTHER.rawValue // Other error.
    
    // library capabilities
    public static let CAP_HAS_CAPABILITY = LIBUSB_CAP_HAS_CAPABILITY.rawValue // The libusb_has_capability() API is available.
    public static let CAP_HAS_HOTPLUG = LIBUSB_CAP_HAS_HOTPLUG.rawValue // Hotplug support is available on this platform.
    // The library can access HID devices without requiring user intervention.
    // Note that before being able to actually access an HID device,
    // you may still have to call additional libusb functions such as libusb_detach_kernel_driver().
    public static let CAP_HAS_HID_ACCESS = LIBUSB_CAP_HAS_HID_ACCESS.rawValue
    public static let CAP_SUPPORTS_DETACH_KERNEL_DRIVER = LIBUSB_CAP_SUPPORTS_DETACH_KERNEL_DRIVER.rawValue // The library supports detaching of the default USB driver, using libusb_detach_kernel_driver(), if one is set by the OS kernel.
    
    // class code
    // In the context of a device descriptor, this bDeviceClass value indicates that
    // each interface specifies its own class information and all interfaces operate independently.
    public static let CLASS_PER_INTERFACE = LIBUSB_CLASS_PER_INTERFACE.rawValue
    public static let CLASS_AUDIO = LIBUSB_CLASS_AUDIO.rawValue // Audio class.
    public static let CLASS_COMM = LIBUSB_CLASS_COMM.rawValue // Communications class.
    public static let CLASS_HID = LIBUSB_CLASS_HID.rawValue // Human Interface Device class.
    public static let CLASS_PHYSICAL = LIBUSB_CLASS_PHYSICAL.rawValue // Physical.
    public static let CLASS_IMAGE = LIBUSB_CLASS_IMAGE.rawValue //Image class.
    public static let CLASS_PRINTER = LIBUSB_CLASS_PRINTER.rawValue //Printer class.
    public static let CLASS_MASS_STORAGE = LIBUSB_CLASS_MASS_STORAGE.rawValue //Mass storage class.
    public static let CLASS_HUB = LIBUSB_CLASS_HUB.rawValue // Hub class.
    public static let CLASS_DATA = LIBUSB_CLASS_DATA.rawValue // Data class.
    public static let CLASS_SMART_CARD = LIBUSB_CLASS_SMART_CARD.rawValue // Smart Card.
    public static let CLASS_CONTENT_SECURITY = LIBUSB_CLASS_CONTENT_SECURITY.rawValue //Content Security.
    public static let CLASS_VIDEO = LIBUSB_CLASS_VIDEO.rawValue // Video.
    public static let CLASS_PERSONAL_HEALTHCARE = LIBUSB_CLASS_PERSONAL_HEALTHCARE.rawValue // Personal Healthcare.
    public static let CLASS_DIAGNOSTIC_DEVICE = LIBUSB_CLASS_DIAGNOSTIC_DEVICE.rawValue // Diagnostic Device.
    public static let CLASS_WIRELESS = LIBUSB_CLASS_WIRELESS.rawValue // Wireless class.
    public static let CLASS_MISCELLANEOUS = LIBUSB_CLASS_MISCELLANEOUS.rawValue // Miscellaneous class.
    public static let CLASS_APPLICATION = LIBUSB_CLASS_APPLICATION.rawValue // Application class.
    public static let CLASS_VENDOR_SPEC = LIBUSB_CLASS_VENDOR_SPEC.rawValue // Class is vendor-specific.
    
    // descriptor type
    public static let DT_DEVICE = LIBUSB_DT_DEVICE.rawValue // Device descriptor. See libusb_device_descriptor.
    public static let DT_CONFIG = LIBUSB_DT_CONFIG.rawValue // Configuration descriptor. See libusb_config_descriptor.
    public static let DT_STRING = LIBUSB_DT_STRING.rawValue // String descriptor.
    public static let DT_INTERFACE = LIBUSB_DT_INTERFACE.rawValue // Interface descriptor. See libusb_interface_descriptor.
    public static let DT_ENDPOINT = LIBUSB_DT_ENDPOINT.rawValue // Endpoint descriptor. See libusb_endpoint_descriptor.
    public static let DT_INTERFACE_ASSOCIATION = LIBUSB_DT_INTERFACE_ASSOCIATION.rawValue //Interface Association Descriptor. See libusb_interface_association_descriptor
    public static let DT_BOS = LIBUSB_DT_BOS.rawValue //BOS descriptor.
    public static let DT_DEVICE_CAPABILITY = LIBUSB_DT_DEVICE_CAPABILITY.rawValue //Device Capability descriptor.
    public static let DT_HID = LIBUSB_DT_HID.rawValue // HID descriptor.
    public static let DT_REPORT = LIBUSB_DT_REPORT.rawValue // HID report descriptor.
    public static let DT_PHYSICAL = LIBUSB_DT_PHYSICAL.rawValue // Physical descriptor.
    public static let DT_HUB = LIBUSB_DT_HUB.rawValue // Hub descriptor.
    public static let DT_SUPERSPEED_HUB = LIBUSB_DT_SUPERSPEED_HUB.rawValue // SuperSpeed Hub descriptor.
    public static let DT_SS_ENDPOINT_COMPANION = LIBUSB_DT_SS_ENDPOINT_COMPANION.rawValue // SuperSpeed Endpoint Companion descriptor.
    
    // endpoint direction
    public static let ENDPOINT_OUT = LIBUSB_ENDPOINT_OUT.rawValue //Out: host-to-device.
    public static let ENDPOINT_IN = LIBUSB_ENDPOINT_IN.rawValue // In: device-to-host.
    
    // endpoint transfer type
    public static let ENDPOINT_TRANSFER_TYPE_CONTROL = LIBUSB_ENDPOINT_TRANSFER_TYPE_CONTROL.rawValue // Control endpoint.
    public static let ENDPOINT_TRANSFER_TYPE_ISOCHRONOUS = LIBUSB_ENDPOINT_TRANSFER_TYPE_ISOCHRONOUS.rawValue // Isochronous endpoint.
    public static let ENDPOINT_TRANSFER_TYPE_BULK = LIBUSB_ENDPOINT_TRANSFER_TYPE_BULK.rawValue // Bulk endpoint.
    public static let ENDPOINT_TRANSFER_TYPE_INTERRUPT = LIBUSB_ENDPOINT_TRANSFER_TYPE_INTERRUPT.rawValue // Interrupt endpoint.
    
    // iso sync type
    public static let ISO_SYNC_TYPE_NONE = LIBUSB_ISO_SYNC_TYPE_NONE.rawValue // No synchronization.
    public static let ISO_SYNC_TYPE_ASYNC = LIBUSB_ISO_SYNC_TYPE_ASYNC.rawValue // Asynchronous.
    public static let ISO_SYNC_TYPE_ADAPTIVE = LIBUSB_ISO_SYNC_TYPE_ADAPTIVE.rawValue // Adaptive.
    public static let ISO_SYNC_TYPE_SYNC = LIBUSB_ISO_SYNC_TYPE_SYNC.rawValue //
    // iso usage type
    public static let ISO_USAGE_TYPE_DATA = LIBUSB_ISO_USAGE_TYPE_DATA.rawValue // Data endpoint.
    public static let ISO_USAGE_TYPE_FEEDBACK = LIBUSB_ISO_USAGE_TYPE_FEEDBACK.rawValue // Feedback endpoint.
    public static let ISO_USAGE_TYPE_IMPLICIT = LIBUSB_ISO_USAGE_TYPE_IMPLICIT.rawValue // Implicit feedback Data endpoint.
    
    // hotplug event
    public static let HOTPLUG_EVENT_DEVICE_ARRIVED = LIBUSB_HOTPLUG_EVENT_DEVICE_ARRIVED.rawValue // A device has been plugged in and is ready to use.
    // A device has left and is no longer available.
    // It is the user's responsibility to call libusb_close on any handle associated with a disconnected device.
    // It is safe to call libusb_get_device_descriptor on a device that has left
    public static let HOTPLUG_EVENT_DEVICE_LEFT = LIBUSB_HOTPLUG_EVENT_DEVICE_LEFT.rawValue
    
    // hotplug flag
    public static let HOTPLUG_ENUMERATE = LIBUSB_HOTPLUG_ENUMERATE.rawValue // Arm the callback and fire it for all matching currently attached device
    
    // transfer type
    public static let TRANSFER_TYPE_CONTROL = LIBUSB_TRANSFER_TYPE_CONTROL.rawValue // Control transfer.
    public static let TRANSFER_TYPE_ISOCHRONOUS = LIBUSB_TRANSFER_TYPE_ISOCHRONOUS.rawValue // Isochronous transfer.
    public static let TRANSFER_TYPE_BULK = LIBUSB_TRANSFER_TYPE_BULK.rawValue // Bulk transfer.
    public static let TRANSFER_TYPE_INTERRUPT = LIBUSB_TRANSFER_TYPE_INTERRUPT.rawValue // Interrupt transfer.
    public static let TRANSFER_TYPE_BULK_STREAM = LIBUSB_TRANSFER_TYPE_BULK_STREAM.rawValue // Bulk stream transfer.
    
    
    // transfer status
    // Transfer completed without error. Note that this does not indicate that the entire amount of requested data was transferred.
    public static let TRANSFER_COMPLETED = LIBUSB_TRANSFER_COMPLETED.rawValue
    public static let TRANSFER_ERROR = LIBUSB_TRANSFER_ERROR.rawValue // Transfer failed.
    public static let TRANSFER_TIMED_OUT = LIBUSB_TRANSFER_TIMED_OUT.rawValue // Transfer timed out.
    public static let TRANSFER_CANCELLED = LIBUSB_TRANSFER_CANCELLED.rawValue // Transfer was cancelled.
    // For bulk/interrupt endpoints: halt condition detected (endpoint stalled). For control endpoints: control request not supported.
    public static let TRANSFER_STALL = LIBUSB_TRANSFER_STALL.rawValue
    public static let TRANSFER_NO_DEVICE = LIBUSB_TRANSFER_NO_DEVICE.rawValue // Device was disconnected.
    public static let TRANSFER_OVERFLOW = LIBUSB_TRANSFER_OVERFLOW.rawValue // Device sent more data than requested.
    
    // transfer flags
    public static let TRANSFER_SHORT_NOT_OK = LIBUSB_TRANSFER_SHORT_NOT_OK.rawValue // Report short frames as errors.
    // Automatically free() transfer buffer during libusb_free_transfer().
    // Note that buffers allocated with libusb_dev_mem_alloc() should not be attempted freed in this way,
    // since free() is not an appropriate way to release such memory.
    public static let TRANSFER_FREE_BUFFER = LIBUSB_TRANSFER_FREE_BUFFER.rawValue
    // Automatically call libusb_free_transfer() after callback returns.
    // If this flag is set, it is illegal to call libusb_free_transfer() from your transfer callback,
    // as this will result in a double-free when this flag is acted upon.
    public static let TRANSFER_FREE_TRANSFER = LIBUSB_TRANSFER_FREE_TRANSFER.rawValue
    // Terminate transfers that are a multiple of the endpoint's wMaxPacketSize with an extra zero length packet.
    public static let TRANSFER_ADD_ZERO_PACKET = LIBUSB_TRANSFER_ADD_ZERO_PACKET.rawValue
    
    // defaults
    public static let DEFAULT_TIMEOUT = UInt32(1000) // MEASURED IN MS
}

// MARK: -  Library initialization/deinitialization
public func libusbInit(_ context: UnsafeMutablePointer<LibusbContext?>?, options: UnsafePointer<LibusbInitOption>?, numOptions: Int32) -> Int32 {
    return libusb_init_context(context, options, numOptions)
}


public func libusbExit(_ context: LibusbContext?) {
    libusb_exit(context)
}


public func libusbSetOptions(_ context: LibusbContext?, option: LibusbOption, value: Int32) -> Int32 {
    return libusb_set_options(context, .init(option.rawValue), value)
}


public func libusbSetLogOption(_ context: LibusbContext?, level: LibusbLogLevel) -> Int32 {
    return libusb_set_log_level(context, level)
}


public func libusbSetLogCallback(_ context: LibusbContext?, callbackMode: LibusbLogCallbackMode, callback: LibusbLogCallback) {
    libusb_set_log_cb(context, callback, Int32(callbackMode.rawValue))
}


// MARK: - Device handling and enumeration
public func libusbGetDeviceList(_ context: LibusbContext?, list: UnsafeMutablePointer<UnsafeMutablePointer<LibusbDevice?>?>?) -> Int {
    return libusb_get_device_list(context, list)
}


public func libusbFreeDeviceList(_ list: UnsafeMutablePointer<LibusbDevice?>?, unreferenceDevices: Bool) {
    libusb_free_device_list(list, unreferenceDevices ? 1 : 0)
}


public func libusbGetBusNumber(_ device: LibusbDevice?) -> UInt8 {
    return libusb_get_bus_number(device)
}


public func libusbGetPortNumber(_ device: LibusbDevice?) -> UInt8 {
    return libusb_get_port_number(device)
}


public func libusbGetPortNumbers(_ device: LibusbDevice?, portNumbers: UnsafeMutablePointer<UInt8>?, portNumbersLength: Int32) -> Int32 {
    return libusb_get_port_numbers(device, portNumbers, portNumbersLength)
}


public func libusbGetParent(_ device: LibusbDevice?) -> LibusbDevice? {
    return libusb_get_parent(device)
}


public func libusbGetDeviceAddress(_ device: LibusbDevice?) -> UInt8 {
    return libusb_get_device_address(device)
}


public func libusbGetDeviceSpeed(_ device: LibusbDevice?) -> LibusbSpeed {
    let speed = libusb_get_device_speed(device)
    return LibusbSpeed(rawValue: UInt32(speed))
}


public func libusbGetMaxPacketSize(_ device: LibusbDevice?, endpoint: UInt8) -> Int32 {
    return libusb_get_max_packet_size(device, endpoint)
}


public func libusbGetMaxISOPacketSize(_ device: LibusbDevice?, endpoint: UInt8) -> Int32 {
    return libusb_get_max_iso_packet_size(device, endpoint)
}


public func libusbgetMaxALTPacketSize(_ device: LibusbDevice?, interfaceNumber: Int32, altSetting: Int32, endpoint: UInt8) -> Int32 {
    return libusb_get_max_alt_packet_size(device, interfaceNumber, altSetting, endpoint)
}


public func libusbReferenceDevice(_ device: LibusbDevice?) -> LibusbDevice! {
    return libusb_ref_device(device)
}


public func libusbUnreferenceDevice(_ device: LibusbDevice?) {
    libusb_unref_device(device)
}


public func libusbWrapSystemDevice(_ context: LibusbContext?, systemDevice: Int, handle: UnsafeMutablePointer<LibusbHandle?>?) -> Int32 {
    return libusb_wrap_sys_device(context, systemDevice, handle)
}


public func libusbOpenDevice(_ device: LibusbDevice?, handle: UnsafeMutablePointer<LibusbHandle?>?) -> Int32 {
    return libusb_open(device, handle)
}


public func libusbOpenDeviceWithVidPid(_ context: LibusbContext?, vid: UInt16, pid: UInt16) -> LibusbHandle? {
    return libusb_open_device_with_vid_pid(context, vid, pid)
}


public func libusbClose(handle: LibusbHandle?) {
    libusb_close(handle)
}


public func libusbGetDevice(_ handle: LibusbHandle?) -> LibusbDevice? {
    return libusb_get_device(handle)
}


public func libusbGetConfiguration(_ handle: LibusbHandle?, configurationValue: UnsafeMutablePointer<Int32>?) -> Int32 {
    return libusb_get_configuration(handle, configurationValue)
}


public func libusbSetConfiguration(_ handle: LibusbHandle?, configurationValue: Int32) -> Int32 {
    return libusb_set_configuration(handle, configurationValue)
}


public func libusbClaimInterface(handle: LibusbHandle?, interfaceNumber: Int32) -> Int32 {
    return libusb_claim_interface(handle, interfaceNumber)
}


public func libusbReleaseInterface(handle: LibusbHandle?, interfaceNumber: Int32) -> Int32 {
    return libusb_release_interface(handle, interfaceNumber)
}


public func libusbSetInterfaceAltSetting(handle: LibusbHandle?, interfaceNumber: Int32, altSetting: Int32) -> Int32 {
    return libusb_set_interface_alt_setting(handle, interfaceNumber, altSetting)
}


public func libusbClearHalt(handle: LibusbHandle?, endpoint: UInt8) -> Int32 {
    return libusb_clear_halt(handle, endpoint)
}


public func libusbResetDevice(handle: LibusbHandle?) -> Int32{
    return libusb_reset_device(handle)
}


public func libusbKernelDriverActive(handle: LibusbHandle?, interfaceNumber: Int32) -> Bool {
    return libusb_kernel_driver_active(handle, interfaceNumber) == 0 ? false : true
}


public func libusbDetachKernelDriver(handle: LibusbHandle?, interfaceNumber: Int32) -> Int32 {
    return libusb_detach_kernel_driver(handle, interfaceNumber)
}


public func libusbAttachKernelDrivers(handle: LibusbHandle?, interfaceNumber: Int32) -> Int32 {
    return libusb_attach_kernel_driver(handle, interfaceNumber)
}


public func libusbSetAutoDetachKernelDriver(handle: LibusbHandle?, enable: Bool) -> Int32 {
    return libusb_set_auto_detach_kernel_driver(handle, enable ? 1 : 0)
}


// MARK: - Synchronous device I/O
public func libusbControlTransfer(handle: LibusbHandle?, requestType: UInt8, request: UInt8, wValue: UInt16, wIndex: UInt16, data: UnsafeMutablePointer<UInt8>?, wLength: UInt16, timeout: UInt32 = Constants.DEFAULT_TIMEOUT) -> Int32 {
    return libusb_control_transfer(handle, requestType, request, wValue, wIndex, data, wLength, timeout)
}


public func libusbBulkTransfer(handle: LibusbHandle?, endpoint: UInt8, data: UnsafeMutablePointer<UInt8>?, length: Int32, actualLength: UnsafeMutablePointer<Int32>?, timeout: UInt32 = Constants.DEFAULT_TIMEOUT) -> Int32 {
    return libusb_bulk_transfer(handle, endpoint, data, length, actualLength, timeout)
}


public func libusbInterruptTransfer(handle: LibusbHandle!, endpoint: UInt8, data: UnsafeMutablePointer<UInt8>?, length: Int32, actualLength: UnsafeMutablePointer<Int32>?, timeout: UInt32 = Constants.DEFAULT_TIMEOUT) -> Int32 {
    return libusb_interrupt_transfer(handle, endpoint, data, length, actualLength, timeout)
}


// MARK: - Asynchronous device I/O
public func libusbAllocateStreams(handle: LibusbHandle?, numStreams: UInt32, endpoints: UnsafeMutablePointer<UInt8>?, numEndpoints: Int32) -> Int32 {
    return libusb_alloc_streams(handle, numStreams, endpoints, numEndpoints)
}


public func libusbFreeStream(handle: LibusbHandle?, endpoints: UnsafeMutablePointer<UInt8>?, numEndpoints: Int32) -> Int32 {
    return libusb_free_streams(handle, endpoints, numEndpoints)
}


public func libusbAllocateDeviceMemory(handle: LibusbHandle?, length: Int) -> UnsafeMutablePointer<UInt8>? {
    return libusb_dev_mem_alloc(handle, length)
}


public func libusbFreeDeviceMemory(handle: LibusbHandle?, buffer: UnsafeMutablePointer<UInt8>?, length: Int) -> Int32 {
    return libusb_dev_mem_free(handle, buffer, length)
}


public func libusbAllocateTransfer(numIsoPackets: Int32) -> UnsafeMutablePointer<LibusbTransfer>? {
    return libusb_alloc_transfer(numIsoPackets)
}


public func libusbFreeTransfer(_ transfer: UnsafeMutablePointer<LibusbTransfer>?) {
    libusb_free_transfer(transfer)
}


public func libusbSubmitTransfer(transfer: UnsafeMutablePointer<LibusbTransfer>?) -> Int32 {
    return libusb_submit_transfer(transfer)
}


public func libusbCancelTransfer(transfer: UnsafeMutablePointer<LibusbTransfer>?) -> Int32 {
    return libusb_cancel_transfer(transfer)
}


public func libusbTransferGetStreamID(transfer: UnsafeMutablePointer<LibusbTransfer>?) -> UInt32 {
    return libusb_transfer_get_stream_id(transfer)
}


public func libusbTransferSetStreamID(transfer: UnsafeMutablePointer<LibusbTransfer>?, streamID: UInt32) {
    libusb_transfer_set_stream_id(transfer, streamID)
}


public func libusbControlTransferGetData(transfer: UnsafeMutablePointer<LibusbTransfer>?) -> UnsafeMutablePointer<UInt8>? {
    return libusb_control_transfer_get_data(transfer)
}


public func libusbControlTransferGetSetup(transfer: UnsafeMutablePointer<LibusbTransfer>?) -> UnsafeMutablePointer<LibusbControlSetup>? {
    return libusb_control_transfer_get_setup(transfer)
}


public func libusbFillControlSetup(buffer: UnsafeMutablePointer<UInt8>?, requestType: UInt8, request: UInt8, wValue: UInt16, wIndex: UInt16, wLength: UInt16) {
    libusb_fill_control_setup(buffer, requestType, request, wValue, wIndex, wLength)
}


public func libusbFillControlTransfer(transfer: UnsafeMutablePointer<LibusbTransfer>!, deviceHandle: LibusbHandle, buffer: UnsafeMutablePointer<UInt8>!, callback: LibusbTransferCallback?, userData: UnsafeMutableRawPointer?, timeout: UInt32 = Constants.DEFAULT_TIMEOUT) {
    libusb_fill_control_transfer(transfer, deviceHandle, buffer, callback, userData, timeout)
}


public func libusbFillBulkTransfer(transfer: UnsafeMutablePointer<LibusbTransfer>?, handle: LibusbHandle?, endpoint: UInt8, buffer: UnsafeMutablePointer<UInt8>?, length: Int32, callback: LibusbTransferCallback?, userData: UnsafeMutableRawPointer?, timeout: UInt32 = Constants.DEFAULT_TIMEOUT) {
    libusb_fill_bulk_transfer(transfer, handle, endpoint, buffer, length, callback, userData, timeout)
}


public func libusbFillInterruptTransfer(transfer: UnsafeMutablePointer<LibusbTransfer>?, handle: LibusbHandle?, endpoint: UInt8, buffer: UnsafeMutablePointer<UInt8>?, length: Int32, callback: LibusbTransferCallback?, userData: UnsafeMutableRawPointer?, timeout: UInt32 = Constants.DEFAULT_TIMEOUT) {
    libusb_fill_interrupt_transfer(transfer, handle, endpoint, buffer, length, callback, userData, timeout)
}


public func libusbFillIsoTransfer(transfer: UnsafeMutablePointer<LibusbTransfer>?, handle: LibusbHandle?, endpoint: UInt8, buffer: UnsafeMutablePointer<UInt8>?, length: Int32, numIsoPackets: Int32, callback: LibusbTransferCallback?, userData: UnsafeMutableRawPointer?, timeout: UInt32 = Constants.DEFAULT_TIMEOUT) {
    libusb_fill_iso_transfer(transfer, handle, endpoint, buffer, length, numIsoPackets, callback, userData, timeout)
}


public func libusbSetIsoPacketLengths(transfer: UnsafeMutablePointer<LibusbTransfer>?, length: UInt32) {
    libusb_set_iso_packet_lengths(transfer, length)
}


public func libusbGetIsoPacketBuffer(transfer: UnsafeMutablePointer<LibusbTransfer>?, packet: UInt32) -> UnsafeMutablePointer<UInt8>? {
    return libusb_get_iso_packet_buffer(transfer, packet)
}


public func libusbGetIsoPacketBufferSimple(transfer: UnsafeMutablePointer<LibusbTransfer>?, packet: UInt32) -> UnsafeMutablePointer<UInt8>? {
    libusb_get_iso_packet_buffer_simple(transfer, packet)
}


// MARK: - USB descriptors
public func libusbGetDeviceDescriptor(_ device: LibusbDevice?, descriptor: UnsafeMutablePointer<LibusbDeviceDescriptor>?) -> Int32 {
    return libusb_get_device_descriptor(device, descriptor)
}


public func libusbGetActiveConfigurationDescriptor(device: LibusbDevice?, configuration: UnsafeMutablePointer<UnsafeMutablePointer<LibusbConfigurationDescriptor>?>?) -> Int32 {
    return libusb_get_active_config_descriptor(device, configuration)
}


public func libusbGetConfigurationDescriptor(device: LibusbDevice?, configurationIndex: UInt8, configuration: UnsafeMutablePointer<UnsafeMutablePointer<LibusbConfigurationDescriptor>?>?) -> Int32 {
    return libusb_get_config_descriptor(device, configurationIndex, configuration)
}


public func libusbGetConfigurationDescriptorByValue(device: LibusbDevice?, configurationValue: UInt8, configuration: UnsafeMutablePointer<UnsafeMutablePointer<LibusbConfigurationDescriptor>?>?) -> Int32 {
    return libusb_get_config_descriptor_by_value(device, configurationValue, configuration)
}


public func libusbFreeConfigurationDescriptor(_ descriptor: UnsafeMutablePointer<LibusbConfigurationDescriptor>?) {
    libusb_free_config_descriptor(descriptor)
}


public func libusbGetPlatformDescriptor(_ context: LibusbContext, deviceCapability: UnsafeMutablePointer<libusb_bos_dev_capability_descriptor>?, platformDescriptor: UnsafeMutablePointer<UnsafeMutablePointer<LibusbPlatformDescriptor>?>?) -> Int32 {
    return libusb_get_platform_descriptor(context, deviceCapability, platformDescriptor)
}


public func libusbFreePlatformDescriptor(descriptor: UnsafeMutablePointer<LibusbPlatformDescriptor>?) {
    libusb_free_platform_descriptor(descriptor)
}


public func libusbGetStringDescriptorASCII(handle: LibusbHandle?, descriptorIndex: UInt8, data: UnsafeMutablePointer<UInt8>?, length: Int32) -> Int32 {
    return libusb_get_string_descriptor_ascii(handle, descriptorIndex, data, length)
}


public func libusbGetStringDescriptor(handle: LibusbHandle?, descriptorIndex: UInt8, languageID: UInt16, data: UnsafeMutablePointer<UInt8>?, length: Int32) -> Int32 {
    return libusb_get_string_descriptor(handle, descriptorIndex, languageID, data, length)
}


public func libusbGetDescriptor(handle: LibusbHandle?, descriptorType: UInt8, descriptorIndex: UInt8, data: UnsafeMutablePointer<UInt8>?, length: Int32) -> Int32 {
    return libusb_get_descriptor(handle, descriptorType, descriptorIndex, data, length)
}


// MARK: - Miscellaneous
public func libusbHasCapability(_ capability: UInt32) -> Int32 {
    return libusb_has_capability(capability)
}


public func libusbErrorName(_ errorCode: Int32) -> UnsafePointer<CChar>? {
    return libusb_error_name(errorCode)
}


public func libusbGetVersion() -> UnsafePointer<LibusbVersion>? {
    return libusb_get_version()
}


public func libusbStringError(_ errorCode: Int32) -> UnsafePointer<CChar>? {
    return libusb_strerror(errorCode)
}


// MARK: - Device hotplug event notification
public func libusbHotplugRegisterCallback(context: LibusbContext?, events: Int32, flags: Int32, vendorID: Int32, productID: Int32, deviceClass: Int32, callback: LibusbHotplugCallback, userData: UnsafeMutableRawPointer?, callbackHandle: UnsafeMutablePointer<LibusbHotplugCallbackHandle>?) -> Int32 {
    return libusb_hotplug_register_callback(context, events, flags, vendorID, productID, deviceClass, callback, userData, callbackHandle)
}


public func libusbHotplugDeregisterCallback(context: LibusbContext?, callbackHandle: LibusbHotplugCallbackHandle) {
    libusb_hotplug_deregister_callback(context, callbackHandle)
}


public func libusbHotplugGetUserData(context: LibusbContext?, callbackHandle: LibusbHotplugCallbackHandle) {
    libusb_hotplug_get_user_data(context, callbackHandle)
}


// MARK: - Polling and timing
public func libusbTryLockEvents(context: LibusbContext?) -> Int32 {
    return libusb_try_lock_events(context)
}


public func libusbLockEvents(context: LibusbContext?) {
    libusb_lock_events(context)
}


public func libusbUnlockEvents(context: LibusbContext?) {
    libusb_unlock_events(context)
}


public func libusbEventHandlingOk(context: LibusbContext?) -> Int32 {
    return libusb_event_handling_ok(context)
}


public func libusbEventHandlerActive(context: LibusbContext?) -> Int32 {
    return libusb_event_handler_active(context)
}


public func libusbInterruptEventHandler(context: LibusbContext?) {
    libusb_interrupt_event_handler(context)
}


public func libusbLockEventWaiters(context: LibusbContext?) {
    libusb_lock_event_waiters(context)
}


public func libusbUnlockEventWaiters(context: LibusbContext?) {
    libusb_unlock_event_waiters(context)
}


public func libusbWaitForEvent(context: LibusbContext?, timeValue: UnsafeMutablePointer<timeval>?) -> Int32 {
    return libusb_wait_for_event(context, timeValue)
}


public func libusbHandleEventsTimeoutCompleted(context: LibusbContext?, timeValue: UnsafeMutablePointer<timeval>?, completed: UnsafeMutablePointer<Int32>?) -> Int32 {
    return libusb_handle_events_timeout_completed(context, timeValue, completed)
}


public func libusbHandleEventsTimeout(context: LibusbContext?, timeValue: UnsafeMutablePointer<timeval>?) -> Int32 {
    return libusb_handle_events_timeout(context, timeValue)
}


public func libusbHandleEvents(context: LibusbContext?) -> Int32 {
    return libusb_handle_events(context)
}


public func libusbHandleEventsCompleted(context: LibusbContext?, completed: UnsafeMutablePointer<Int32>?) -> Int32 {
    return libusb_handle_events_completed(context, completed)
}


public func libusbHandleEventsLocked(context: LibusbContext?, timeValue: UnsafeMutablePointer<timeval>?) -> Int32 {
    return libusb_handle_events_locked(context, timeValue)
}


public func libusbPollFileDescriptorHandleTimeouts(context: LibusbContext?) -> Int32 {
    return libusb_pollfds_handle_timeouts(context)
}


public func libusbGetNextTimeout(context: LibusbContext?, timeValue: UnsafeMutablePointer<timeval>?) -> Int32 {
    return libusb_get_next_timeout(context, timeValue)
}


public func libusbSetPollFileDescriptorNotifiers(context: LibusbContext?, fileDescriptorAddedCallback: LibusbPollFileDescriptorAddedCallback, fileDescriptorRemovedCallback: LibusbPollFileDescriptorRemovedCallback, userData: UnsafeMutableRawPointer?) {
    libusb_set_pollfd_notifiers(context, fileDescriptorAddedCallback, fileDescriptorRemovedCallback, userData)
}


public func libusbGetPollFileDescriptors(context: LibusbContext?) ->  UnsafeMutablePointer<UnsafePointer<LibusbPollFileDescriptor>?>? {
    return libusb_get_pollfds(context)
}


public func libusbFreePollFileDescriptors(descriptors: UnsafeMutablePointer<UnsafePointer<LibusbPollFileDescriptor>?>?) {
    libusb_free_pollfds(descriptors)
}


///** Error handling
public func handlePossibleError(_ errorCode: Int32) {
    if errorCode != Constants.SUCCESS {
        fatalError("ERROR: \(String(cString: libusbStringError(errorCode)!).capitalized)")
    }
}
