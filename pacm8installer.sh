#!/usr/bin/env bash

#~WELCOME MESSAGE~
cat << "EOF"
                                                                             s                                   ..                     .    
                                                           u+=~~~+u.        :8                             < .z@8"`                    @88>  
 .d``                                  ..    .     :     z8F      `8N.     .88                  u.    u.    !@88E                      %8P   
 @8Ne.   .u         u           .    .888: x888  x888.  d88L       98E    :888ooo      .u     x@88k u@88c.  '888E   u          u        .    
 %8888:u@88N     us888u.   .udR88N  ~`8888~'888X`?888f` 98888bu.. .@*   -*8888888   ud8888.  ^"8888""8888"   888E u@8NL     us888u.   .@88u  
  `888I  888. .@88 "8888" <888'888k   X888  888X '888>  "88888888NNu.     8888    :888'8888.   8888  888R    888E`"88*"  .@88 "8888" ''888E` 
   888I  888I 9888  9888  9888 'Y"    X888  888X '888>   "*8888888888i    8888    d888 '88%"   8888  888R    888E .dN.   9888  9888    888E  
   888I  888I 9888  9888  9888        X888  888X '888>   .zf""*8888888L   8888    8888.+"      8888  888R    888E~8888   9888  9888    888E  
 uW888L  888' 9888  9888  9888        X888  888X '888>  d8F      ^%888E  .8888Lu= 8888L        8888  888R    888E '888&  9888  9888    888E  
'*88888Nu88P  9888  9888  ?8888u../  "*88%""*88" '888!` 88>        `88~  ^%888*   '8888c. .+  "*88*" 8888"   888E  9888. 9888  9888    888&  
~ '88888F`    "888*""888"  "8888P'     `~    "    `"`   '%N.       d*"     'Y"     "88888%      ""   'Y"   '"888*" 4888" "888*""888"   R888" 
   888 ^       ^Y"   ^Y'     "P'                           ^"====="`                 "YP'                     ""    ""    ^Y"   ^Y'     ""   
   *8E                                                                                                                                       
   '8>                                                                                                                                       
    "                                                                                                                                        
                                                                     [yuyu]
                                                                   [893crew~]

EOF

#~INSTALL GUM~
echo " "
if ! command -v gum &> /dev/null; then
    echo "gum not found, installing gum..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install -y gum
    if ! command -v gum &> /dev/null; then
        gum style --foreground 1 "Failed to install gum. Please install it manually."
        exit 1
    fi
    gum style --foreground 2 "gum installed successfully."
fi

#~CHECK IF YOU ARE CONNECTED TO THE WORLD~
echo " "
if wget -q --spider http://google.com; then
    gum style --foreground 2 --bold --margin "1" "Ok, you are online, let's begin."
else
    gum style --foreground 1 --bold --margin "1" "Seems like you are offline, I cannot ping google.com."
    exit 1
fi

#~USER AGREEDMENT~
echo " "
if ! gum confirm "This script will install, set, and deploy CulhwchFarm. Do you want to continue?"; then
    gum style --foreground 1 "User declined. Exiting..."
    exit 1
fi
  echo " "

#~OS CHECK~
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    gum style --foreground 1 "Error: /etc/os-release not found. Unable to determine the OS."
    if ! gum confirm "Unable to determine the OS. Do you want to continue anyway?"; then
        gum style --foreground 1 "Exiting due to inability to determine OS."
        exit 1
    fi
    OS="unknown"
fi

case $OS in
    "ubuntu")
        apt install ca-certificates curl gnupg lsb-release -y
        mkdir /etc/apt/demokeyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/demokeyrings/demodocker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/demokeyrings/demodocker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
        apt update -y
        apt install docker-ce docker-ce-cli containerd.io -y
        # Docker-compose is installed separately for Ubuntu
        curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        ;;

    "centos")
        yum install -y epel-release
        yum install -y ca-certificates curl gnupg lsb-release
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        yum install docker-ce docker-ce-cli containerd.io -y
        systemctl start docker
        systemctl enable docker
        ;;


    "debian")
        apt-get install ca-certificates curl gnupg lsb-release -y
        mkdir /etc/apt/demokeyrings && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/demokeyrings/demodocker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/demokeyrings/demodocker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
        apt-get update -y
        apt-get install docker-ce docker-ce-cli containerd.io -y
        # Docker-compose is installed separately for Ubuntu
        curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        ;;

    *)
        gum style --foreground 1 "Unsupported OS: $OS"
        if ! gum confirm "Your OS is not officially supported. Do you want to continue anyway?"; then
            gum style --foreground 1 "Exiting due to unsupported OS."
            exit 1
        fi
        ;;
esac

#~INSTALLIG PACKMATE N CHECKING FOR GIT~
echo " "
if ! command -v git &> /dev/null; then
    gum spin --spinner dot --title "Installing Git" -- apt install git -y
    gum style --foreground 2 "Git successfully installed!"
else
    gum style --foreground 2 "Git is already installed!"
fi

echo " "
if gum confirm "Git is ready. Do you want to clone Packmate?"; then
    git clone --recurse-submodules https://gitlab.com/yuyux9/Packmate.git
    cd Packmate
    touch .env
    gum style --foreground 2 "Packmate repository cloned successfully! Next we gonna setup it!"
else
    gum style --foreground 1 "What do you want from me then, kutabare..."
    exit 1
fi

#~SETTING UP PACKMATE~
echo " "
if gum confirm "Ready to setup your packmate?"; then
  ip=$(gum input --placeholder 'Tell me IP of your game network:')
  uname=$(gum input --placeholder 'What username do you want:')
  pass=$(gum input --placeholder 'What password do you want:')
  interface=$(gum input --placeholder 'Now tell me the name of your game interface:')
  pport=$(gum input --placeholder 'In the end of Q/A I need you to tell me your desired port:')

  echo "PACKMATE_LOCAL_IP=$ip
  PACKMATE_WEB_LOGIN=$uname
  PACKMATE_WEB_PASSWORD=$pass
  PACKMATE_MODE=LIVE
  OLD_STREAMS_CLEANUP_ENABLED=true
  OLD_STREAMS_CLEANUP_INTERVAL=5
  OLD_STREAMS_CLEANUP_THRESHOLD=240
  DB_PASSWORD=K604YnL3G1hp2RDkCZNjGpxbyNpNHTRA
  PACKMATE_INTERFACE=$interface" > '.env'

  cd docker && sed -i "s/65000/$pport/g" Dockerfile_app && cd ..
  gum style --foreground 2 "Uuh, well, that's it, done."
else
  gum style --foreground 1 "Configuration process aborted."
  exit
fi

#~DEPLOYING PACMATE~
echo " "
if ! command -v docker &> /dev/null; then
    gum spin --spinner dot --title "Installing Docker" -- apt install docker -y
    gum style --foreground 2 "Docker successfully installed!"
else
    gum style --foreground 2 "Docker is already installed!"
fi

if ! command -v docker-compose &> /dev/null; then
    gum spin --spinner dot --title "Installing Docker Compose" -- apt install docker-compose -y
    gum style --foreground 2 "Docker Compose successfully installed!"
else
    gum style --foreground 2 "Docker Compose is already installed!"
fi

echo " "
if gum confirm "Finally, do you want to deploy your packmate?"; then
    sudo docker-compose up --build -d
    gum style --foreground 2 --border double --border-foreground 3 --margin "1" --padding "1" \
    "PACMATE IS RUNNING ON - ${ip}:${pport} & PACkMATE CREDENTIALS - ${uname}//${pass}"
else
    gum style --foreground 1 "Deployment canceled by looser."
fi

echo " "
echo "

⣿⣿⡆⠀⠀⢸⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢸⣿⡇  ⣾⣿⡆⠀
⣿⣿⡇⠀⠀⢸⣿⢰⣿⡆⠀⣾⣿⡆⠀⣾⣷⣿⣿⡇⠀ ⣿⣿⡇⠀
⣿⣿⡇⠀⠀⢸⣿⠘⣿⣿⣤⣿⣿⣿⣤⣿⡇⢻⣿⡇⠀⠀⣿⣿⡇⠀
⣿⣿⡇⠀⠀⢸⡿⠀⢹⣿⣿⣿⣿⣿⣿⣿⠁⢸⣿⣇⠀⢀⣿⣿⠇⠀
⠙⢿⣷⣶⣶⡿⠁⠀⠈⣿⣿⠟⠀⣿⣿⠇⠀⠈⠻⣿⣶⣾⡿⠋
                          "
gum style --foreground 6 --bold --align center "Thanks for using me, take care and good luck ^v^"
gum style --foreground 6 --bold --align center "by yuyu from 893crew"
