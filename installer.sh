#!/bin/bash

red="\e[0;91m"
green="\e[0;92m"
bold="\e[1m"
reset="\e[0m"

if [ "$EUID" -ne 0 ]; then
	echo -e "${red}Please run as root";
	exit 1
fi

status(){
  clear
  echo -e $green$@'...'$reset
  sleep 1
}

runCommand(){
    COMMAND=$1

    if [[ ! -z "$2" ]]; then
      status $2
    fi

    eval $COMMAND;
    BASH_CODE=$?
    if [ $BASH_CODE -ne 0 ]; then
      echo -e "${red}An error occurred:${reset} ${white}${COMMAND}${reset}${red} returned${reset} ${white}${BASH_CODE}${reset}"
      exit ${BASH_CODE}
    fi
}

function installApache() {
    runCommand "apt update -y && apt install -y apache2" "Installing Apache"
}

function installMySQL() {
    runCommand "apt update -y && apt install -y mysql-server" "Installing MySQL"
}

function installPHP() {
    runCommand "apt update -y && apt install -y php libapache2-mod-php php-mysql" "Installing PHP"
}

function installNode() {
    runCommand "curl -fsSL https://deb.nodesource.com/setup_14.x | bash -" "Setting up Node.js repository"
    runCommand "apt install -y nodejs" "Installing Node.js"
}

function installMongoDB() {
    runCommand "apt update -y && apt install -y mongodb" "Installing MongoDB"
}

function installDocker() {
    runCommand "apt update -y && apt install -y docker.io" "Installing Docker"
}

function installFramework() {
    local framework=$1
    case $framework in
        react)
            runCommand "npx create-react-app my-app" "Installing React"
            ;;
        angular)
            runCommand "npm install -g @angular/cli && ng new my-app" "Installing Angular"
            ;;
        vue)
            runCommand "npm install -g @vue/cli && vue create my-app" "Installing Vue.js"
            ;;
        laravel)
            runCommand "composer global require laravel/installer && laravel new my-app" "Installing Laravel"
            ;;
        *)
            echo -e "${red}Unknown framework: $framework${reset}"
            exit 1
            ;;
    esac
}

function configureSSL() {
    runCommand "apt update -y && apt install -y certbot python3-certbot-apache" "Installing Certbot"
    runCommand "certbot --apache" "Configuring SSL with Let's Encrypt"
}

function setupDatabase() {
    local db_type=$1
    local db_name=$2
    local db_user=$3
    local db_pass=$4

    case $db_type in
        mysql)
            runCommand "mysql -e \"CREATE DATABASE $db_name;\"" "Creating MySQL database"
            runCommand "mysql -e \"CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_pass';\"" "Creating MySQL user"
            runCommand "mysql -e \"GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';\"" "Granting privileges to MySQL user"
            ;;
        mongodb)
            runCommand "mongo --eval 'db.createUser({user: \"$db_user\", pwd: \"$db_pass\", roles: [{role: \"readWrite\", db: \"$db_name\"}]})'" "Creating MongoDB user"
            ;;
        *)
            echo -e "${red}Unknown database type: $db_type${reset}"
            exit 1
            ;;
    esac
}

function main(){
    echo -e "${bold}Usage: bash <(curl -s https://raw.githubusercontent.com/Lucentix/web-app-installer/main/installer.sh) [OPTIONS]${reset}"
    echo "Options:"
    echo "  -h, --help                      Display this help message."
    echo "      --non-interactive           Skip all interactive prompts by providing all required inputs as options."
    echo "  -a, --apache                    Install Apache."
    echo "  -m, --mysql                     Install MySQL."
    echo "  -p, --php                       Install PHP."
    echo "  -n, --node                      Install Node.js."
    echo "  -d, --docker                    Install Docker."
    echo "  -f, --framework <name>          Install a specific framework (react, angular, vue, laravel)."
    echo "  -s, --ssl                       Configure SSL with Let's Encrypt."
    echo "  -db, --database <type> <name> <user> <password>  Setup a database."
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help)
            main
            exit 0
            ;;
        --non-interactive)
            non_interactive=true
            shift
            ;;
        -a|--apache)
            installApache
            shift
            ;;
        -m|--mysql)
            installMySQL
            shift
            ;;
        -p|--php)
            installPHP
            shift
            ;;
        -n|--node)
            installNode
            shift
            ;;
        -d|--docker)
            installDocker
            shift
            ;;
        -f|--framework)
            installFramework "$2"
            shift 2
            ;;
        -s|--ssl)
            configureSSL
            shift
            ;;
        -db|--database)
            setupDatabase "$2" "$3" "$4" "$5"
            shift 5
            ;;
        *)
            echo "Unknown option: $1"
            main
            exit 1
            ;;
    esac
done

main