Docker container for MEGASync on aarch64
===

Make possible to run [MEGA Sync](https://mega.nz/sync) on 64bit arm devices with Docker (Ex. Raspberry Pi 4)

The Docker baseimage comes from modified fork of [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui).
The GUI of the application is accessed through a modern web browser (no installation or configuration needed on the client side) or via any VNC client.

Note: Official MEGASync currently does not support Linux on 64bit arm devices, this image used a pre-compiled MEGASync binary
from [my fork](https://github.com/daniel0076/MEGAsync) of MEGASync with modifications to enable running on Linux aarch64.

This project is still at an initial stage, and it is only tested on a Raspbery Pi 4 (4GB) with Ubuntu 20.04 (64bit) only.
Open issues for help if you counter a problem.

## Screenshots
<img src="https://raw.githubusercontent.com/daniel0076/docker-megasync-arm/master/screenshots/1.png" alt="screenshot2" />

## Quick Start

This image has almost the same configuration as [jleasage/docker-base-gui](https://github.com/jlesage/docker-baseimage-gui)
So only brief explaination is provided here, for detailed usage, please refer to jleasage's repo.

Launch the MEGASync docker container with the following command:
```
docker run -d \
    --name=MEGASync \
    -p 5800:5800 \
    -p 5900:5900 \
    -v $HOME/Downloads:/MEGASync:rw \
    daniel0076/megasync-arm
```

Where:
  - `$HOME/Downloads`: This is the folder to sync with the MEGASync account

Browse to `http://your-host-ip:5800` to access the MEGASync GUI, or you connect with a VNC client to `vnc://your-host: 5900`.

## Usage

(Modified from `jlesage`'s repo)

### Environment Variables

To customize some properties of the container, the following environment
variables can be passed via the `-e` parameter (one for each variable).  Value
of this parameter has the format `<VARIABLE_NAME>=<VALUE>`.

| Variable       | Description                                  | Default |
|----------------|----------------------------------------------|---------|
|`USER_ID`| ID of the user the application runs as.  See [User/Group IDs](https://github.com/jlesage/docker-baseimage-gui#usergroup-ids) to better understand when this should be set. | `1000` |
|`GROUP_ID`| ID of the group the application runs as.  See [User/Group IDs](https://github.com/jlesage/docker-baseimage-gui#usergroup-ids) to better understand when this should be set. | `1000` |
|`SUP_GROUP_IDS`| Comma-separated list of supplementary group IDs of the application. | (unset) |
|`UMASK`| Mask that controls how file permissions are set for newly created files. The value of the mask is in octal notation.  By default, this variable is not set and the default umask of `022` is used, meaning that newly created files are readable by everyone, but only writable by the owner. See the following online umask calculator: http://wintelguy.com/umask-calc.pl | (unset) |
|`TZ`| [TimeZone] of the container.  Timezone can also be set by mapping `/etc/localtime` between the host and the container. | `Etc/UTC` |
|`KEEP_APP_RUNNING`| When set to `1`, the application will be automatically restarted if it crashes or if a user quits it. | `0` |
|`APP_NICENESS`| Priority at which the application should run.  A niceness value of -20 is the highest priority and 19 is the lowest priority.  By default, niceness is not set, meaning that the default niceness of 0 is used.  **NOTE**: A negative niceness (priority increase) requires additional permissions.  In this case, the container should be run with the docker option `--cap-add=SYS_NICE`. | (unset) |
|`CLEAN_TMP_DIR`| When set to `1`, all files in the `/tmp` directory are deleted during the container startup. | `1` |
|`DISPLAY_WIDTH`| Width (in pixels) of the application's window. | `1280` |
|`DISPLAY_HEIGHT`| Height (in pixels) of the application's window. | `768` |
|`SECURE_CONNECTION`| When set to `1`, an encrypted connection is used to access the application's GUI (either via a web browser or VNC client).  See the [Security](https://github.com/jlesage/docker-baseimage-gui#security) section for more details. | `0` |
|`VNC_PASSWORD`| Password needed to connect to the application's GUI.  See the [VNC Password](https://github.com/jlesage/docker-baseimage-gui#vnc-password) section for more details. | (unset) |
|`X11VNC_EXTRA_OPTS`| Extra options to pass to the x11vnc server running in the Docker container.  **WARNING**: For advanced users. Do not use unless you know what you are doing. | (unset) |
|`ENABLE_CJK_FONT`| When set to `1`, open-source computer font `WenQuanYi Zen Hei` is installed.  This font contains a large range of Chinese/Japanese/Korean characters. | `0` |
|`INSTALL_EXTRA_PKGS`| Space-separated list of Alpine Linux packages to install.  See https://pkgs.alpinelinux.org/packages?name=&branch=v3.9&arch=x86_64 for the list of available Alpine Linux packages. | (unset) |

### Data Volumes

The following table describes data volumes used by the container.  The mappings
are set via the `-v` parameter.  Each mapping is specified with the following
format: `<HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]`.

| Container path  | Permissions | Description |
|-----------------|-------------|-------------|
|`/MEGASync`| rw | This is the folder exposed to MEGASync . |

### Ports

Here is the list of ports used by the container.  They can be mapped to the host
via the `-p` parameter (one per port mapping).  Each mapping is defined in the
following format: `<HOST_PORT>:<CONTAINER_PORT>`.  The port number inside the
container cannot be changed, but you are free to use any port on the host side.

| Port | Mapping to host | Description |
|------|-----------------|-------------|
| 5800 | Mandatory | Port used to access the application's GUI via the web interface. |
| 5900 | Optional | Port used to access the application's GUI via the VNC protocol.  Optional if no VNC client is used. |

