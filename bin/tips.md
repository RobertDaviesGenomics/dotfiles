# Scientific-Python

    pip install -U pip
    pip install --user ipython
    pip install --user ipython[terminal]
    pip install --user ipython[notebook]
    python -m IPython.external.mathjax
    pip install --user numpy
    pip install --user scipy
    pip install --user sympy
    pip install --user matplotlib

# prolog-CSP

First install GNU prolog:

    apt-get install gprolog

To use CLP(FP) in gprolog:

    X+1#=#Y,Y#>3,Y#=<5, fd_labeling([X,Y]).

You can press ';' to see additional solutions.

A different example using explicit domain restrictions is:

    X*Y#=#X+Y, fd_domain([X,Y],1,100), fd_labeling([X,Y]).

Alternatively, you can try to use the Clip\_ extension to Prolog. The
syntax is:

    {X+1=Y, Y>3,Y=<5}, print_clip(X).

.. \_Clip: http://interval.sourceforge.net/interval/index.html

Using the instructions "integer(X)" or "boolean(Y)" its possible to
constraint the values of the variables to be integral or boolean
(\[0,1\]).

A good alternative to Prolog/Clip is RealPaver. A newer system is Ciao,
which offers CLP(R) and CLP(Q) to do constraint programming over the
reals and rationals respectively. Icos is similar to RealPaver but
larger and with a more complex syntax.

# pianobar

To configure it create a file in \~/.config/pianobar/config

To prevent pianobar from asking for a password, you can use a keyring
utility (pip install keyring; keyring set pandora \${YOUREMAIL})

This is the contents of a simple config file:

    user = ${YOUREMAIL}
    password_command = keyring get pandora ${YOUREMAIL}
    autostart_station = 731900974616170908

    format_nowplaying_song =  [36m%a[0m  - [32m%t[0m ([31m%l[0m)
    format_nowplaying_station = [35m%n[0m (id: %i)
    format_list_song = %i) %a - %t%r

# iodine

The purpose of this is to do DNS tunneling, to bypass some wifi
security.

On the server, run:

    iodined -f -P password 10.7.0.1 tunnel.yourdomain.com

To make it run automatically (assuming you used the debian package) edit
/etc/default/iodined to reflect the following:

    START_IODINED = "true"
    IODINED_ARGS = "10.7.0.1 tunnel.yourdomain.com"
    IODINED_PASSWORD = "password"

On the client run:

    iodine -f tunnel.yourdomain.com

Afterwards use an ssh tunnel to route traffic.

# GDM-userlist

Since Ubuntu Karmic (perhaps earlier) GDM displays a list of users in
the login screen. This is inconvenient for several reasons, especially
to those which use systems with more than a few users. To disable user
list in GDM:

    sudo -u gdm gconftool-2 --set --type boolean /apps/gdm/simple-greeter/disable_user_list true

# Chrome-certificates

Run the following in the command prompt:

    certutil -d sql:$HOME/.pki/nssdb -A -t C,, -n mit -i file.crt
    pk12util -d sql:$HOME/.pki/nssdb -i file.p12

# GPG

To generate a key: gpg --gen-key

To list your private keys: gpg -K

To output ascii version of key: gpg -a --export "key name"

Send to keyserver: gpg --send-keys "key name" --keyserver
hkp://subkeys.pgp.net

Encrypt using public key: gpg -e -r "recipient key name" file.txt

Symmetric Encryption (no keys): gpg -c file.txt

Decrypt: gpg -d file.txt.gpg

# Grub2-LiveUSB

It is now possible to install the grub bootloader in your USB drive.

The following instructions will wipe your device, and create a new fat32
partition:

    FOLDER="/media/usb"
    DEVICE="/dev/usbdevice"

    # clean boot sector
    dd if=/dev/zero of=$DEVICE bs=512 count=1
    # create label
    parted $DEVICE mklabel msdos
    # create partition table
    parted $DEVICE mkpartfs p fat32 0 100%
    # set boot flag
    parted $DEVICE set 1 boot on
    # install grub

Now installing grub is easy:

    mount ${DEVICE}1 $FOLDER
    grub-install --no-floppy --root-directory=$FOLDER $DEVICE

To configure grub to boot an ISO file in your usb stick:

    cat << EOF > $FOLDER/boot/grub/grub.cfg
    menuentry "LiveCD"
    {
        loopback loop /boot/iso/ubuntu.iso
        linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=/boot/iso/ubuntu.iso noeject noprompt --
        initrd (loop)/casper/initrd.lz
    }
    EOF

# ubuntu-repositories

To install the usual ubuntu repositories (media labe mirror):

    DIST="oneiric"
    cat << EOF > /etc/apt/sources.list
    deb http://ubuntu.media.mit.edu/ubuntu/ ${DIST} main restricted universe multiverse
    deb http://ubuntu.media.mit.edu/ubuntu/ ${DIST}-updates main restricted universe multiverse
    deb http://ubuntu.media.mit.edu/ubuntu/ ${DIST}-security main restricted universe multiverse
    # deb http://archive.ubuntu.com/ubuntu/ ${DIST}-proposed restricted main multiverse universe
    # deb http://debian.csail.mit.edu/debian unstable main contrib non-free
    deb http://packages.medibuntu.org/ ${DIST} free non-free
    deb http://archive.canonical.com/ubuntu ${DIST} partner
    EOF

To setup priorities on repositories:

    DIST="oneiric"
    cat << EOF > /etc/apt/preferences
    Package: *
    Pin: release a=${DIST}-security
    Pin-Priority: 990

    Package: *
    Pin: release a=${DIST}-updates
    Pin-Priority: 900

    Package: *
    Pin: release a=${DIST}-proposed
    Pin-Priority: 400

    Package: *
    Pin: release a=unstable
    Pin-Priority: -1
    EOF

# user-management

To lock a user:

    usermod -L user

To unlock a user:

    usermod -U user

To add a user with a fixed password:

    useradd -m user
    echo "user:passwd" | chpasswd

To remove a user:

    userdel -r user

To add an existing user to an existing group:

    usermod -G group -a user

To copy the groups USER1 into USER2:

    GROUPS=$(awk -F: "{ if (\$4 ~ /$USER1/) print \$1  }" ORS=',' /etc/group | sed 's/,$//')
    usermod -G $GROUPS -a $USER2

# Firefox-Tweaks

Extensions: Download Statusbar, AdBlock Plus, Vimperator.

1.  Open Firefox, and type about:config in the address bar. Don’t worry
    about the warning that comes out.

2.  Use the filter above to find network.http.pipelining and set it to
    True by double clicking on it.

3.  Create a new boolean value named
    network.http.pipelining.firstrequest and set that to True, as well.

4.  Find network.http.pipelining.maxrequests, double click on it, and
    change its value to 8.

5.  Now look for network.http.proxy.pipelining and again set it to True.

6.  Create two new integers named nglayout.initialpaint.delay and
    content.notify.interval, setting them to 0.

# git-primer

To convert directory to git repository:

    git init
    git add .
    git commit -a -m "First import"

To create a tag, use:

    git tag -a $(tag_name)
    # or
    git tag -s $(tag_name)

To push tags:

    git push --tags

# git-advanced

To squash the last N commits together:

    git reset --soft HEAD~N
    git commit -m "new commit message"

If you want to squash the last N commits and edit a commit message which
includes all previous commit messages:

    git reset --soft HEAD~N
    git commit --edit -m"$(git log --format=%B --reverse HEAD..HEAD@{1})"

To delete a branch branchname, both locally and in the remote origin:

git branch -d branchname git push origin :branchname

Given a branch branchname and a remote upstream, if you want your local
branch to be a mirror of the remote branch, do the following:

git checkout branchname git fetch upstream git reset --hard
upstream/branchname git clean -dfx

# git-submodules

To add a submodule to an existing project:

    git submodule add git@${modulehost}:${modulepath} ${modulename}

To remove a submodule form a project:

    git submodule deinit ${modulename}
    git rm ${modulename}

To pull the submodules of a project you checked out:

    git submodule update --init

To update the submodules in a project:

    git submodule foreach git pull origin master

# git-subtree

To subtree-merge an existing repository to the cork/ directory

    git remote add -f cork git://github.com/${USER}/cork.git
    git merge -s ours [--squash] --no-commit cork/master
    git read-tree --prefix cork/ -u cork/master
    git commit -m "Merged changes from cork"

To update the cork/ directory with the latest changes

    git pull -s subtree [--squash] cork master

Using git-subtree things are simpler:

    git remote add -f cork git://github.com/${USER}/cork.git

    git subtree add --prefix cork/ cork master [--squash]

    git subtree pull --prefix cork/ cork master [--squash]

# git-svn

Install git-svn:

    apt-get install git-svn

Checkout the SVN repository into your local git repo:

    git svn clone http://repourl/project
    cd project

Commit your changes using git (as usual):

    git ci -a -m "commit message."

Update your local git repo from the remote SVN repository:

    git svn rebase

Send your git commits upstream to the SVN repository:

    git svn dcommit

Export your current git repo to a clean SVN (this assumes you are in a
folder which is already a git repository with some non empty history):

    git config svn-remote.svn.url svn-remote.svn.url https://repourl/project
    git config svn-remote.svn.fetch :refs/remotes/git-svn
    git svn fetch
    git rebase remotes/git-svn
    git svn dcommit

# Gitosis

Install:

    apt-get install gitosis

Change gitosis location (optional):

    usermod -m -d /storage/gitosis gitosis

Create gitosis repo:

    sudo -H -u gitosis gitosis-init < ~/.ssh/id_rsa.pub

Configure gitosis for a new repo called myproject:

    git clone gitosis@localhost:gitosis-admin.git
    cd gitosis-admin
    cat << EOF >> gitosis.conf

    [group myteam]
    members = user@localhost
    # To allow access through the git:// protocol, uncomment the following
    # daemon = yes
    # To allow access through gitweb, uncomment the following
    # gitweb = yes
    writable = myproject
    EOF

Save changes to gitosis-admin:

    git commit -a -m "Added myproject to gitosis"
    git push

Setup your (existing) to push to gitosis:

    cd myproject
    git init
    git add .
    git commit -a -m "Initial import"
    git remote add origin gitosis@localhost:myproject.git
    git push origin master
    git config branch.master.remote origin
    git config branch.master.merge refs/heads/master

Give alice permission to your repo:

    cd gitosis-admin
    cp ~/alice.pub keydir/
    git add keydir/alice.pub

    # change your gitosis.conf
      [group myteam]
    - members = user@localhost
    + members = user@localhost alice

# Gitosis-Mirroring

How to mirror the foo.git gitosis repository in github.com? (same thing
works for bitbucket.org, gitorious.org, etc)

1.  Create a passwordless ssh-key for your gitosis user:

    sudo -u gitosis -H ssh-keygen -t rsa

2.  Add the new ssh key to your github account.
3.  Create an empty foo repository in github.
4.  Setup the mirror from gitosis -> github:

    sudo -u gitosis -H -s cd \~/repositories/foo.git
    git remote add github git@github.com:$user/$(basename `pwd`)
    echo -e '\#!/bin/sh\nexec git push --mirror github >> \~/github.log 2>&1' > hooks/post-update
    chmod 755 hooks/post-update
    hooks/post-update

# Grub-password

Generate password:

    yes password | grub-md5-crypt 2>/dev/null | tail -n1

Add password to grub:

    # Add to thge top of /boot/grub/menu.lst
    password --md5 ${md5password}

To hide the menu: hiddenmenu

# Customize-XSession

Create a startup script:

    cat << EOF > /etc/X11/Xsession.d/15mystart
    #!/bin/bash
    # To force gnome interface in open office
    # export OOO_FORCE_DESKTOP=gnome
    test -d "$HOME/.bin" && export PATH="$HOME/.bin:$PATH"
    if [ -d "$HOME/.latex" ]; then
        export TEXINPUTS=.:$HOME/.latex:
        export BSTINPUTS=$TEXINPUTS
        export BIBINPUTS=$TEXINPUTS
    fi
    EOF

# Terminal-Fonts-Size

To fix blurry fonts in gnome-terminal:

    cd /etc/fonts/conf.d
    rm 10-hinting-medium.conf
    ln -s ../conf.avail/10-hinting-full.conf
    rm 10-no-sub-pixel.conf
    ln -s ../conf.avail/10-sub-pixel-rgb.conf

To change the default size of the terminal:

    vim /usr/share/vte/termcap/xterm
    # the line with the following describes an 80x24 term
    :co#80:it#8:li#24:\

# WPA

Configure wpa\_supplicant:

    cat << EOF > /etc/wpa_supplicant.conf
    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev

    network = {
    ssid="ssidwithwpa"
    psk="password"
    key_mgmt=WPA-PSK
    }

    network = {
    ssid="ssidwithwep"
    key_mgmt=NONE
    wep_key0=HEXKEY
    }

    network={
    ssid="openssid"
    key_mgmt=NONE
    id_str="static_ssid"
    }

    network={
    key_mgmt=NONE
    }
    EOF

Edit /etc/network/interfaces and remove anything related to the wireless
interface and add the following:

    cat << EOF >> /etc/network/interfaces
    allow-hotplug wlan0
    iface wlan0 inet manual
        wpa-roam /etc/wpa_supplicant.conf
        wpa-driver wext

    iface default inet dhcp

    iface static_ssid inet static
        address 192.168.1.101
        netmask 255.255.255.0
        network 192.168.1.0
        broadcast 192.168.1.255
        gateway 192.168.1.1
    EOF

# network-config
==============

To setup an interface to be managed through dhcp, edit
/etc/network/interfaces and add the following:

    auto $iface
    allow-hotplug $iface
    iface $iface inet dhcp

The hotplug is only required for interfaces that can be physically
removed or turned-off (usually for laptops).

To setup an interface to be managed statically, edit
/etc/network/interfaces and add the following:

    auto $iface
    iface $iface inet static
            address 10.10.100.100
            gateway 10.10.1.1
            netmask 255.255.0.0
            dns-search example.com example.net
            dns-nameservers 10.10.1.2 10.10.1.2

See https://wiki.debian.org/NetworkConfiguration for more info.

# Grub-windows

Add your windows partition in /boot/grub/menu.lst:

    title WinXP
        rootnoverify (hd0,0)
        makeactive
        chainloader +1

# Debian-Favorite-Packages

Console:

    vim-gtk htop git curl tmux g++ nodejs openssh-server

GUI:

    inkscape gimp vlc pithos spotify

Latex:

    latex-beamer texlive-fonts-recommended texlive-latex-extra

Non-Free:

    skype acroread

Programming:

    build-essential manpages-dev autoconf automake libtool manpages-posix manpages-posix-dev console-setup imagemagick librsvg2-bin

Fonts:

    msttcorefonts ttf-foss ttf-inconsolata lmodern ttf-bpg-geoergian-fonts ttf-breip ttf-dustin ttf-f500 ttf-essays1743 ttf-georgewilliams ttf-isabella ttf-liberation ttf-staypuft ttf-summersby ttf-tuffy ttf-ubuntu-title

Remove:

    bluez ttf-arabeyes ttf-arphic-ukai ttf-arphic-uming ttf-baekmuk ttf-bengali-fonts ttf-devanagari-fonts ttf-gujarati-fonts ttf indic-fonts ttf-kannada-fonts ttf-kochi-gothic ttf-kochi-mincho ttf-lao ttf-malayalam-fonts ttf-oriya-fonts ttf-punjabi-fonts ttf-tamil-fonts ttf-telugu-fonts ttf-thai-tlwg cups

# Core-Dumps

To enable once:

    sysctl kernel.core_pattern="/tmp/core.%e.%p.%h.%t"
    sysctl fs.suid_dumpable=1
    ulimit -c unlimited

To persist across reboots:

    echo " * soft core unlimited" >> /etc/security/limits.conf
    echo "kernel.core_pattern=/tmp/core.%e.%p.%h.%t" >> /etc/sysctl.conf
    echo "fs.suid_dumpable=1 >> /etc/sysctl.conf

# Recover-HD

Go into server and dump your drive:

    ssh deadserver dd if=/dev/hda1 conv=noerror,sync > hda1.img

Mount your drive image and try to recover:

    losetup /dev/loop0 hda1.img
    reiserfsck --rebuilt-tree -S -l recover.log /dev/loop0

Other options are --rebuild-sb and --check, also try:

    mount /dev/loop0 /mnt/recovered
    look in /mnt/recovered or /mnt/recovered/lost+found
    umount /mnt/recovered
    losetup -d /dev/loop0

# Mounting dd image of drive (not partition)

1.  Use fdisk to determine the offset to the partition:

     fdisk -u drive.img
     # Command (m for help): p
     # Disk drive.img: 1024 MB, 1024966656 bytes
     # 32 heads, 62 sectors/track, 1009 cylinders, total 2001888 sectors
     # Units = sectors of 1 * 512 = 512 bytes

     #   Device Boot      Start         End      Blocks   Id  System
     #drive.img   *          62     2001855     1000897   83  Linux

Since the sectors are of size 512, and it starts at 62, the offset is
512\*62=31744

2.  Mount to examine the image:

    mount -r -o loop,offset=31744 drive.img /media/drive

# DVD-Rip

    mplayer dvd:/// -chapter 1-1  -dumpstream -dumpfile video.vob
    ffmpeg -i video.mp4 -f mp4 -vcodec mpeg4 -maxrate 1000 -b 700  -qmin 3 -qmax 5 -bufsize 4096 -g 300 -acodec aac -ab 96 -s 320x240 -aspect 4:3 video.mp4
    ffmpeg -i video -f mp4 -vcodec mpeg4 -maxrate 1000 -b 700  -qmin 3 -qmax 5 -bufsize 4096 -g 300 -acodec aac -ab 96 -s 320x240 -aspect 4:3 -map 0:0 -map 0:2 video.mp4


# CD/DVD-burning

Create an ISO from CD/DVD

    dd if=/dev/cdrom of=image.iso bs=1024

Create a BIN/CUE from CD/DVD

    cdrdao read-cd --read-raw --datafile image.bin --device 0,0,0 --driver generic-mmc-raw image.cue

Create an ISO from a folder (Use -RJ instead of -J to preserve
permissions+links)

    mkisofs -J -V 'title' -o image.iso /folder/

Mount an ISO (assumes loop module is loaded)

    mount image.iso /media/iso/ -t iso9660 -o loop

Burning ISO's

To get device first do

    cdrecord -scanbus

Assuming device = 1,1,0
    cdrecord -v dev=1,1,0 speed=48 [-multi] image.iso

Burning a cue/bin

    cdrdao write --device 0,0,0 --speed 48 somefile.cue

Burning DVD image

    growisofs -speed=8 -dvd-compat -Z /dev/dvdrw=image.iso

Duplicating a CD

    cdrdao copy --source-device /dev/cdrom --device /dev/cdrw --on-the-fly

Multisession burning

1. create the first ISO
2. burn and add the -multi flag
3. cdrecord -msinfo /dev/cdrw to get offset, assume 0,12639
4. create the second ISO, append -C 0,12639 to the command line
5. burn and add the -multi flag
6. goto step 3

# Debian-Replicating

On existing system do:

    dpkg --get-selections > /shared/selections

On new system do:

    dpkg --set-selections < /shared/selections
    apt-get dselect-upgrade

As an alternative for a cleaner more manual upgrade (on existing
system):

    dpkg -l | awk '/^ii/{ print $2 }' | grep -v -e ^lib -e -dev -e $(uname -r) > installed.txt

On the new system

    apt-get install $(cat installed.txt | tr '\n' ' ')

# Debian-Repository

To clean up your repository (remove old packages):

    apt-get autoclean

To create your own apt repository:

    dpkg-scanpackages /var/cache/apt/archives/ /dev/null 2> /dev/null | gzip > /var/cache/apt/archives/Packages.gz

Adding the apt a custom apt repository:

    echo deb ssh:remote: /var/cache/apt/archives/ >> /etc/apt/sources.list

# Debian-Package

## To build a package from source

    apt-get build-dep packagename
    apt-get source -b packagename

OR

    apt-get build-dep packagename
    apt-get source packagename
    dpkg-buildpackage -rfakeroot -us -uc

OR

    apt-get build-dep packagename
    apt-get source packagename
    debuild -b -us -uc

OR

    wget http://server/package.tbz2
    tar -xjvf package.tbz2
    cd package
    make
    checkinstall -D make install

OR

    wget http://server/package.orig.tar.gz
    wget http://server/package.diff.gz
    tar -xzvf package.orig.tar.gz
    pushd package
    zcat ../package.diff.gz | patch -p1
    fakeroot debian/rules binary
    popd

## To install the package

    dpkg -i packagename.deb

## To list files in the package

    dpkg -L packagename

## To remove the package (use -P instead of -r to purge):

    dpkg -r packagename

## To see to which package a file belongs

    dpkg -S file

## To extract the files of a package

    dpkg-deb -x packagename.deb outputdir

## To extract the control files of a package

    dpkg-deb -e packagename.deb outputdir

# rsync

Copy from local to remote (use -avPz if files are compressible):

    rsync -avP Folder remotehost:
    rsync -avP ~/Folder/ remotehost:Folder
    rsync -avP --rsync-path=.bin/rsync --exclude .svn/ Site/ user@server:public_html

Copy from remote to local rsync -avP remotehost:Folder/ \~/Folder

# Schroot

install sbuild:

    apt-get install sbuild schroot debootstrap

setup sbuild:

    sbuild-update --keygen
    sbuild-adduser $LOGNAME
    mkdir -p /var/lib/schroot/chroots

create schroot:

    # choose a chroot name
    CHROOT_NAME=precise-amd64
    # target directory to store chroot
    CHROOT_TARGET=/var/lib/schroot/chroots/$CHROOT_NAME
    # debian distribution, complete list in /usr/share/deboot-strap/scripts
    CHROOT_DISTRIBUTION=precise
    # sources.list mirror to use in chroot
    CHROOT_MIRROR=http://archive.ubuntu.com/ubuntu
    # components to use (i.e. main, contrib, non-free..)
    CHROOT_COMPONENTS=main,restricted,universe,multiverse
    # list of additional packages to install
    CHROOT_PACKAGES=apt-utils,pkg-create-dbgsym,pkgbinarymangler,sbuild

    sbuild-createchroot $CHROOT_DISTRIBUTION $CHROOT_TARGET $CHROOT_MIRROR --components=$CHROOT_COMPONENTS --include=$CHROOT_PACKAGES

fix bug https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=565613

    sed -i '/exim/d' $CHROOT_TARGET/var/lib/dpkg/statoverride

modify your source schroot:

    schroot -c source:$CHROOT_NAME -u root
    do stuff
    exit

# SSH-proxy

To setup a local socks proxy:

    ssh -nNT -D 8080 remoteserver
    chrome --proxy-server="socks5://localhost:8080"

To connect to host HostC, going through HostB, going through HostA:

    ssh -At HostA ssh -At HostB ssh -A HostC

Notice that the -t (create a pseudo-tty) is not required for the last
hop. The -A is used to forward the ssh-agent.

# SSH-nopass

Generate and copy key to remote host:

    ssh-keygen -t rsa (enter, enter)
    ssh-copy-id remotehost

To create a public/private key pair for someone else do:

    ssh-keygen -t rsa -C john@doe.net -f john_key

You may have to use the IdentityFile option in .ssh/config to
authenticate with a particular key.

To convert to putty format install putty-tools and do:

    puttygen privatekeyfile -O private -o privatekeyfile.ppk

# SSH-Tunnel

Consider two machines A and B, where A can ssh to machine B.

Setting 1: Machine A and wants to access www.nytimes.com which is
unreachable/blocked from A, but is reachable from B.

To access www.nytimes.com from A (using a tunnel that goes through B)
you can execute the following in A:

    ssh -nNT -L 1100:www.nytimes.com:80 B

Now A can access www.nytimes.com:80 by accessing instead localhost:1100.

Setting 2: Machine B wants to access mail.local.net which is
unreachable/blocked from B, but is reachable from A.

To access mail.local.net from B (using a tunnel that goes through A) you
can execute the following in A:

    ssh -nNT -R 1100:mail.local.net:80 B

Now B can access mail.local.net:80 by accessing instead localhost:1100.

# SSH-Restrict

To restrict to a given set of users, first edit the file
/etc/ssh/sshd\_config and add the following line:

    AllowUsers user1 user2 .. usern

For added security, disable all login methods except public key:

    UsePAM no
    ChallengeResponseAuthentication no
    PasswordAuthentication no

# Diff-Patches

Directories:

    diff -upr dir dir.fixed > changes.patch
    cp -a dir dir.patched
    cd dir.patched
    patch -p1 -i ../mychanges.patch

Files:

    diff -up file file.new > changes.patch
    patch -i changes.patch

# MySQL

    mysqladmin -u root password "newpass"
    mysql -u root -p
    create database dbname;
    use dbname;
    GRANT SELECT,INSERT,UPDATE,DELETE ON dbname.* to user@localhost IDENTIFIED BY "password";
    FLUSH PRIVILEGES;
    show databases;
    show tables;
    drop databasename;
    mysqldump --databases -u username -ppassword database > complete.sql
    mysqldump -u username -ppassword database -d > schema.sql
    mysqldump -u username -ppassword database -tn > data.sql
    mysqldump --add-drop-table -u username -ppassword database > complete.sql

# CVS

    export CVSROOT=/usr/local/CVS
    cvs -d $CVSROOT init
    cvs login
    cvs import -m"Project Name" Project start user
    cvs checkout project
    cvs export -DNOW project

# SVN

    SVNROOT=/usr/local/SVN
    svnadmin create --fs-type=fsfs $SVNROOT
    svn import -m"Project Name" Project file://$SVNROOT/Project
    svn checkout file://$SVNROOT/Project Project
    svn checkout svn+ssh://server$SVNROOT/Project Project
    svn export file://$SVNROOT/Project Project
    svnadmin dump $SVNROOT > svn.backup
    svnadmin load $SVNROOT < svn.backup

# SVN-to-HG

First create a directory to store your mercurial repository and make it
your working directory.

Then execute the following to convert:

    source_repo=file://$HOME/PATH_TO_REPO
    repos=`svn ls $source_repo | tr -d \/ | tr '\n' ' '`
    for repo in $repos; do
        hgimportsvn $source_repo/$repo
        cd $repo
        hgpullsvn
        hg update
        cd ..
    done
    find . -name .svn -exec rm -fR {} \;

In case you want to get rid of the default preferences:

    find . -name .hgignore -exec rm -f {} \;

# OpenSSL

To generate a private/public key pairs with password:

    openssl genrsa -des3 -out private.pem 4096

To generate a private/public key pair without password

    openssl genrsa -out private.pem 4096

To view a key

    openssl rsa -in private.pem -text

To extract the public key from the private key

    openssl rsa -in private.pem -pubout -out public.pem

To encrypt FILE to FILE.enc using the public key

    openssl rsautl -encrypt -inkey public.pem -pubin -in FILE -out FILE.enc

To decript FILE.enc to FILE using the private key

    openssl rsautl -decript -inkey private.pem -in FILE.enc -out FILE

To produce signature of FILE using private key

    openssl dgst -sha256 -sign private.pem -out signature FILE

To verify signature of FILE using public key

    openssl dgst -sha256 -verify public.pem -signature signature FILE

To extract the public key out of certificate

    openssl x509 -pubkey -noout -in certificate.crt -out public.pem

To view a certificate

    openssl x509 -in certificate.{crt,cer,pem} -text -noout

Encrypt-ENCFS:

To mount an encrypted volume:

    encfs ~/.hidden ~/visible

To unmount an encrypted volume:

    fusermount -u ~/visible

Install in Debian:

    apt-get install encfs

Install in OSX:

    brew install Caskroom/cask/osxfuse
    brew install encfs

# Encrypt-LOOPAES

Create image:

    dd if=/dev/urandom bs=1M count=100 of=file

Create device node with encryption:

    losetup -e aes256 /dev/loop0 file

Create filesystem:

    mkfs.ext2 /dev/loop0
    tune2fs -c 0 -i 0 /dev/loop0

Destroy device node:

    losetup -d /dev/loop0

To mount the encrypted filesystem:

    mount -o loop,encryption=aes256 -t ext2 file /media/secret

To unmount:

    umount /media/secret

# Encrypt-LUKS

Create image:

    dd if=/dev/urandom bs=1M count=100 of=file

Create encrypted device node pointing to file:

    losetup /dev/loop0 file
    cryptsetup luksFormat /dev/loop0

Make encrypted container avaialble in /dev/mapper/secret:

    cryptsetup luksOpen /dev/loop0 secret

Create filesystem:

    mkfs.ext2 /dev/mapper/secret
    tune2fs -c 0 -i 0 /dev/mapper/secret

Destroy device node:

    cryptsetup luksClose secret
    losetup -d /dev/loop0

In the future to mount the container again do: losetup /dev/loop0 file
cryptsetup luksOpen /dev/loop0 secret mount /dev/mapper/secret
/media/secret

Unmount the filesystem:

    umount /media/secret
    cryptsetup luksClose secret
    losetup -d /dev/loop0

# Share-Internet

The internet connection is on wlan0 and it wants to share this
connection with a computer (or group of computers) connected through
eth0.

At the server the following commands should be executed.

Enable ipv4 forwarding:

    sysctl net.ipv4.ip_forward=1
    execute sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

Setup forwarding rules:

    iptables -A FORWARD -o wlan0 -i eth0 -s 192.168.1.0/24 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A POSTROUTING -t nat -j MASQUERADE

Use forward (at client):

    route add default gw 192.168.1.154

# LAN-File-Transfer

On the receiving end (omit -p in BSD):

    PORT=${RANDOM}
    echo "listening on port ${PORT}"
    nc -l -p ${PORT} | tar xzvf -

On the sending end:

    tar czvf -  /Some/Folder | nc {HOST} ${PORT}

# vim-ctags

Run: `ctags --c++-kinds=+p -R .`

Shortcuts

    C-] (go to tag definition)
    C-t (go back on tag stack)
    g]  (go to tag definition)
    C-i (see prev line with tag)
    C-I (see all lines with tag)
    C-d (see macro definition)
    C-I (see all macro definitions)

# sudo

To enable password-less sudo access to current user:

    echo "${USER} ALL=(ALL)NOPASSWD: ALL" | sudo tee /etc/sudoers.d/${USER}-sudo

# brew

Console general tools:

    bash bash-completion autojump dict encfsmacosxfuse git-extras macvim tmux wget reattach-to-user-namespace htop-osx

Development:

    node mongodb

AVR utils

    avr-binutils avr-gcc avr-libc libftdi avrdude --with-usb qt pkg-config