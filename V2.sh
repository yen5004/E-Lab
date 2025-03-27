#!/bin/bash
# Helper script to assist in loading of recommended tools for E Labs & tools

# Check if the script is running with sudo privileges
if [ $(id -u) -ne 0 ]; then
  echo "This script requires sudo privileges. Exiting."
  exit 1
fi

# Relevant files will be stored here
echo "Clearing screen before we start..."
sleep 2 && clear

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Declare variables

# Create time stamp function
get_timestamp() {
  # Display date time as "01Jun2024_01:30:00-PM"
  date +"%d%b%Y_%H:%M:%S-%p"
}

project="E-Lab" # Main folder for storage of downloads
folder="$HOME/$project" # Path to project folder where downloads will go
logg="$folder/install_log" # Log used to record where programs are stored
git_folder="$folder/GitHub" # Folder used to store GitHub repos
go_folder="$folder/Golang_folder"

# Check to see if the "project" folder exists in home directory and, if not, create one
if [ ! -d "$folder" ]; then
  echo "$project folder not found. Creating..."
  mkdir "$folder"
  echo "$project folder created successfully."
else  
  echo "$project folder already exists. - $(get_timestamp)" | tee -a $logg
fi

# Create install_log
cd $folder
if [ ! -f "$logg" ]; then
    echo "install_log not found. Creating..."
    touch "$logg"
    chmod 644 "$logg" # Secure permissions for the install log
    echo "install_log created successfully. - $(get_timestamp)" | tee -a $logg
else
    echo "install_log already exists. - $(get_timestamp)" | tee -a $logg
fi

echo "Install log located at $logg - $(get_timestamp)" | tee -a $logg
echo "Install log created, begin tracking - $(get_timestamp)" | tee -a $logg

# Open a new terminal to monitor install_log
gnome-terminal --window --profile=default -- bash -c "watch -n .5 tail -f $logg"
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
        exit 1
        ;;
esac

# Create git_folder
cd $folder
if [ ! -f "$git_folder" ]; then
    echo "GitHub folder not found. Creating..."
    mkdir GitHub
    chmod 644 "$git_folder" # Secure permissions for the install log
    echo "GitHub folder created successfully. - $(get_timestamp)" | tee -a $logg
else
    echo "GitHub folder already exists. - $(get_timestamp)" | tee -a $logg
fi

# Create Golang_folder
cd $folder
if [ ! -f "$go_folder" ]; then
    echo "Golang_folder not found. Creating..."
    mkdir "$Golang_folder"
    chmod 644 "$Golang_folder" # Secure permissions for the Golang_folder
    echo "Golang_folder created successfully. - $(get_timestamp)" | tee -a $logg
else
    echo "Golang_folder already exists. - $(get_timestamp)" | tee -a $logg
fi

# APT installs:
echo "Begin APT installs..." | tee -a $logg

# Function to get the version of the tool dynamically
get_tool_version() {
    command -v $1 >/dev/null 2>&1 || { echo "Tool $1 not found"; return; } | tee -a $logg

    version=$($1 --version 2>/dev/null || $1 -v 2>/dev/null || $1 version 2>/dev/null || echo "Version info not available")
    echo "$version"
}

# Function to install apt tools
function install_apt_tools() {
    echo "Starting install of apt tools"
    for tool in $@; do
        if ! dpkg -l | grep -q "^ii $tool"; then
            echo "$tool is not installed. Installing..."
            if sudo apt install -y "$tool"; then
                echo "Installed apt $tool - $(get_timestamp)" | tee -a $logg
                tool_version=$(get_tool_version $tool)
                echo "Version of $tool: $tool_version - $(get_timestamp)" | tee -a $logg
            else
                echo "FAILED TO INSTALL APT TOOL: $tool - $(get_timestamp)" | tee -a $logg
            fi
        else
            echo "Tool $tool is already installed. $(get_timestamp)" | tee -a $logg
            tool_version=$(get_tool_version $tool)
            echo "Version of $tool: $tool_version - $(get_timestamp)" | tee -a $logg
        fi
    done
}

# List out tools for apt install below
install_apt_tools flameshot talk talkd pwncat openssl osslsigncode mingw-w64 nodejs npm nim cmake golang cmatrix cmatrix-xfont cowsay htop above sliver wget hashcat cherrytree responder unzip python3-pip pipx grip pandoc markdown

echo "Finished APT installs..." | tee -a $logg

# Clone and install GitHub repos:
repo_urls=(
"https://github.com/itm4n/PrivescCheck.git"
"https://github.com/SnaffCon/Snaffler.git"
"https://github.com/sc0tfree/updog.git"
"https://github.com/yen5004/uptux.git"
"https://github.com/yen5004/vim-cheat-sheet.git"
"https://github.com/gentilkiwi/mimikatz.git"
"https://github.com/yen5004/ZIP_TAR.git"
"https://github.com/kubescape/kubescape.git"
"https://github.com/octarinesec/kube-scan.git"
""
""
"https://github.com/andrewjkerr/security-cheatsheets.git"
"https://github.com/cheat/cheat.git"
""
"https://github.com/peass-ng/PEASS-ng.git"
""
"https://github.com/tmux-plugins/tmux-logging.git"
"https://github.com/yen5004/cheat_helper.git"
"https://github.com/tmux-plugins/tpm.git"
"https://github.com/tmux-plugins/list.git"
"https://github.com/yen5004/netmask_listr.git"
"https://github.com/yen5004/simple_webpage.git"
"https://github.com/yen5004/reverse-shell-generator.git"
"https://github.com/yen5004/UART-Hacking.git"
"https://github.com/yen5004/peirates.git"
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
"https://github.com/pyserial/pyserial.git"
"https://github.com/yen5004/LOLBAS.git"
"https://github.com/yen5004/1-liner-keep-alive.git"
"https://github.com/yen5004/pingr.git"
"https://github.com/yen5004/spinners.git"
"https://github.com/yen5004/THM_Shells.git"
"https://github.com/yen5004/THM_ENUM.git"
"https://github.com/yen5004/THM-Lateral-Movement-and-Pivoting.git"
"https://github.com/yen5004/2025_cmd_logr.git"
"https://github.com/yen5004/netmask_listr.git"
)

# Clone repositories
for repo_url in "${repo_urls[@]}"; do
  repo_name=$(basename "$repo_url" .git) # Extract repo name from URL
  if [ ! -d "$git_folder/$repo_name" ]; then
    echo "Cloning $repo_name from $repo_url... - $(get_timestamp)" | tee -a $logg
    git clone "$repo_url" "$git_folder/$repo_name" || echo "FAILED TO CLONE REPO: $repo_name - $(get_timestamp)" | tee -a $logg
  else
    echo "Repo $repo_name already cloned at $git_folder/$repo_name. - $(get_timestamp)" | tee -a $logg
  fi 
done

########
#########
###########
# Custom Installs
###########
#########
########

# Install and prepare pipx
echo "installing pipx - $(get_timestamp)" | tee -a $logg
python3 -m pip install --user pipx || echo "FAILED TO INSTALL PIPX - $(get_timestamp)" | tee -a $logg
export PATH=$PATH:~/.local/bin
source ~/.bashrc  # Or `source ~/.zshrc` if you're using Zsh
source ~/.zshrc  # Or `source ~/.bashrc` if you're using Bash
pipx --version "$(get_timestamp)" | tee -a $logg
echo "Installed pipx - $(get_timestamp)" | tee -a $logg

# Install Kubectl
echo "Installing Kubescape..." | tee -a $logg
# Install required dependencies
sudo apt install -y apt-transport-https ca-certificates curl
# Download the latest release of kubectl
curl -LO "https://dl.k8s.io/release/v1.27.2/bin/linux/amd64/kubectl"
# Make kubectl executable
chmod +x kubectl
# Move kubectl to a directory in your PATH
sudo mv kubectl /usr/local/bin/
# Verify the installation
kubectl version --client | tee -a $logg
echo "kubescape installation completed - $(get_timestamp)" | tee -a $logg

# Install Kubescape
echo "Installing Kubescape... - $(get_timestamp)" | tee -a $logg
Kubescape_url="curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash"
Kubescape_folder="$git_folder/kubescape"
mkdir -p "$Kubescape_folder"
cd "$Kubescape_folder"
curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash || echo "FAILED TO DOWNLOAD KUBSCAPE - $(get_timestamp)" | tee -a $logg
sudo ln -s "$Kubescape_folder" /usr/local/bin/kubescape
kubescape --version | tee -a $logg
cd ~
echo "kubescape installation completed - $(get_timestamp)" | tee -a $logg

# Install updog
cd $folder
echo "Installing updog ...  - $(get_timestamp)" | tee -a $logg
pip3 install git+https://github.com/revoltchat/updog.git || echo "FAILED TO INSTALL UPDOG - $(get_timestamp)" | tee -a $logg
echo "Installed updog - $(get_timestamp)" | tee -a $logg


# Download and extract PsTools
pstools_url="https://download.sysinternals.com/files/PSTools.zip"
cd "$folder"
pstools_folder="$folder/PSTools"
mkdir -p "$pstools_folder"
cd "$pstools_folder"
wget "$pstools_url" -O PSTools.zip || echo "FAILED TO DOWNLOAD PSTOOLS - $(get_timestamp)" | tee -a $logg
unzip PSTools.zip
echo "PsTools download and extraction completed!" | tee -a $logg

# Download SharpHound.exe
cd "$folder"
sharphound_url="https://github.com/SpecterOps/SharpHound/releases/latest/download/SharpHound.exe"
sharphound_folder="$folder/SharpHound_exe"
mkdir -p "$sharphound_folder"
cd "$sharphound_folder"
wget "$sharphound_url" -O SharpHound.exe || echo "FAILED TO DOWNLOAD SHARPHOUND.EXE - $(get_timestamp)" | tee -a $logg
echo "SharpHound.exe download completed!" | tee -a $logg

