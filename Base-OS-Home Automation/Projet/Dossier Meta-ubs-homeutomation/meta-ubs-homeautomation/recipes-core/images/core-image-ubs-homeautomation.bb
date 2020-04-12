include recipes-core/images/core-image-minimal.bb
IMAGE_FEATURES += "ssh-server-dropbear"
IMAGE_INSTALL += " i2c-tools"

inherit extrausers
EXTRA_USERS_PARAMS = "useradd -P 'ssi' ubs;"
