# 30_create_bootimg.sh
#
# create elilo.conf for Relax & Recover
#
#    Relax & Recover is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.

#    Relax & Recover is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with Relax & Recover; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#

# finding elilo.efi is now done in the prep stage, not here.
# therefore ELILO_BIN for sure contains the full path to elilo.efi

mkdir $BUILD_DIR/mnt/boot
cp -L "$ELILO_BIN" $BUILD_DIR/mnt/boot || Error "Could not find $ELILO_BIN"
cp $BUILD_DIR/initrd.cgz $BUILD_DIR/mnt/boot

#VMLINUX_KERNEL=`find / -xdev -name "vmlinu*-${KERNEL_VERSION}"`
#cp "${VMLINUX_KERNEL}" $BUILD_DIR/mnt/boot/kernel

# KERNEL_FILE is defined in pack/Linux-ia64/30_copy_kernel.sh script
cp "${KERNEL_FILE}" $BUILD_DIR/mnt/boot/kernel || Error "Could not find ${KERNEL_FILE}"

echo "$VERSION_INFO" >$BUILD_DIR/mnt/boot/message

cat >"$BUILD_DIR/mnt/boot/elilo.conf" <<EOF
prompt
timeout=50

image=kernel
	label=rear
	initrd=initrd.cgz
	read-only
	append="ramdisk=512000 $CONSOLE  rhgb selinux=0"
EOF

ISO_FILES=( "${ISO_FILES[@]}" )
