#!/usr/bin/env sh

set -e

usage() {
    echo "Usage: ./dockerctl.sh [OPTION]"
    echo "  -b, --build       Builds the docker image"
    echo "  -r, --run         Starts a container, gets a shell"
    echo "  -l, --launch      Gets a shell on running container"
    echo "  -rm, --remove     Stops and removes container"
    echo "  -h, --help        Print this message"
    exit 0
}

if [ $# -eq 0 ] ; then
    usage
fi

CODE_SRC_DIR="$(pwd)/.."
CODE_TARGET_DIR=/lux-kernel
IMAGE=lux-kernel:latest
CONTAINER=lux-kernel

DEB_IMAGE_FILE=/linux-image-6.6.18-lux-amd64_6.6.18-lux-1_amd64.deb
DEB_HEADERS_FILE=/linux-headers-6.6.18-lux-amd64_6.6.18-lux-1_amd64.deb
DEB_LIBC_FILE=/linux-libc-dev_6.6.18-lux-1_amd64.deb

while test $# -gt 0
do
    case "$1" in
        -b|--build)
            case "$2" in
                --CI)
                    shift
                    sed -i "s!debian:bookworm!localhost:5000/lux-debian!g" Dockerfile
                    cat Dockerfile

                    # Build from another directory to be able to COPY later
                    cd ..
                    docker build -t "${IMAGE}" -f docker/Dockerfile .
                    cd -

                   # docker tag "${IMAGE}" "${LOCAL_IMAGE}"
                   # docker push "${LOCAL_IMAGE}"
                    ;;
                *)

                    # Build from another directory to be able to COPY later
                    sudo docker build -t "${IMAGE}" .
                    ;;
            esac
            ;;
        -r|--run)
            sudo docker run -d \
                 --ipc=host \
                 --net=host \
                 -it \
                 --privileged \
                 --name "${CONTAINER}" \
                 --mount type=bind,source="${CODE_SRC_DIR}",target="${CODE_TARGET_DIR}" \
                 -v /tmp/.X11-unix:/tmp/.X11-unix \
                 -v "${HOME}/.Xauthority:/root/.Xauthority:rw" \
                 -e DISPLAY \
                 "${IMAGE}"
            sudo docker exec -it "${CONTAINER}" /bin/bash
            ;;
        -c|--compile)
            case "$2" in
                --CI)
                    echo "Running on CI"
                    shift
                    sudo docker run -d \
                        -it \
                        --name "${CONTAINER}" \
                        --mount type=bind,source="${CODE_SRC_DIR}",target="${CODE_TARGET_DIR}" \
                 "${IMAGE}"

                    docker exec "${CONTAINER}" /bin/bash -c "cd ${CODE_TARGET_DIR}/scripts && ./build_kernel_package.sh"
		    sudo docker cp "${CONTAINER}":"${CODE_TARGET_DIR}"/src"${DEB_IMAGE_FILE}" "${CODE_SRC_DIR}"
                    sudo docker cp "${CONTAINER}":"${CODE_TARGET_DIR}"/src"${DEB_HEADERS_FILE}" "${CODE_SRC_DIR}"
                    sudo docker cp "${CONTAINER}":"${CODE_TARGET_DIR}"/src"${DEB_LIBC_FILE}" "${CODE_SRC_DIR}"
                    docker rm -f "${CONTAINER}"
                    ;;
                *)
                    echo "Running locally"

                    sudo docker run -d \
                       -it \
                       --name "${CONTAINER}" \
                        --mount type=bind,source="${CODE_SRC_DIR}",target="${CODE_TARGET_DIR}" \
                       "${IMAGE}"

                    sudo docker exec "${CONTAINER}" /bin/bash -c "cd ${CODE_TARGET_DIR}/scripts && ./build_kernel_package.sh"
		    pwd
                    mv ../src"${DEB_IMAGE_FILE}" ..
                    mv ../src"${DEB_HEADERS_FILE}" ..
                    mv ../src"${DEB_LIBC_FILE}" ..

                    sudo docker stop -t0 "${CONTAINER}"
                    sudo docker rm "${CONTAINER}"
                    ;;
                esac
                ;;
        -l|--launch)
            sudo docker exec -it "${CONTAINER}" /bin/bash
            ;;
        -rm|--remove)
            sudo docker stop -t0 "${CONTAINER}"
            sudo docker rm "${CONTAINER}"
            ;;
        -h|--help|*)
            usage
            ;;
    esac
    shift
done

exit 0
