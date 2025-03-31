# Work Fish aliases

set -gx _WORKSPACE "$HOME/tworkspace"

function get-group-id
    if test (count $argv) -eq 0
        echo "Group name not specified ..."
        return 1
    end

    getent group $argv[1] | awk -F: '{print $3}'
end

function build-p25-docker-c7
    set -l _uid (uuidgen -t)
    set -l _container_name "p25-builder-c7-"(string sub -l 8 $_uid)
    set -l _docker_image gitlab.taitradio.net:4567/core-network/tn9400/p25core/p25-builder-centos7-9:02-32
    set -l _grp_vol /etc/group:/etc/group:ro
    set -l _pwd_vol /etc/passwd:/etc/passwd:ro
    set -l _shadow_vol /etc/shadow:/etc/shadow:ro
    set -l _docker_socket_vol /var/run/docker.sock:/var/run/docker.sock
    set -l _workspace_vol "$_WORKSPACE"
    set -l _work_dir "$_WORKSPACE/p25core"
    set -l _npm_dir "$HOME/.npm"
    set -l _docker_dir "$HOME/.docker"
    set -l _container_hostname c7-builder

    docker pull $_docker_image

    docker run \
        --rm -it \
        -e TOOLSET=11 \
        --name $_container_name \
        --user (id -u):(id -g) \
        --device /dev/tpm0:/dev/tpm0 \
        --device /dev/tpmrm0:/dev/tpmrm0 \
        --group-add (id -g tss) \
        --workdir $_work_dir \
        --hostname $_container_hostname \
        -v $_grp_vol \
        -v $_pwd_vol \
        -v $_shadow_vol \
        -v $_docker_socket_vol \
        -v $_npm_dir:$_npm_dir \
        -v $_workspace_vol:$_workspace_vol \
        -v $_docker_dir:$_docker_dir \
        $_docker_image \
        bash
end

function build-p25-docker-u22
    set -l _uid (uuidgen -t)
    set -l _container_name "p25-builder-u22-"(string sub -l 8 $_uid)
    set -l _docker_image gitlab.taitradio.net:4567/core-network/tn9400/p25core/p25-builder-ubuntu22-04:03-34
    set -l _grp_vol /etc/group:/etc/group:ro
    set -l _pwd_vol /etc/passwd:/etc/passwd:ro
    set -l _shadow_vol /etc/shadow:/etc/shadow:ro
    set -l _docker_socket_vol /var/run/docker.sock:/var/run/docker.sock
    set -l _workspace_vol "$_WORKSPACE"
    set -l _work_dir "$_WORKSPACE/p25core"
    set -l _npm_dir "$HOME/.npm"
    set -l _docker_dir "$HOME/.docker"
    set -l _container_hostname u22-builder
    set -l _docker_grp_id (getent group docker | awk -F: '{print $3}')

    docker pull $_docker_image

    docker run \
        --rm -it \
        --name $_container_name \
        --user (id -u):(id -g) \
        --device /dev/tpm0:/dev/tpm0 \
        --device /dev/tpmrm0:/dev/tpmrm0 \
        --group-add (id -g tss) \
        --group-add $_docker_grp_id \
        --workdir $_work_dir \
        --hostname $_container_hostname \
        -v $_grp_vol \
        -v $_pwd_vol \
        -v $_shadow_vol \
        -v $_docker_socket_vol \
        -v $_npm_dir:$_npm_dir \
        -v $_workspace_vol:$_workspace_vol \
        -v $_docker_dir:$_docker_dir \
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
