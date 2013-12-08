#install things...
apt-get update
apt-get -y install git python curl

IN_SDK_SCRIPT=$( cat <<EOF
    echo coreos | ./set_shared_user_password.sh;
    echo amd64-generic > .default_board;
    ./setup_board;
    ./build_packages;
    ./build_image prod;
EOF
)

AS_USER_SCRIPT=$( cat <<EOF
    git config --global user.name "Vagrant";
    git config --global user.email vagrant@vagrantfile.com;
    cd \$HOME;
    mkdir coredev; cd coredev;

    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git;
    export PATH=\$PATH:\`pwd\`/depot_tools;

    mkdir coreos; cd coreos;
    repo init -q -u https://github.com/coreos/manifest.git -g minilayout;
    repo sync -q -f;
    echo "$IN_SDK_SCRIPT" | ./chromite/bin/cros_sdk
EOF
)

su - vagrant -c "$AS_USER_SCRIPT"

#The following does not work:
#repo init -u https://github.com/coreos/manifest.git -g minilayout\
#    --repo-url https://android.googlesource.com/tools/repo

#we get the error:

#object 12fd10c20115046dcd2fbe468a45e566f38ffbc9
#type commit
#tag v1.12.7
#tagger Conley Owens <cco3@android.com> 1381959964 -0700
#
#repo 1.12.7
#
#gpg: Signature made Wed 16 Oct 2013 05:46:04 PM EDT using RSA key ID 692B382C
#gpg: Can't check signature: public key not found
#error: could not verify the tag 'v1.12.7'


