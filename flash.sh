#!/usr/bin/env bash

REPO_NAME=${PWD##*/}

XDOT_NAME="XDOT"
MDOT_NAME="MULTITECH"
DEVICE_NAME="$XDOT_NAME"

XDOT_TARGET="xdot_l151cc"
MDOT_TARGET="mts_mdot_f411re"
DEVICE_TARGET="${XDOT_TARGET}"

USE_PREVIOUS_BUILD=false

function usage()
{
    echo "Upgrade the firmware of your xdot or mdot."
    echo ""
    echo "./flash.sh"
    echo "    -h --help"
    echo "    -t --target=[xdot|mdot]"
    echo "    -p --previous    Use previous build for current target."
    echo ""
    echo "Examples:"
    echo "Compile and flash an xdot"
    echo "./flash.sh -t=xdot"
    echo ""
    echo "Flash previous build, already compiled for mdot"
    echo "./flash.sh -t=mdot -p"
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case ${PARAM} in
        -h | --help)
            usage
            exit
            ;;
        -t | --target)
            if [ "${VALUE}" == "mdot" ]; then
                DEVICE_NAME="${MDOT_NAME}"
                DEVICE_TARGET="${MDOT_TARGET}"
            fi
            ;;
        -p | --previous)
            USE_PREVIOUS_BUILD=true
            ;;
        *)
            echo "[ERROR] Unknown parameter \"${PARAM}\""
            usage
            exit 1
            ;;
    esac
    shift
done

# Skip compiling and flash the existing binary.
if [ "${USE_PREVIOUS_BUILD}" != true ]; then
    echo "[INFO] Device name: ${DEVICE_NAME}"
    echo "[INFO] Building for target: ${DEVICE_TARGET}";

    # Remove the previous builds if any.
    if [ -d "./BUILD" ]; then
        rm -r ./BUILD/*
        echo "[INFO] Removed the previous builds."
    fi

    # Compile it for the specific target with ARM GCC.
    mbed compile -m ${DEVICE_TARGET} -t GCC_ARM
else
    echo "[INFO] Using the previous build for ${DEVICE_NAME}"
fi

if [ ! -f ./BUILD/${DEVICE_TARGET}/GCC_ARM/${REPO_NAME}.bin ]; then
    echo "[ERROR] No binary file to flash. Are there any compiling errors?"
    exit 1
fi

if [ ! -d /Volumes/${DEVICE_NAME} ]; then
    echo "[ERROR] The ${DEVICE_NAME} device is not connected."
    exit 2;
fi

# Flash it on your connected device.
echo "[INFO] Flashing ${DEVICE_NAME} device for ${DEVICE_TARGET} target ..."
echo "[INFO] Check the blinking led on the device, when it's finished press the reset button."
cp ./BUILD/${DEVICE_TARGET}/GCC_ARM/${REPO_NAME}.bin /Volumes/${DEVICE_NAME}
