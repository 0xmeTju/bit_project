# Build
This project contains 3 different WAF environments in their separate docker containers.\
To build each one, change into the desired directory `cd naxsi` and run the build command `docker-compose up -d --build`.\
To destroy current environments, use `docker-compose down`.\
This will successfully build both the WAF proxy module and the vulnerable DVWA application, that has network communication forward to it by the WAF. All the modules are preconfigured.

# Connecting to the environment
Default connection is as follows:
| Env  | URL | Port  | 
|---|---|---|
|  Modsecurity |  localhost  |  8080 |
|  Naxsi |  localhost | 8081  |
|  PHPIDS | localhost  |  8082 |

Upon connection, you have to generate the DVWA database.\
Login details are username `admin` and password `password`.

To enable the **PHPIDS** WAF, login to the DVWA -> navigate to the DVWA Security -> Enable PHPIDS at the bottom of the page.

# SQLMAP testing
To use the automatic SQLMap script, use the `./waf-test.sh <<PHPSESSID_VALUE>>`.\
Example: `./waf-test.sh m7m999r1ts7u0a21e61kr3oo91`