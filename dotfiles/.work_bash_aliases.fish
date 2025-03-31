#!/usr/bin/env fish

# Work Fish aliases

set -gx _WORKSPACE "$HOME/tworkspace"

function ensure-dir-exists -a _dir
    if test ! -d "$_dir"
        mkdir -p "$_dir"
    end
end

function build-p25-docker-u22
    set -l _uid (uuidgen -t)
    set -l _container_name "p25-builder-u22-"(string sub -l 8 $_uid)
    set -l _docker_image gitlab.taitradio.net:4567/core-network/tn9400/p25core/p25-builder-ubuntu22-04:03-34
    set -l _docker_socket_vol /var/run/docker.sock:/var/run/docker.sock
    set -l _grp_vol /etc/group:/etc/group:ro
    set -l _pwd_vol /etc/passwd:/etc/passwd:ro
    set -l _shadow_vol /etc/shadow:/etc/shadow:ro
    set -l _npm_vol "$HOME/.npm/:$HOME/.npm/"
    set -l _docker_vol "$HOME/.docker/:$HOME/.docker/"
    set -l _workspace_vol "$_WORKSPACE:$_WORKSPACE"
    set -l _container_hostname u22-builder
    set -l _work_dir "$_WORKSPACE"
    set -l _docker_grp_id (getent group docker | awk -F: '{print $3}')

    ensure-dir-exists "$HOME/.npm"
    ensure-dir-exists "$HOME/.docker"

    # docker pull $_docker_image

    docker run \
        --rm -it \
        --name $_container_name \
        --user "$(id -u):$(id -g)" \
        --device /dev/tpm0:/dev/tpm0 \
        --device /dev/tpmrm0:/dev/tpmrm0 \
        --group-add "$(id -g tss)" \
        --group-add $_docker_grp_id \
        --workdir $_work_dir \
        --hostname $_container_hostname \
        -v $_grp_vol \
        -v $_pwd_vol \
        -v $_shadow_vol \
        -v $_npm_vol \
        -v $_docker_vol \
        -v $_docker_socket_vol \
        -v $_workspace_vol \
        $_docker_image \
        bash
end

function sshark
    if test (count $argv) -eq 0
        echo "Remote host not specified ..."
        return 1
    end

    ssh $argv[1] "echo 'Checking access ...'"
    set -l _can_access $status
    if test $_can_access -ne 0
        echo "Cannot access '$argv[1]'"
        return 1
    end

    echo "Capturing remote tcpdump from '$argv[1]' ..."
    ssh $argv[1] "tcpdump -U -i any -s 0 -w - not port 22" | wireshark -k -i -
end
