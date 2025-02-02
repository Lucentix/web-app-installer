# Web App Installer

This installer allows users to easily install common web applications and frameworks such as Apache, MySQL, PHP, MongoDB, Node.js, React, Angular, Express, Laravel, Vue.js, and many more with just a few clicks or commands.

## Features and Capabilities

1. **Complete Web Application Installation**
   - **Web Servers**: Apache, Nginx, LiteSpeed with basic configuration.
   - **Databases**: MySQL, PostgreSQL, MongoDB, MariaDB – install, configure, and start.
   - **Programming Languages**: PHP, Node.js, Python, Ruby – install and configure.
   - **Frameworks**: React, Vue.js, Angular, Laravel, Express, NestJS for easy installation of modern web stacks.
   - **Docker**: Automated installation of Docker and configuration of containerized applications.

2. **Simplified Installation and Configuration**
   - Automatically handles dependencies and configurations.
   - Creates and configures configuration files (e.g., `httpd.conf` for Apache, `.env` for Node.js, `php.ini` for PHP).
   - Supports multi-server installations with web server, database server, and application server on different machines.
   - Configures SSL certificates (Let's Encrypt) for HTTPS connections.

3. **Automated Database Setup**
   - Installs and configures relational and non-relational databases (e.g., MySQL, MongoDB, PostgreSQL).
   - Creates database users and databases based on user input.
   - Integrates ORMs like Sequelize for Node.js or Eloquent for Laravel.
   - Manages automatic backups and maintenance plans for databases.

4. **Troubleshooting and Diagnostics**
   - Real-time logging of the installation process.

## Usage

To use the Web App Installer, run the following command:

```bash
bash <(curl -s https://raw.githubusercontent.com/Lucentix/web-app-installer/main/installer.sh) [OPTIONS]
```

### Options

- `-h, --help`: Display the help message.
- `--non-interactive`: Skip all interactive prompts by providing all required inputs as options.
- `-a, --apache`: Install Apache.
- `-m, --mysql`: Install MySQL.
- `-p, --php`: Install PHP.
- `-n, --node`: Install Node.js.
- `-d, --docker`: Install Docker.
- `-f, --framework <name>`: Install a specific framework (react, angular, vue, laravel).
- `-s, --ssl`: Configure SSL with Let's Encrypt.
- `-db, --database <type> <name> <user> <password>`: Setup a database.

## Acknowledgements

This installer was adapted from the FiveM installer created by Twe3x. You can find the original FiveM installer [here](https://github.com/Twe3x/fivem-installer).

Special thanks to Twe3x for providing the original script that served as the foundation for this Web App installer.