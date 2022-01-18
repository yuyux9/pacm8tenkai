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

#~CHECK IS YOU CONNECTED TO THE WORLD~
echo " "
wget -q --spider http://google.com

if
  [ $? -eq 0 ]
then
  echo 'Ok, you are online, lets begin.'
else
  echo 'Seem like you are offline, where is nothing i can do without internet connection.'
  exit
fi

#~USER AGREEDMENT~
echo " "
read -p 'This script will install, set and deploy pacmate. To continue press y/n (to not): ' agree

if [ $agree == 'y' ]; then
  echo 'Lets begin then.'
elif [ $agree == 'n' ]; then
  echo 'Bye then.'
  exit
else
  echo 'Ha-ha, you soo funny...'
exit
fi

#~FUNCTION FOR EXISTENSE~
exists()
{
  command -v "$1" >/dev/null 2>&1
}

#~INSTALLIG PACMATE N CHECKING FOR GIT~
echo " "
read -p 'Checking for git, if it installed. If not, i will install it for you - y/n: ' lzt

if
  [ $lzt == 'n' ]
then
  echo 'Fuck you then.'
  exit
fi

if
  [ $lzt == 'y' ]
then
  exists git
  echo 'Git found!'
else
  echo 'Git not found. Installing.'
  apt install git -y
  echo 'Now you have git.'
fi

read -p 'Git was found, and im ready to install pacmate, are you ready - y/n: ' git

if
  [ $git == 'y' ]
then
git clone --recurse-submodules https://gitlab.com/packmate/Packmate.git && cd Packmate
touch ".env"
elif
  [ $git == 'n' ]
then
  echo 'What do you want from me then, kutabare.'
else
  echo 'fuck you.'
  exit
fi

#~SETTING UP PACKMATE~
echo " "
read -p 'Tell me ip of your game network: ' ip
read -p 'What username do you want: ' uname
read -p 'What password do you want: ' pass
read -p 'Now tell me name of your game interface: ' interface
read -p 'Ok, we are ready to make your config file, cawabanga - y/n: ' cawabanga

if
  [ $cawabanga == 'y' ]
then
  echo "PACKMATE_LOCAL_IP=$ip
PACKMATE_WEB_LOGIN=$uname
PACKMATE_WEB_PASSWORD=$pass
PACKMATE_MODE=LIVE
PACKMATE_INTERFACE=$interface" > '.env'

  echo 'Uuh, well, thats it, done.'
elif
  [ $cawabanga == 'n' ]
then
  echo 'There is need to be y, but you pick n, fuck you, uwu.'
else
  echo 'fuck you.'
  exit
fi

#~DEPLOYING PACMATE~
echo " "
read -p 'Checking for docker, if it installed. If not, i will install it for you - y/n: ' docker

if
  [ $docker == 'n' ]
then
  echo 'Fuck you then.'
  exit
fi

if
  [ $docker == 'y' ]
then
  exists git
  echo 'Docker found!'
else
  echo 'Docker not found. Installing.'
  apt install git -y
  echo 'Now you have docker.'
fi

read -p 'Checking for docker-compose, if it installed. If not, i will install it for you - y/n: ' lzt

if
  [ $lzt == 'n' ]
then
  echo 'Fuck you then.'
  exit
fi

if
  [ $lzt == 'y' ]
then
  exists git
  echo 'Docker-compose found!'
else
  echo 'Docker-compose not found. Installing.'
  apt install git -y
  echo 'Now you have docker-compose.'
fi



read -p 'Finally. Now we can deploy your pacmate and start analyzing some traffic! Make some noise - y/n: ' noise

if
  [ $noise == 'y' ]
then
  sudo docker-compose up --build -d
  echo " "
  echo 'Pacmate now running in background, to stop it, type: docker-compose down.'
  echo It should be on "$ip":65000
elif
  [ $noise == 'n' ]
then
  echo 'As you want, cap.'
fi

echo " "
echo "

⣿⣿⡆⠀⠀⢸⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇  ⣾⣿⡆⠀
⣿⣿⡇⠀⠀⢸⣿⢰⣿⡆⠀⣾⣿⡆⠀⣾⣷⣿⣿⡇⠀ ⣿⣿⡇⠀
⣿⣿⡇⠀⠀⢸⣿⠘⣿⣿⣤⣿⣿⣿⣤⣿⡇⢻⣿⡇⠀⠀⣿⣿⡇⠀
⣿⣿⡇⠀⠀⢸⡿⠀⢹⣿⣿⣿⣿⣿⣿⣿⠁⢸⣿⣇⠀⢀⣿⣿⠇⠀
⠙⢿⣷⣶⣶⡿⠁⠀⠈⣿⣿⠟⠀⣿⣿⠇⠀⠈⠻⣿⣶⣾⡿⠋
                          "
echo 'Thanks for using me, take care and good luck ^v^'
echo 'by yuyu from 893crew'
