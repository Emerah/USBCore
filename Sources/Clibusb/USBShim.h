#ifndef USBShim_h
#define USBShim_h

#include "libusb.h"

/// swift can not call C-Functions that have a variadic parameter.
/// this is a convenience function that abstracts the variadic
/// parameter function libusb_set_option and exposes a single
/// value parameter to swift.

int libusb_set_log_level(libusb_context* ctx, enum libusb_log_level level) {
    return libusb_set_option(ctx, LIBUSB_OPTION_LOG_LEVEL, level);
}

int libusb_set_options(libusb_context* ctx, enum libusb_option option, int value) {
    return libusb_set_option(ctx, option, value);
}

#endif /* USBShim_h */
