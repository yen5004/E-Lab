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

# Update and upgrade options && Prompt user for action
echo "Select an option:"
echo "1. Perform sudo apt update and upgrade"
echo "2. Upgrade to kali-everything package"
echo "3. Just install tools"
read -p "Enter your choice [1-3]: " choice

case $choice in
    1)
        echo "Start machine update & upgrade - $(get_timestamp)" | tee -a $logg
        sudo apt update -y && sudo apt upgrade -y
        echo "Finish machine update & upgrade - $(get_timestamp)" | tee -a $logg
        ;;
    2)
        echo "Start machine update & full upgrade (kali-everything) - $(get_timestamp)" | tee -a $logg
        sudo apt update -y && sudo apt full-upgrade -y
        echo "Finish machine update & full upgrade (kali-everything) - $(get_timestamp)" | tee -a $logg
        ;;
    3)
        echo "Proceeding to install tools only - $(get_timestamp)" | tee -a $logg
        ;;
    *)
        echo "Invalid choice. Exiting."
        ;;
esac

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo "        "  | tee -a $logg
echo "       1"  | tee -a $logg
echo "      111" | tee -a $logg
echo "     11111"| tee -a $logg
echo "      111" | tee -a $logg
echo "       1"  | tee -a $logg
echo "        "  | tee -a $logg
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# apt installs:
echo "Begin APT installs..." | tee -a $logg

cd $HOME
# Function to get the version of the tool dynamically
get_tool_version() {
    command -v $1 >/dev/null 2>&1 || { echo "Tool $1 not found"; return; }

    version=$($1 --version 2>/dev/null || $1 -v 2>/dev/null || $1 version 2>/dev/null || echo "Version info not available")
    echo "$version"
}

# Function to install apt tools
function install_apt_tools() {
    echo "Starting install of apt tools"
    for tool in $@; do
        if ! dpkg -l | grep -q "^ii $tool"; then
            if sudo apt install -y "$tool"; then
                echo "Installed apt $tool - $(get_timestamp)" | tee -a $logg
                tool_version=$(get_tool_version $tool)
                echo "Version of $tool: $tool_version - $(get_timestamp)" | tee -a $logg
            else
                echo "Failed to install apt $tool - $(get_timestamp)" | tee -a $logg
            fi
        else
            echo "Tool $tool is already installed. $(get_timestamp)" | tee -a $logg
            tool_version=$(get_tool_version $tool)
            echo "Version of $tool: $tool_version - $(get_timestamp)" | tee -a $logg
        fi
    done
}

echo "Begin APT installs..." | tee -a $logg

cd $HOME

#list out tools for apt install below
install_apt_tools flameshot talk talkd pwncat openssl osslsigncode mingw-w64 nodejs npm nim cmake golang cmatrix cmatrix-xfont cowsay htop above sliver

# Special install for cheat:
cd $HOME

# Check if the 'cheat' tool is installed, and install it if not
echo "Checking install status of 'cheat' tool"
if ! command -v cheat >/dev/null 2>&1; then
    echo "Installing 'cheat'"
    cd /tmp \
    && wget https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz \
    && gunzip cheat-linux-amd64.gz \
    && sudo chmod +x cheat-linux-amd64 \
    && sudo mv cheat-linux-amd64 /usr/local/bin/cheat
    echo "Installed 'cheat' - $(get_timestamp)" | tee -a $logg

    # Add /usr/local/bin to PATH
    if ! echo $PATH | grep -q "/usr/local/bin"; then
        export PATH=$PATH:/usr/local/bin
        echo "Added /usr/local/bin to PATH - $(get_timestamp)" | tee -a $logg
    fi

    echo "Setting up cheat for the first time, standby..."
    yes | cheat scp
    echo "Set up of 'cheat' complete at: /usr/local/bin/cheat - $(get_timestamp)" | tee -a $logg
else
    echo "Tool 'cheat' is already installed. $(get_timestamp)" | tee -a $logg
fi


# Check if the 'MinIO' tool is installed, and install it if not
echo "Checking install status of 'MinIO' tool"
if ! command -v minio >/dev/null 2>&1; then
    echo "Installing 'MinIO'"
    if cd ~/"$project" && sudo mkdir -p minio_folder && cd ~/"$project"/minio_folder; then
        if wget https://dl.min.io/server/minio/release/linux-amd64/minio && sudo chmod +x minio; then
            echo "Installed 'MinIO' - $(get_timestamp)" | tee -a $logg
        else
            echo "Failed to download or set permissions for 'MinIO' - $(get_timestamp)" | tee -a $logg
        fi
    else
        echo "Failed to create or navigate to the directory - $(get_timestamp)" | tee -a $logg
    fi
else
    echo "Tool 'MinIO' is already installed. $(get_timestamp)" | tee -a $logg
fi

echo "Finished APT installs..." | tee -a $logg
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
"https://github.com/yen5004/pingr.git"
"https://github.com/yen5004/spinners.git"
"https://github.com/yen5004/THM_Shells.git"
"https://github.com/yen5004/THM_ENUM.git"
"https://github.com/yen5004/THM-Lateral-Movement-and-Pivoting.git"
"https://github.com/yen5004/2025_cmd_logr.git"
"https://github.com/yen5004/netmask_listr.git"

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
cd ~

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
echo "Installing 2025_cmd_logr ..."
cd $git_folder/2025_cmd_logr
sudo chmod 777 cmd_logr_install.sh
bash cmd_logr_install.sh
echo "Installed 2025_cmd_logr/cmd_logr_install at: $PWD - $(get_timestamp)" | tee -a $logg
cd $git_folder
source ~/.bashrc
source ~/.zshrc

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
