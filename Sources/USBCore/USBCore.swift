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
public typealias LibusbDeviceDescriptor = libusb_device_descriptor
public typealias LibusbEndpointDescriptor = libusb_endpoint_descriptor
public typealias LibusbInterfaceAssociationDescriptor = libusb_interface_association_descriptor
public typealias LibusbInterfaceAssociationDescriptorArray = libusb_interface_association_descriptor_array
public typealias LibusbInterfaceDescriptor = libusb_interface_descriptor
public typealias LibusbInterface = libusb_interface
public typealias LibusbConfigurationDescriptor = libusb_config_descriptor
public typealias LibusbPlatformDescriptor = libusb_platform_descriptor
public typealias LibusbClassCode = libusb_class_code
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
public typealias LibusbHotplugCallback = @convention(c) (OpaquePointer?, OpaquePointer?, libusb_hotplug_event, UnsafeMutableRawPointer?) -> Int32
public typealias LibusbPollFileDescriptorAddedCallback = @convention(c) (Int32, Int16, UnsafeMutableRawPointer?) -> Void
public typealias LibusbPollFileDescriptorRemovedCallback = @convention(c) (Int32, UnsafeMutableRawPointer?) -> Void

// MARK: -  Library initialization/deinitialization
func libusbInit(_ context: UnsafeMutablePointer<LibusbContext?>?, options: UnsafePointer<LibusbInitOption>?, numOptions: Int32) -> Int32 {
    return libusb_init_context(context, options, numOptions)
}


func libusbExit(_ context: LibusbContext?) {
    libusb_exit(context)
}


func libusbSetOptions(_ context: LibusbContext?, option: LibusbOption, value: Int32) -> Int32 {
    return libusb_set_options(context, .init(option.rawValue), value)
}


func libusbSetLogOption(_ context: LibusbContext?, level: LibusbLogLevel) -> Int32 {
    return libusb_set_log_level(context, level)
}



func libusbSetLogCallback(_ context: LibusbContext?, callbackMode: LibusbLogCallbackMode, callback: LibusbLogCallback) {
    libusb_set_log_cb(context, callback, Int32(callbackMode.rawValue))
}


// MARK: - Device handling and enumeration
func libusbGetDeviceList(_ context: LibusbContext?, list: UnsafeMutablePointer<UnsafeMutablePointer<LibusbDevice?>?>?) -> Int {
    return libusb_get_device_list(context, list)
}


func libusbFreeDeviceList(_ list: UnsafeMutablePointer<LibusbDevice?>?, unreferenceDevices: Bool) {
    libusb_free_device_list(list, unreferenceDevices ? 1 : 0)
}


func libusbGetBusNumber(_ device: LibusbDevice?) -> UInt8 {
    return libusb_get_bus_number(device)
}


func libusbGetPortNumber(_ device: LibusbDevice?) -> UInt8 {
    return libusb_get_port_number(device)
}


func libusbGetPortNumbers(_ device: LibusbDevice?, portNumbers: UnsafeMutablePointer<UInt8>?, portNumbersLength: Int) {
    let result = libusb_get_port_numbers(device, portNumbers, Int32(portNumbersLength))
    handlePossibleError(result)
}


func libusbGetParent(_ device: LibusbDevice?) -> LibusbDevice? {
    return libusb_get_parent(device)
}


func libusbGetDeviceAddress(_ device: LibusbDevice?) -> UInt8 {
    return libusb_get_device_address(device)
}


func libusbGetDeviceSpeed(_ device: LibusbDevice?) -> LibusbSpeed {
    let speed = libusb_get_device_speed(device)
    return libusb_speed(rawValue: UInt32(speed))
}


func libusbGetMaxPacketSize(_ device: LibusbDevice?, endpoint: UInt8) -> Int {
    let size = libusb_get_max_packet_size(device, endpoint)
    return Int(size)
}


func libusbGetMaxISOPacketSize(_ device: LibusbDevice?, endpoint: UInt8) -> Int {
    return Int(libusb_get_max_iso_packet_size(device, endpoint))
}


func libusbgetMaxALTPacketSize(_ device: LibusbDevice?, interfaceNumber: Int, altSetting: Int, endpoint: UInt8) -> Int {
    return Int(libusb_get_max_alt_packet_size(device, Int32(interfaceNumber), Int32(altSetting), endpoint))
}


func libusbReferenceDevice(_ device: LibusbDevice?) -> LibusbDevice! {
    return libusb_ref_device(device)
}

func libusbUnreferenceDevice(_ device: LibusbDevice?) {
    libusb_unref_device(device)
}


func libusbWrapSystemDevice(_ context: LibusbContext?, systemDevice: Int, handle: UnsafeMutablePointer<LibusbHandle?>?) -> Int32 {
    return libusb_wrap_sys_device(context, systemDevice, handle)
}


func libusbOpenDevice(_ device: LibusbDevice?, handle: UnsafeMutablePointer<LibusbHandle?>?) -> Int32 {
    return libusb_open(device, handle)
}


func libusbOpenDeviceWithVidPid(_ context: LibusbContext?, vid: UInt16, pid: UInt16) -> LibusbHandle? {
    return libusb_open_device_with_vid_pid(context, vid, pid)
}


func libusbClose(handle: LibusbHandle?) {
    libusb_close(handle)
}


func libusbGetDevice(_ handle: LibusbHandle?) -> LibusbDevice? {
    return libusb_get_device(handle)
}


func libusbGetConfiguration(_ handle: LibusbHandle?, configurationValue: UnsafeMutablePointer<Int32>?) -> Int32 {
    return libusb_get_configuration(handle, configurationValue)
}


func libusbSetConfiguration(_ handle: LibusbHandle?, configurationValue: Int32) -> Int32 {
    return libusb_set_configuration(handle, configurationValue)
}


func libusbClaimInterface(handle: LibusbHandle?, interfaceNumber: Int32) -> Int32 {
    return libusb_claim_interface(handle, interfaceNumber)
}


func libusbReleaseInterface(handle: LibusbHandle?, interfaceNumber: Int32) -> Int32 {
    return libusb_release_interface(handle, interfaceNumber)
}


func libusbSetInterfaceAltSetting(handle: LibusbHandle?, interfaceNumber: Int32, altSetting: Int32) -> Int32 {
    return libusb_set_interface_alt_setting(handle, interfaceNumber, altSetting)
}


func libusbClearHalt(handle: LibusbHandle?, endpoint: UInt8) -> Int32 {
    return libusb_clear_halt(handle, endpoint)
}


func libusbResetDevice(handle: LibusbHandle?) -> Int32{
    return libusb_reset_device(handle)
}


func libusbKernelDriverActive(handle: LibusbHandle?, interfaceNumber: Int32) -> Bool {
    return libusb_kernel_driver_active(handle, interfaceNumber) == 0 ? false : true
}


func libusbDetachKernelDriver(handle: LibusbHandle?, interfaceNumber: Int32) -> Int32 {
    return libusb_detach_kernel_driver(handle, interfaceNumber)
}


func libusbAttachKernelDrivers(handle: LibusbHandle?, interfaceNumber: Int32) -> Int32 {
    return libusb_attach_kernel_driver(handle, interfaceNumber)
}


func libusbSetAutoDetachKernelDriver(handle: LibusbHandle?, enable: Bool) -> Int32 {
    return libusb_set_auto_detach_kernel_driver(handle, enable ? 1 : 0)
}


// MARK: - Synchronous device I/O
func libusbControlTransfer(handle: LibusbHandle?, requestType: UInt8, request: UInt8, wValue: UInt16, wIndex: UInt16, data: UnsafeMutablePointer<UInt8>?, wLength: UInt16, timeout: UInt32) -> Int32 {
    return libusb_control_transfer(handle, requestType, request, wValue, wIndex, data, wLength, timeout)
}


func libusbBulkTransfer(handle: LibusbHandle?, endpoint: UInt8, data: UnsafeMutablePointer<UInt8>?, length: Int32, actualLength: UnsafeMutablePointer<Int32>?, timeout: UInt32) -> Int32 {
    return libusb_bulk_transfer(handle, endpoint, data, length, actualLength, timeout)
}


func libusbInterruptTransfer(handle: LibusbHandle!, endpoint: UInt8, data: UnsafeMutablePointer<UInt8>?, length: Int32, actualLength: UnsafeMutablePointer<Int32>?, timeout: UInt32) -> Int32 {
    return libusb_interrupt_transfer(handle, endpoint, data, length, actualLength, timeout)
}


// MARK: - Asynchronous device I/O
func libusbAllocateStreams(handle: LibusbHandle?, numStreams: UInt32, endpoints: UnsafeMutablePointer<UInt8>?, numEndpoints: Int32) -> Int32 {
    return libusb_alloc_streams(handle, numStreams, endpoints, numEndpoints)
}



func libusbFreeStream(handle: LibusbHandle?, endpoints: UnsafeMutablePointer<UInt8>?, numEndpoints: Int32) -> Int32 {
    return libusb_free_streams(handle, endpoints, numEndpoints)
}


func libusbAllocateDeviceMemory(handle: LibusbHandle?, length: Int) -> UnsafeMutablePointer<UInt8>? {
    return libusb_dev_mem_alloc(handle, length)
}


func libusbFreeDeviceMemory(handle: LibusbHandle?, buffer: UnsafeMutablePointer<UInt8>?, length: Int) -> Int32 {
    return libusb_dev_mem_free(handle, buffer, length)
}


func libusbAllocateTransfer(numIsoPackets: Int32) -> UnsafeMutablePointer<libusb_transfer>? {
    return libusb_alloc_transfer(numIsoPackets)
}


func libusbFreeTransfer(_ transfer: UnsafeMutablePointer<libusb_transfer>?) {
    libusb_free_transfer(transfer)
}


func libusbSubmitTransfer(transfer: UnsafeMutablePointer<libusb_transfer>?) -> Int32 {
    return libusb_submit_transfer(transfer)
}


func libusbCancelTransfer(transfer: UnsafeMutablePointer<libusb_transfer>?) -> Int32 {
    return libusb_cancel_transfer(transfer)
}


func libusbTransferGetStreamID(transfer: UnsafeMutablePointer<libusb_transfer>?) -> UInt32 {
    return libusb_transfer_get_stream_id(transfer)
}


func libusbTransferSetStreamID(transfer: UnsafeMutablePointer<libusb_transfer>?, streamID: UInt32) {
    libusb_transfer_set_stream_id(transfer, streamID)
}


func libusbControlTransferGetData(transfer: UnsafeMutablePointer<libusb_transfer>?) -> UnsafeMutablePointer<UInt8>? {
    return libusb_control_transfer_get_data(transfer)
}


func libusbControlTransferGetSetup(transfer: UnsafeMutablePointer<libusb_transfer>?) -> UnsafeMutablePointer<libusb_control_setup>? {
    return libusb_control_transfer_get_setup(transfer)
}


func libusbFillControlSetup(buffer: UnsafeMutablePointer<UInt8>?, requestType: UInt8, request: UInt8, wValue: UInt16, wIndex: UInt16, wLength: UInt16) {
    libusb_fill_control_setup(buffer, requestType, request, wValue, wIndex, wLength)
}


func libusbFillControlTransfer(buffer: UnsafeMutablePointer<UInt8>?, requestType: UInt8, request: UInt8, wValue: UInt16, wIndex: UInt16, wLength: UInt16) {
    libusb_fill_control_setup(buffer, requestType, request, wValue, wIndex, wLength)
}


func libusbFillBulkTransfer(transfer: UnsafeMutablePointer<libusb_transfer>?, handle: LibusbHandle?, endpoint: UInt8, buffer: UnsafeMutablePointer<UInt8>?, length: Int, callback: LibusbTransferCallback?, userData: UnsafeMutableRawPointer?, timeout: UInt32) {
    libusb_fill_bulk_transfer(transfer, handle, endpoint, buffer, Int32(length), callback, userData, timeout)
}


func libusbFillInterruptTransfer(transfer: UnsafeMutablePointer<libusb_transfer>?, handle: LibusbHandle?, endpoint: UInt8, buffer: UnsafeMutablePointer<UInt8>?, length: Int32, callback: LibusbTransferCallback?, userData: UnsafeMutableRawPointer?, timeout: UInt32) {
    libusb_fill_interrupt_transfer(transfer, handle, endpoint, buffer, length, callback, userData, timeout)
}


func libusbFillIsoTransfer(transfer: UnsafeMutablePointer<libusb_transfer>?, handle: LibusbHandle?, endpoint: UInt8, buffer: UnsafeMutablePointer<UInt8>?, length: Int32, numIsoPackets: Int32, callback: LibusbTransferCallback?, userData: UnsafeMutableRawPointer?, timeout: UInt32) {
    libusb_fill_iso_transfer(transfer, handle, endpoint, buffer, length, numIsoPackets, callback, userData, timeout)
}


func libusbSetIsoPacketLengths(transfer: UnsafeMutablePointer<libusb_transfer>?, length: UInt32) {
    libusb_set_iso_packet_lengths(transfer, length)
}


func libusbGetIsoPacketBuffer(transfer: UnsafeMutablePointer<libusb_transfer>?, packet: UInt32) -> UnsafeMutablePointer<UInt8>? {
    return libusb_get_iso_packet_buffer(transfer, packet)
}


func libusbGetIsoPacketBufferSimple(transfer: UnsafeMutablePointer<libusb_transfer>?, packet: UInt32) -> UnsafeMutablePointer<UInt8>? {
    libusb_get_iso_packet_buffer_simple(transfer, packet)
}


// MARK: - USB descriptors
func libusbGetDeviceDescriptor(_ device: LibusbDevice?, descriptor: UnsafeMutablePointer<LibusbDeviceDescriptor>?) -> Int32 {
    return libusb_get_device_descriptor(device, descriptor)
}

func libusbGetActiveConfigurationDescriptor(device: LibusbDevice?, configuration: UnsafeMutablePointer<UnsafeMutablePointer<libusb_config_descriptor>?>?) -> Int32 {
    return libusb_get_active_config_descriptor(device, configuration)
}


func libusbGetConfigurationDescriptor(device: LibusbDevice?, configurationIndex: UInt8, configuration: UnsafeMutablePointer<UnsafeMutablePointer<libusb_config_descriptor>?>?) -> Int32 {
    return libusb_get_config_descriptor(device, configurationIndex, configuration)
}


func libusbGetConfigurationDescriptorByValue(device: LibusbDevice?, configurationValue: UInt8, configuration: UnsafeMutablePointer<UnsafeMutablePointer<libusb_config_descriptor>?>?) -> Int32 {
    return libusb_get_config_descriptor_by_value(device, configurationValue, configuration)
}


func libusbFreeConfigurationDescriptor(_ descriptor: UnsafeMutablePointer<libusb_config_descriptor>?) {
    libusb_free_config_descriptor(descriptor)
}


func libusbGetPlatformDescriptor(_ context: LibusbContext, deviceCapability: UnsafeMutablePointer<libusb_bos_dev_capability_descriptor>?, platformDescriptor: UnsafeMutablePointer<UnsafeMutablePointer<libusb_platform_descriptor>?>?) -> Int32 {
    return libusb_get_platform_descriptor(context, deviceCapability, platformDescriptor)
}


func libusbFreePlatformDescriptor(descriptor: UnsafeMutablePointer<libusb_platform_descriptor>?) {
    libusb_free_platform_descriptor(descriptor)
}


func libusbGetStringDescriptorASCII(handle: LibusbHandle?, descriptorIndex: UInt8, data: UnsafeMutablePointer<UInt8>?, length: Int32) -> Int32 {
    return libusb_get_string_descriptor_ascii(handle, descriptorIndex, data, length)
}


func libusbGetStringDescriptor(handle: LibusbHandle?, descriptorIndex: UInt8, languageID: UInt16, data: UnsafeMutablePointer<UInt8>?, length: Int32) -> Int32 {
    return libusb_get_string_descriptor(handle, descriptorIndex, languageID, data, length)
}


func libusbGetDescriptor(handle: LibusbHandle?, descriptorType: UInt8, descriptorIndex: UInt8, data: UnsafeMutablePointer<UInt8>?, length: Int32) -> Int32 {
    return libusb_get_descriptor(handle, descriptorType, descriptorIndex, data, length)
}


// MARK: - Miscellaneous
func libusbHasCapability(_ capability: UInt32) -> Int32 {
    return libusb_has_capability(capability)
}


func libusbErrorName(_ errorCode: Int32) -> UnsafePointer<CChar>? {
    return libusb_error_name(errorCode)
}


func libusbGetVersion() -> UnsafePointer<LibusbVersion>? {
    return libusb_get_version()
}


func libusbStringError(_ errorCode: Int32) -> UnsafePointer<CChar>? {
    return libusb_strerror(errorCode)
}


// MARK: - Device hotplug event notification
func libusbHotplugRegisterCallback(context: LibusbContext?, events: Int32, flags: Int32, vendorID: Int32, productID: Int32, deviceClass: Int32, callback: LibusbHotplugCallback, userData: UnsafeMutableRawPointer?, callbackHandle: UnsafeMutablePointer<LibusbHotplugCallbackHandle>?) -> Int32 {
    return libusb_hotplug_register_callback(context, events, flags, vendorID, productID, deviceClass, callback, userData, callbackHandle)
}


func libusbHotplugDeregisterCallback(context: LibusbContext?, callbackHandle: LibusbHotplugCallbackHandle) {
    libusb_hotplug_deregister_callback(context, callbackHandle)
}


func libusbHotplugGetUserData(context: LibusbContext?, callbackHandle: LibusbHotplugCallbackHandle) {
    libusb_hotplug_get_user_data(context, callbackHandle)
}


// MARK: - Polling and timing
func libusbTryLockEvents(context: LibusbContext?) -> Int32 {
    return libusb_try_lock_events(context)
}


func libusbLockEvents(context: LibusbContext?) {
    libusb_lock_events(context)
}


func libusbUnlockEvents(context: LibusbContext?) {
    libusb_unlock_events(context)
}


func libusbEventHandlingOk(context: LibusbContext?) -> Int32 {
    return libusb_event_handling_ok(context)
}


func libusbEventHandlerActive(context: LibusbContext?) -> Int32 {
    return libusb_event_handler_active(context)
}


func libusbInterruptEventHandler(context: LibusbContext?) {
    libusb_interrupt_event_handler(context)
}


func libusbLockEventWaiters(context: LibusbContext?) {
    libusb_lock_event_waiters(context)
}


func libusbUnlockEventWaiters(context: LibusbContext?) {
    libusb_unlock_event_waiters(context)
}


func libusbWaitForEvent(context: LibusbContext?, timeValue: UnsafeMutablePointer<timeval>?) -> Int32 {
    return libusb_wait_for_event(context, timeValue)
}


func libusbHandleEventsTimeoutCompleted(context: LibusbContext?, timeValue: UnsafeMutablePointer<timeval>?, completed: UnsafeMutablePointer<Int32>?) -> Int32 {
    return libusb_handle_events_timeout_completed(context, timeValue, completed)
}


func libusbHandleEventsTimeout(context: LibusbContext?, timeValue: UnsafeMutablePointer<timeval>?) -> Int32 {
    return libusb_handle_events_timeout(context, timeValue)
}


func libusbHandleEvents(context: LibusbContext?) -> Int32 {
    return libusb_handle_events(context)
}


func libusbHandleEventsCompleted(context: LibusbContext?, completed: UnsafeMutablePointer<Int32>?) -> Int32 {
    return libusb_handle_events_completed(context, completed)
}


func libusbHandleEventsLocked(context: LibusbContext?, timeValue: UnsafeMutablePointer<timeval>?) -> Int32 {
    return libusb_handle_events_locked(context, timeValue)
}


func libusbPollFileDescriptorHandleTimeouts(context: LibusbContext?) -> Int32 {
    return libusb_pollfds_handle_timeouts(context)
}


func libusbGetNextTimeout(context: LibusbContext?, timeValue: UnsafeMutablePointer<timeval>?) -> Int32 {
    return libusb_get_next_timeout(context, timeValue)
}


func libusbSetPollFileDescriptorNotifiers(context: LibusbContext?, fileDescriptorAddedCallback: LibusbPollFileDescriptorAddedCallback, fileDescriptorRemovedCallback: LibusbPollFileDescriptorRemovedCallback, userData: UnsafeMutableRawPointer?) {
    libusb_set_pollfd_notifiers(context, fileDescriptorAddedCallback, fileDescriptorRemovedCallback, userData)
}


func libusbGetPollFileDescriptors(context: LibusbContext?) ->  UnsafeMutablePointer<UnsafePointer<libusb_pollfd>?>? {
    return libusb_get_pollfds(context)
}


func libusbFreePollFileDescriptors(descriptors: UnsafeMutablePointer<UnsafePointer<libusb_pollfd>?>?) { 
    libusb_free_pollfds(descriptors)
}


///** Error handling
func handlePossibleError(_ errorCode: Int32) {
    if errorCode != LIBUSB_SUCCESS.rawValue {
        fatalError("ERROR: \(String(cString: libusb_strerror(errorCode)))")
    }
}
