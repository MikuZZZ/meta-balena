FILESEXTRAPATHS_append := ":${RESIN_COREBASE}/recipes-bsp/u-boot/patches"

INTEGRATION_KCONFIG_PATCH = "file://resin-specific-env-integration-kconfig.patch"
INTEGRATION_NON_KCONFIG_PATCH = "file://resin-specific-env-integration-non-kconfig.patch"

# Machine independent patches
SRC_URI_append = " \
    file://env_resin.h \
    ${@bb.utils.contains('UBOOT_KCONFIG_SUPPORT', '1', '${INTEGRATION_KCONFIG_PATCH}', '${INTEGRATION_NON_KCONFIG_PATCH}', d)} \
    "

python __anonymous() {
    # Use different integration patch based on u-boot Kconfig support
    kconfig_support = d.getVar('UBOOT_KCONFIG_SUPPORT', True)
    if not kconfig_support or (kconfig_support != '0' and kconfig_support != '1'):
        bb.error("UBOOT_KCONFIG_SUPPORT not defined or wrong value. Should be 0 or 1.")
}

RESIN_BOOT_PART = "1"
RESIN_DEFAULT_ROOT_PART = "2"
RESIN_ENV_FILE = "resinOS_uEnv.txt"
RESIN_UBOOT_DEVICES ?= "0 1 2"
RESIN_UBOOT_DEVICE_TYPES ?= "mmc"

# OS_KERNEL_CMDLINE is a distro wide variable intended to be used in all the
# supported bootloaders
BASE_OS_CMDLINE ?= "${OS_KERNEL_CMDLINE}"

UBOOT_VARS = "RESIN_UBOOT_DEVICES \
              RESIN_UBOOT_DEVICE_TYPES \
              RESIN_BOOT_PART RESIN_DEFAULT_ROOT_PART \
              RESIN_IMAGE_FLAG_FILE \
              RESIN_FLASHER_FLAG_FILE \
              RESIN_ENV_FILE \
              BASE_OS_CMDLINE"

python do_generate_resin_uboot_configuration () {
    vars = d.getVar('UBOOT_VARS').split()
    with open(os.path.join(d.getVar('S'), 'include', 'config_resin.h'), 'w') as f:
        for v in vars:
            f.write("#define %s %s\n" % (v, d.getVar(v)))

    src = bb.utils.which(d.getVar('FILESPATH'), 'env_resin.h')
    if not src:
        raise Exception('env_resin.h not found')
    dst = os.path.join(d.getVar('S'), 'include', 'env_resin.h')
    bb.utils.copyfile(src, dst)
}
addtask do_generate_resin_uboot_configuration after do_patch before do_configure

# Regenerate env_resin.h if any of these variables change.
do_generate_resin_uboot_configuration[vardeps] += "${UBOOT_VARS}"
