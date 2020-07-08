#!/bin/bash

#####	NAME:				Arch Install
#####	VERSION:			0.1
#####	DESCRIPTION:		Script Instalacao Arch Linux
#####	DATE OF CREATION:	07/07/2020
#####	WRITTEN BY:			KARAN LUCIANO SILVA 
#####	E-MAIL:				karanluciano1@gmail.com			
#####	DISTRO:				MANJARO LINUX
#####	LICENSE:			GPLv3 			
#####	PROJECT:			https://github.com/lkaranl/Arch_Scipt

pac(){
	mkfs.ext4 /dev/sda1
	mkswap /dev/sda2
	swapon /dev/sda2
	mount /dev/sda1 /mnt

	reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
	#pacstrap /mnt base base-devel linux-lts linux-firmware
	pacstrap /mnt base linux-lts
	genfstab -U -p /mnt >> /mnt/etc/fstab
	cp arch.sh /mnt
	arch-chroot /mnt /bin/bash
}

conf(){
	ln -sf /usr/share/zoneinfo/America/Cuiaba /etc/localtime
	hwclock --systohc
	echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
	echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
	locale-gen
	echo "arch" > /etc/hostname
	echo -e "127.0.0.1\tlocalhost.localdomain\tlocalhost" > /etc/hosts
	echo -e "::1\tlocalhost.localdomain\tlocalhost" >> /etc/hosts
	echo -e "127.0.1.1\tarch.localdomain\tarch" >> /etc/hosts
	echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
	curl -O https://download.sublimetext.com/sublimehq-pub.gpg && pacman-key --add sublimehq-pub.gpg && pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
	echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | tee -a /etc/pacman.conf
}

xorg(){
	pacman -Sy --noconfir
	pacman -S reflector --noconfirm
	reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
	pacman -Sy --noconfir
	pacman -S xorg xorg-server xorg-xinit xorg-apps xorg-twm xorg-xclock xterm xf86-video-vesa --noconfirm 	
	pacman -S networkmanager lightdm lightdm-gtk-greeter --noconfirm
	pacman -S wireless_tools wpa_supplicant dialog acpi acpid --noconfirm
	pacman -S alsa-utils ttf-dejavu i3-wm i3lock i3status i3-gaps --noconfirm
	pacman -S grub --noconfirm
	systemctl enable NetworkManager.service
	systemctl enable lightdm.service
	grub-install /dev/sda
	grub-mkconfig -o /boot/grub/grub.cfg		
	useradd -m -g users -G storage,power,wheel,audio,video -s /bin/bash karan
	echo "Senha karan"
	passwd karan
	echo -e "\nSenha root"
	passwd
}

pos(){
	pacman -S samba geany dmenu git wget firefox thunar gnome-calculator pavucontrol xfce4-screenshooter rxvt-unicode ttf-font-awesome lxappearance yad xdotool vim nano gparted neofetch qbittorrent lightdm-gtk-greeter-settings ffmpeg vlc zenity noto-fonts-emoji texstudio spyder redshift gimp libreoffice-fresh libreoffice-fresh-pt-br texlive-publishers texlive-latexextra python-sympy audacity feh pulseaudio sublime-text --noconfirm

	wget 

	mkdir -r /home/karan/Imagens/Wallpapers/
	wget https://github.com/lkaranl/Arch_Script/blob/master/Wallpaper/i3.png -o /home/karan/Imagens/Wallpapers/i3.png

}

case $1 in
	"--pac") pac
		;;
	"--pos") pos
		;;
	"--conf") conf
		;;	
	"--xorg") pre
		;;	
	*) cat <<EOF
		
		Instalador Arch Linux personalizado para mim

	--pac, Faz o pacstrap e o arch-chroot

	--conf, Configura as variaves ambiente e repositorios 

	--xorg, Instala o Grub, Xorg e i3wm, usuario e senha

	--pos, Instala os softwares
EOF
		exit 1
		;;
esac	
