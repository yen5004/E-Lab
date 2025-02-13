#!/bin/bash
#Helper script to assist in loading of github repos and setting up kits

#Relevant files will be stored here
sudo ls # get sudo before we start
echo "Clearing screen before we start..."
sleep 2 && clear

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Declare variables

# Create time stamp function
get_timestamp() {
  # display date time as "01Jun2024_01:30:00-PM"
  date +"%d%b%Y_%H:%M:%S-%p"
}

project="E-Lab" # Main folder for storage of downloads
folder="$HOME/$project" # Path to project folder where downloads will go
logg="$folder/install_log" # Log used to record where programs are stored
git_folder="$folder/GitHub" # Folder used to store GitHub repos
go_folder="$folder/Golang_folder"

#check to see if the "project" folder exists in home directory and, if not create one
cd ~
if [ ! -d "$folder" ]; then
  echo "$project folder not found. Creating..."
  mkdir "$folder"
  echo "$project folder created successfully. - $(get_timestamp)" | tee -a $logg
  echo "$project folder located here: " ls -la | grep $folder
else  
  echo "$project folder already exists. - $(get_timestamp)" | tee -a $logg
fi

#change to the default folder
cd $folder

#create install_log
if [ ! -d "$folder/install_log" ]; then
    echo "install_log not found. Creating..."
    sudo touch "$folder/install_log"
    sudo chmod 777 "$folder/install_log" # install_log reffered to var name $logg
    echo "install_log created successfully. - $(get_timestamp)" | tee -a $logg
else
    echo "install_log folder already exists. - $(get_timestamp)" | tee -a $logg
fi

echo "Install log located at $folder/install_log - $(get_timestamp)" | tee -a $logg
echo "Install log created, begin tracking - $(get_timestamp)" | tee -a $logg

# Open a new terminal to monitor install_log
sudo apt install -y gnome-terminal
echo "Opening new terminal to monitor install_log..."
gnome-terminal --window --profile=AI -- bash -c "watch -n .5 tail -f $logg"
sleep 3

# Update and upgrade machine ########
###echo "Start machine update & full upgrade - $(get_timestamp)" >> $logg
#sudo apt update -y && sudo apt upgrade -y #for normal updates
#sudo apt update -y && sudo apt full-upgrade -y #everything upgrade
###echo "Finish machine update & full upgrade - $(get_timestamp)" >> $logg

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# apt installs:

cd $HOME
function install_apt_tools() {
	echo "starting install of apt tools"
 	for tool in $@; do
		if ! dpkg -l | grep -q "^ii $tool"; then
			sudo apt install -y "$tool" && echo "Installed apt $tool - $(get_timestamp)" | tee -a $logg
	else
		echo "Tool $tool is already installed. $(get_timestamp)" | tee -a $logg
	fi
    done
}

#list out tools for apt install below
install_apt_tools flameshot talk talkd pwncat openssl osslsigncode mingw-w64 nodejs npm nim cmake golang cmatrix cowsay htop above sliver

# Special install for cheat:
cd $HOME

#Check if the 'cheat' tool is installed, and install it if not
echo "Checking install status of 'cheat' tool"
if ! command -v cheat >/dev/null 2>&1; then
    echo "Installing 'cheat'"
    cd /tmp \
    && wget https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz \
    && gunzip cheat-linux-amd64.gz \
    && sudo chmod +x cheat-linux-amd64 \
    && sudo mv cheat-linux-amd64 /usr/local/bin/cheat
    echo "Installed 'cheat' - $(get_timestamp)" | tee -a $logg
    echo "Setting up cheat for the first time, standby..."
    yes | cheat scp
    echo "Set up of 'cheat' complete at: /usr/local/bin/cheat - $(get_timestamp)" | tee -a $logg
else
    echo "Tool 'cheat' is already installed. $(get_timestamp)" | tee -a $logg
fi

#Check if the 'MinIO' tool is installed, and install it if not
echo "Checking install status of 'MinIO' tool"
if ! command -v MinIO >/dev/null 2>&1; then
    echo "Installing 'MinIO'"
    cd ~/$project \
    && sudo mkdir minio_folder \
    && cd ~/$project/minio_folder \
    && wget https://dl.min.io/server/minio/release/linux-amd64/minio
    && sudo chmod +x minio \
    && cd ~
    echo "Installed 'MinIO' - $(get_timestamp)" | tee -a $logg
else
    echo "Tool 'MinIO' is already installed. $(get_timestamp)" | tee -a $logg
fi





#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Check to see if "gitlab" folder exists in project directory and if not creates one
# Create github folder for downloads:

if [ ! -d "$git_folder" ]; then
  echo "$git_folder folder not found. Creating..."
  sudo mkdir "$git_folder" && sudo chmod 777 "$git_folder"
  echo "$git_folder folder created successfully. - $(get_timestamp)" | tee -a $logg
else  
  echo "$git_folder folder already exists" | tee -a $logg
fi

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

cd $git_folder
# Download the following gitlab repos:
repo_urls=(
# List of GitLab reps urls:
"https://github.com/frizb/MSF-Venom-Cheatsheet.git"
"https://github.com/swisskyrepo/PayloadsAllTheThings.git"
"https://github.com/andrewjkerr/security-cheatsheets.git"
"https://github.com/cheat/cheat.git"
"https://github.com/itm4n/PrivescCheck.git"
"https://github.com/peass-ng/PEASS-ng.git"
"https://github.com/MWR-CyberSec/PXEThief.git"
"https://github.com/tmux-plugins/tmux-logging.git"
"https://github.com/yen5004/cheat_helper.git"
"https://github.com/tmux-plugins/tpm.git"
"https://github.com/tmux-plugins/list.git"
"https://github.com/SnaffCon/Snaffler.git"
"https://github.com/0dayCTF/reverse-shell-generator.git"
"https://github.com/sc0tfree/updog.git"
"https://github.com/yen5004/netmask_listr.git"
"https://github.com/yen5004/simple_webpage.git"
"https://github.com/yen5004/reverse-shell-generator.git"
"https://github.com/yen5004/UART-Hacking.git"
"https://github.com/yen5004/Seatbelt.git"
"https://github.com/yen5004/cyber_plumbers_handbook_lab_info.git"
"https://github.com/yen5004/bashscan.git"
"https://github.com/yen5004/awesome-pentest-cheat-sheets.git"
"https://github.com/yen5004/Bash-Oneliner.git"
"https://github.com/yen5004/uptux.git"
"https://github.com/yen5004/cipherscan.git"
"https://github.com/yen5004/PayloadsAllTheThings.git"
"https://github.com/yen5004/MSF-Venom-Cheatsheet.git"
"https://github.com/yen5004/sliver.git"
"https://github.com/yen5004/webshells.git"
"https://github.com/yen5004/pupy.git"
"https://github.com/yen5004/vim-cheat-sheet.git"
"https://github.com/yen5004/LaZagne.git"
"https://github.com/yen5004/LOLBAS.git"
"https://github.com/yen5004/1-liner-keep-alive.git"
""
""
""
""
""




""
)

# Directory of where repos will be cloned:

echo "       ^"  | tee -a $logg
echo "      ^^^" | tee -a $logg
echo "     ^^^^^"| tee -a $logg
echo "      ^^^" | tee -a $logg
echo "       ^"  | tee -a $logg


for repo_url in "${repo_urls[@]}"; do
  repo_name=$(basename "$repo_url" .git) # Extract repo name from url
  if [ ! -d "$git_folder/$repo_name" ]; then # Check if directory already exists
  echo "Cloning $repo_name from $repo_url... - $(get_timestamp)" | tee -a $logg
  #sudo git clone "repo_url" "$git_folder/$repo_name" || { echo "Failed to clone $repo_name"; exit 1; } # Clone repo and handle errors
  sudo git clone "$repo_url" "$git_folder/$repo_name" || { echo "Failed to clone $repo_name"; exit 1; } # Clone repo and handle errors
  else
  	echo "Repo $repo_name already cloned at $git_folder/$repo_name. - $(get_timestamp)" | tee -a $logg
  fi 
done

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Special Git installs:

#tmux plug in for scripting
sudo cp $git_folder/tpm ~/.tmux/plugins/tpm
echo 'set -g @plugin "tmux-plugins/tmux-logging' >> ~/.tmux.conf
tmux source ~/.tmux.conf
~/.tumux/plugins/tpm/scripts/install_plugins.sh
echo "Tmux-logging plugin installed - $(get_timestamp)" | tee -a $logg


# Special install for CyberChef:
#if ! command -v Cyberchef >/dev/null 2>&1; then
#    echo "Cyberchef not found. Installing ..."
#    cd $git_folder && sudo chmod 777 CyberChef && cd CyberChef
#    sudo npm install
#    echo "export NODE_OPTIONS=--max_old_space_size=2048" >> ~/.bashrc
#    source ~/.bashrc  # Reload the .bashrc
#    echo "Installed CyberChef at: $PWD - $(get_timestamp)" | tee -a $logg
##    cd $git_folder
#else
#    echo "CyberChef is already installed - $(get_timestamp)" | tee -a $logg
#    cd $git_folder
#fi

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Python installs

# Start  python install of Ciphey
#cd $git_folder
#python3 -m pip install ciphey --upgrade
#echo "Installed Ciphey - $(get_timestamp)" | tee -a $logg
#cd $git_folder

# Start python install of updog
cd $git_folder
pip3 install updog
echo "Installed updog - $(get_timestamp)" | tee -a $logg
cd $git_folder

# Start python install of UART-Hacking
cd $git_folder
pip3 install pyserial
pip3 install dbus-python
cd UART-Hacking
echo "This is working directory: " pwd
pip3 install -r requirements.txt
echo "Installed UART-Hacking - $(get_timestamp)" | tee -a $logg
cd $git_folder

# Start python install of LaZagne
cd $git_folder
cd LaZagne
echo "This is working directory: " pwd
pip3 install -r requirements.txt
echo "Installed LaZagne - $(get_timestamp)" | tee -a $logg
cd $git_folder




#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Golang installs:

# Special install for ScareCrow:
#echo "Start ScareCrow install"
#cd $git_folder
## Re-stating variable" go_folder="$folder/Golang_folder"
#check to see if "Golang_folder" folder exisits in $git_folder and if not creates one
#if [ ! -d "go_folder" ]; then
#	echo "Golang_folder not found. Creating..."
#	sudo mkdir -p "$go_folder" && sudo chmod 777 "$go_folder" && cd "$go_folder" || exit 1
#	echo "Golang_folder created at: $PWD - $(get_timestamp)" | tee -a $logg
# 	cd $gofolder
#else
#	echo "Golang_folder already exists at: $PWD - $(get_timestamp)" | tee -a $logg
# 	cd $gofolder
#fi

# Special install for Flamingo:
cd $git_folder
go get -u -v github.com/atredispartners/flamingo
#sudo chmod 777 flamingo && cd flamingo
go install -v github.com/atredispartners/flamingo
echo "Installed Flamingo at: $git_folder/flamingo - $(get_timestamp)" | tee -a $logg


###############################
# Install command logger

cd $git_folder
sudo mkdir log && sudo chmod 777 log && cd log
sudo touch cmd_logr_install.sh && sudo chmod 777 cmd_logr_install.sh
cat << 'EOF' > cmd_logr_install.sh
#Install logger script
echo "###########_Custom Script Below_###########" | tee -a ~/.zshrc
echo "Script created by Franco M." | tee -a ~/.zshrc
echo "###########_Custom Script Below_###########" | tee -a ~/.bashrc
echo "Script created by Franco M." | tee -a ~/.bashrc

#Prompt username
echo "Please enter your username"

#Read user input 
read -r name

#Store username in the .zshrc
echo "export NAME=$name" >> ~/.zshrc

#Display time in terminal
#echo 'RPROMPT="[%D{%m/%f/%Y}|%D{%L:%M}]"' >> ~/.zshrc
echo 'RPROMPT="[%D{%d%b%Y}|%D{%L:%M}]"' >> ~/.zshrc

#Sent logs to a file with time stamp
echo 'test "$(ps -ocommand= -p $PPID | awk '\''{print $1}'\'')" == '\''script'\'' || (script -a -f $HOME/log/$(date +"%F")_shell.log)' >> ~/.zshrc

#Confirm user is stored and display IP info and more
echo "echo TED-User: '$name'" >> ~/.zshrc
echo "ifconfig" >> ~/.zshrc
echo "NOTE: Use EXIT to close Log Script" >> ~/.zshrc
echo "NOTE: Use EXIT to close Log Script"
echo 'echo $note' >> ~/.zshrc

#Store username in the .bashrc
echo "export NAME=$name" >> ~/.bashrc
#echo 'RPROMPT="[%D{%m/%f/%Y}|%D{%L:%M}]"' >> ~/.bashrc
echo 'RPROMPT="[%D{%d%b%Y}|%D{%L:%M}]"' >> ~/.bashrc  

#Sent logs to a file with time stamp
echo 'test "$(ps -ocommand= -p $PPID | awk '\''{print $1}'\'')" == '\''script'\'' || (script -a -f $HOME/log/$(date +"%F")_shell.log)' >> ~/.bashrc

#Confirm user is stored and display IP info and more
echo "TED-User: '$name'" >> ~/.bashrc
echo "ifconfig" >> ~/.bashrc
echo 'note="use exit to  close script"' >> ~/.bashrc
echo 'echo $note' >> ~/.bashrc
echo "Command logger install complete"
echo "cmd_logr_install.sh finished!"

EOF

echo "Copied 'cmd_logr_install.sh' at: $PWD - $(get_timestamp)" | tee -a $logg
./cmd_logr_install.sh
echo "Installed 'cmd_logr_install.sh' at: $PWD - $(get_timestamp)" | tee -a $logg
cd $git_folder

################
# Install More_dots bashrc/zshrc custom dot files
cd $git_folder
cd More_dots
sudo chmod 777 add_aliases.sh
./add_aliases.sh
echo "Installed 'add_aliases.sh' at: $PWD - $(get_timestamp)" | tee -a $logg
cd $git_folder

################
# Install cheat_helper personalized cheats
cd $git_folder
cd cheat_helper
sudo chmod 777 personal_cheatsheets.sh
./personal_cheatsheets.sh
echo "Installed 'personal_cheatsheets.sh' at: $PWD - $(get_timestamp)" | tee -a $logg
cd $git_folder

echo "Install completed - $(get_timestamp)" | tee -a $logg
