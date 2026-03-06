#!/bin/bash

# ══════════════════════════════════════════════════════════════
#  MWM FRAMEWORK v6.1.3 — Multi-Wavelength Manipulation Suite
#  "Everything is non-functional. Everything looks terrifying."
# ══════════════════════════════════════════════════════════════

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
MAGENTA='\033[0;35m'
DIM='\033[2m'
BLINK='\033[5m'
BOLD='\033[1m'
NC='\033[0m'

# Fake data pools
fake_passwords=("************" "p@55w0rd!2024" "hunter2" "admin1337" "r00t_acc3ss!" "Z3r0C00l_99" "Tr0ub4dor&3" "letmein!@#" "shadow_r00t" "n0body_kn0ws")
fake_paths=("/etc/shadow" "/var/log/auth.log" "/root/.ssh/id_rsa" "/home/admin/.bash_history" "/opt/secrets/vault.db" "/sys/kernel/debug/memtrace" "/proc/kcore" "/var/spool/cron/root")
fake_domains=("ns1.darkpool.onion" "c2.shadownet.io" "relay7.deepmesh.net" "vault.blacknode.xyz" "proxy.nullroute.cc")
fake_exploits=("CVE-2024-38077" "CVE-2025-21298" "CVE-2024-3400" "CVE-2025-0282" "CVE-2024-47575" "CVE-2025-24472")

hex_chars="0123456789abcdef"
CMD_COUNT=0
AUTH_INTERVAL=$((RANDOM % 3 + 3))  # ask every 3-5 commands

# ─── Helpers ─────────────────────────────────────────────────

random_hex() {
    local len=$1 result=""
    for ((i=0; i<len; i++)); do
        result+="${hex_chars:RANDOM%16:1}"
    done
    echo "$result"
}

type_text() {
    local text="$1" delay="${2:-0.02}"
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

progress_bar() {
    local label="$1" duration="$2" width=40
    for ((i=0; i<=width; i++)); do
        local pct=$((i * 100 / width))
        printf "\r${CYAN}  ${label} ${NC}["
        for ((j=0; j<i; j++)); do printf "${GREEN}#${NC}"; done
        for ((j=i; j<width; j++)); do printf " "; done
        printf "] ${WHITE}%3d%%${NC}" "$pct"
        sleep "$(echo "$duration / $width" | bc -l 2>/dev/null || echo 0.05)"
    done
    echo ""
}

spinner() {
    local msg="$1" duration="${2:-2}"
    local chars='|/-\'
    local end=$((SECONDS + duration))
    while [ $SECONDS -lt $end ]; do
        for ((i=0; i<${#chars}; i++)); do
            printf "\r  ${CYAN}${chars:$i:1}${NC} ${msg}"
            sleep 0.1
        done
    done
    printf "\r  ${GREEN}✓${NC} ${msg}\n"
}

get_real_ip() {
    ipconfig 2>/dev/null | grep -oP 'IPv4.*?:\s*\K[\d.]+' | head -1 || echo "192.168.1.$(( RANDOM % 254 + 1 ))"
}

get_real_hostname() {
    hostname 2>/dev/null || echo "WORKSTATION"
}

get_real_user() {
    whoami 2>/dev/null | sed 's/.*\\//' || echo "admin"
}

get_real_ports() {
    netstat -an 2>/dev/null | grep "LISTENING" | awk '{print $2}' | grep -oP ':\K[0-9]+' | sort -un | head -12
}

get_real_connections() {
    netstat -an 2>/dev/null | grep "ESTABLISHED" | awk '{print $3}' | grep -oP '^[0-9.]+' | sort -u | head -8
}

# ─── Auth Challenge ──────────────────────────────────────────

auth_challenge() {
    CMD_COUNT=$((CMD_COUNT + 1))
    if (( CMD_COUNT >= AUTH_INTERVAL )); then
        CMD_COUNT=0
        AUTH_INTERVAL=$((RANDOM % 3 + 3))
        echo ""
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}  ⚠  SESSION TOKEN EXPIRED — RE-AUTH REQUIRED${NC}"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        read -sp "  [auth] Enter session key: " auth_key
        echo ""
        sleep 0.5
        echo -e "  ${CYAN}Validating token:${NC} $(random_hex 32)"
        sleep 0.8
        echo -e "  ${GREEN}[+] Token accepted. Session extended.${NC}"
        echo -e "  ${DIM}Expires in: $((RANDOM % 300 + 120))s${NC}"
        echo ""
    fi
}

# ─── Commands ────────────────────────────────────────────────

cmd_bypass() {
    local target="${1:-mainframe}"
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ${WHITE}MWM SECURITY BYPASS FRAMEWORK v6.1${RED}             ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    type_text "[*] Initializing bypass module for: $target" 0.02
    sleep 0.5

    echo ""
    read -sp "  [bypass] Enter override passphrase: " bypass_pass
    echo ""
    sleep 0.3
    echo -e "  ${CYAN}Hashing input:${NC} $(echo -n "$bypass_pass" | md5sum 2>/dev/null | cut -d' ' -f1 || random_hex 32)"
    sleep 0.5
    echo -e "  ${GREEN}[+] Passphrase hash matched backup keychain${NC}"
    echo ""

    type_text "[*] Scanning target perimeter..." 0.02
    local real_ip=$(get_real_ip)
    echo -e "    ${CYAN}Local adapter:  ${WHITE}${real_ip}${NC}"
    for i in $(seq 1 5); do
        local ip="$(( RANDOM % 223 + 10 )).$(( RANDOM % 255 )).$(( RANDOM % 255 )).$(( RANDOM % 255 ))"
        local port=$((RANDOM % 9000 + 1000))
        sleep 0.2
        echo -e "    ${CYAN}Found node:     ${WHITE}${ip}:${port}${NC} [$(random_hex 8)]"
    done
    sleep 0.3
    echo ""

    progress_bar "Cracking encryption layer" 3

    echo ""
    type_text "[*] Brute-forcing credential store..." 0.02
    sleep 0.3
    for i in $(seq 1 25); do
        printf "\r    ${YELLOW}Testing: ${WHITE}$(random_hex 32)${NC}  [%d h/s]" $((RANDOM % 90000 + 10000))
        sleep 0.07
    done
    echo ""
    local found_pw="${fake_passwords[RANDOM % ${#fake_passwords[@]}]}"
    echo -e "    ${GREEN}[+] CREDENTIAL MATCH: ${WHITE}${found_pw}${NC}"
    echo ""
    sleep 0.5

    progress_bar "Bypassing firewall rules" 2
    echo ""
    echo -e "${GREEN}[+] Access granted to ${WHITE}${target}${NC}"
    echo -e "${GREEN}[+] Session token: ${WHITE}$(random_hex 32)${NC}"
    echo -e "${GREEN}[+] Privilege level: ${WHITE}root / SYSTEM${NC}"
    echo ""
}

cmd_scan() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ${WHITE}MWM DEEP NETWORK SCANNER${GREEN}                       ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""

    type_text "[*] Host: $(get_real_hostname) | User: $(get_real_user)" 0.02
    type_text "[*] Scanning local network..." 0.02
    echo ""

    # Show real listening ports
    echo -e "  ${YELLOW}[LISTENING PORTS]${NC}"
    local ports=$(get_real_ports)
    if [ -n "$ports" ]; then
        while read -r port; do
            local svc
            case $port in
                22) svc="SSH";;    80) svc="HTTP";;    443) svc="HTTPS";;
                135) svc="RPC";;   445) svc="SMB";;    3306) svc="MySQL";;
                3389) svc="RDP";;  5432) svc="PostgreSQL";;  8080) svc="HTTP-Proxy";;
                *) svc="unknown";;
            esac
            echo -e "    ${GREEN}OPEN${NC}  ${WHITE}${port}${NC}/tcp  ${CYAN}${svc}${NC}"
            sleep 0.1
        done <<< "$ports"
    else
        echo -e "    ${DIM}(netstat unavailable — simulating)${NC}"
        for p in 22 80 135 443 445 3389; do
            echo -e "    ${GREEN}OPEN${NC}  ${WHITE}${p}${NC}/tcp"
            sleep 0.1
        done
    fi
    echo ""

    # Show real established connections
    echo -e "  ${YELLOW}[ESTABLISHED CONNECTIONS]${NC}"
    local conns=$(get_real_connections)
    if [ -n "$conns" ]; then
        while read -r ip; do
            echo -e "    ${CYAN}→${NC} ${WHITE}${ip}${NC}  [$(random_hex 8)]"
            sleep 0.1
        done <<< "$conns"
    fi
    echo ""

    type_text "[*] Dumping memory segments..." 0.02
    for i in $(seq 1 6); do
        local addr=$(random_hex 8)
        printf "    ${YELLOW}0x${addr}:${NC} "
        for j in $(seq 1 8); do printf "${WHITE}$(random_hex 4) ${NC}"; done
        case $((i % 4)) in
            0) printf " ${GREEN}|..root:x:0..|${NC}";;
            1) printf " ${GREEN}|..password..|${NC}";;
            2) printf " ${GREEN}|..PRIVATE K.|${NC}";;
            3) printf " ${GREEN}|..secret_ke.|${NC}";;
        esac
        echo ""
        sleep 0.08
    done
    echo ""
    echo -e "${GREEN}[+] Scan complete. $(echo "$ports" | wc -l) ports, $(echo "$conns" | wc -l) active connections.${NC}"
    echo ""
}

cmd_trace() {
    local target="${1:-unknown}"
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  ${WHITE}MWM NETWORK TRACE & RECON${CYAN}                       ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    type_text "[*] Initiating deep trace on: $target" 0.02
    sleep 0.3

    echo -e "  ${YELLOW}[ROUTE]${NC}"
    local locs=("Ashburn, US" "Frankfurt, DE" "Tokyo, JP" "São Paulo, BR" "Singapore, SG" "Reykjavik, IS" "Mumbai, IN" "Sydney, AU" "London, UK" "Seoul, KR")
    echo -e "    ${WHITE}Hop 0: ${CYAN}$(get_real_ip)${NC}  <1ms  [Local]"
    for i in $(seq 1 $((RANDOM % 5 + 6))); do
        local ip="$(( RANDOM % 223 + 10 )).$(( RANDOM % 255 )).$(( RANDOM % 255 )).$(( RANDOM % 255 ))"
        local ms=$((RANDOM % 300 + 2))
        local loc="${locs[RANDOM % ${#locs[@]}]}"
        sleep 0.3
        echo -e "    ${WHITE}Hop $i: ${CYAN}${ip}${NC}  ${ms}ms  [${loc}]"
    done
    echo ""

    type_text "[*] Performing reverse DNS..." 0.02
    sleep 0.5
    echo -e "    ${CYAN}PTR:${NC} ${WHITE}${fake_domains[RANDOM % ${#fake_domains[@]}]}${NC}"
    echo -e "    ${CYAN}ASN:${NC} ${WHITE}AS$((RANDOM % 60000 + 1000))${NC} — Shadow Networks LLC"
    echo ""
    echo -e "${GREEN}[+] Trace complete.${NC}"
    echo ""
}

cmd_decrypt() {
    local target="${1:-vault.db}"
    echo ""
    echo -e "${MAGENTA}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║  ${WHITE}AES-256 DECRYPTION ENGINE${MAGENTA}                       ║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    type_text "[*] Loading encrypted file: $target" 0.02
    sleep 0.3
    echo -e "    ${CYAN}Cipher:  ${WHITE}AES-256-GCM${NC}"
    echo -e "    ${CYAN}Key:     ${WHITE}$(random_hex 64)${NC}"
    echo -e "    ${CYAN}IV:      ${WHITE}$(random_hex 24)${NC}"
    echo -e "    ${CYAN}Tag:     ${WHITE}$(random_hex 32)${NC}"
    echo ""

    echo ""
    read -sp "  [decrypt] Enter decryption key: " dec_key
    echo ""
    sleep 0.5
    echo -e "  ${CYAN}Key hash:${NC} $(echo -n "$dec_key" | md5sum 2>/dev/null | cut -d' ' -f1 || random_hex 32)"
    sleep 0.3
    echo -e "  ${GREEN}[+] Key accepted${NC}"
    echo ""

    type_text "[*] Running differential cryptanalysis..." 0.02
    for i in $(seq 1 14); do
        printf "\r    ${YELLOW}Round %2d/14: ${WHITE}$(random_hex 64)${NC}" "$i"
        sleep 0.2
    done
    echo ""
    echo ""
    progress_bar "Decrypting blocks" 3
    echo ""
    echo -e "${GREEN}[+] Decryption successful${NC}"
    echo -e "${GREEN}[+] Plaintext dumped to: ${WHITE}/tmp/.decrypted_$(random_hex 6)${NC}"
    echo ""
}

cmd_inject() {
    local target="${1:-database}"
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ${WHITE}SQL PAYLOAD INJECTOR${RED}                            ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    type_text "[*] Targeting: $target" 0.02
    spinner "Establishing connection to DB backend" 2
    echo ""

    type_text "[*] Testing injection vectors..." 0.02
    local payloads=("' OR 1=1--" "'; DROP TABLE users;--" "' UNION SELECT * FROM credentials--" "1; EXEC xp_cmdshell('whoami')--" "' AND EXTRACTVALUE(1,CONCAT(0x7e,version()))--")
    for p in "${payloads[@]}"; do
        sleep 0.3
        echo -e "    ${YELLOW}Payload: ${WHITE}${p}${NC}"
        sleep 0.2
        if ((RANDOM % 3 != 0)); then
            echo -e "    ${GREEN}  → Vulnerable! Response: 200 OK (${RANDOM}ms)${NC}"
        else
            echo -e "    ${RED}  → WAF Blocked (403)${NC}"
        fi
    done
    echo ""
    progress_bar "Exfiltrating records" 3
    echo ""
    echo -e "${GREEN}[+] Dumped ${WHITE}$((RANDOM % 5000 + 500))${GREEN} records${NC}"
    echo -e "${GREEN}[+] Output: ${WHITE}/tmp/.sqldump_$(random_hex 6).csv${NC}"
    echo ""
}

cmd_cam() {
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ${WHITE}MWM SURVEILLANCE MODULE${RED}                         ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    type_text "[*] Initializing camera subsystem..." 0.02
    spinner "Detecting camera hardware" 2
    spinner "Injecting driver hook" 1
    spinner "Bypassing camera indicator LED" 1
    echo ""
    type_text "[*] Opening live feed..." 0.02
    sleep 0.3

    # Actually open the webcam briefly
    python "$(dirname "$0")/mwm_cam.py" 2>/dev/null
    local cam_result=$?

    sleep 0.3
    if [ $cam_result -eq 0 ]; then
        echo -e "  ${GREEN}[+] Frame captured successfully${NC}"
    else
        echo -e "  ${YELLOW}[!] Camera not detected — feed simulated${NC}"
    fi
    echo -e "  ${GREEN}[+] Snapshot saved: ${WHITE}/tmp/.cam_$(random_hex 8).raw${NC}"
    echo -e "  ${GREEN}[+] Camera indicator suppressed${NC}"
    echo -e "  ${GREEN}[+] Driver hook removed — no trace${NC}"
    echo ""
}

cmd_exploit() {
    local target="${1:-target}"
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ${WHITE}MWM EXPLOIT FRAMEWORK${RED}                           ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    local exploit="${fake_exploits[RANDOM % ${#fake_exploits[@]}]}"
    type_text "[*] Selected exploit: $exploit" 0.02
    type_text "[*] Target: $target" 0.02
    echo ""

    spinner "Loading exploit payload" 1
    spinner "Encoding shellcode (staged)" 2
    echo ""

    echo -e "  ${YELLOW}[SHELLCODE]${NC}"
    for i in $(seq 1 4); do
        printf "    "
        for j in $(seq 1 16); do
            printf "${WHITE}\\x$(random_hex 2)${NC}"
        done
        echo ""
        sleep 0.1
    done
    echo ""

    progress_bar "Delivering payload" 2
    echo ""
    spinner "Executing on remote target" 2
    spinner "Escalating privileges" 1
    spinner "Installing persistence" 1
    echo ""
    echo -e "${GREEN}[+] Exploit successful — $exploit${NC}"
    echo -e "${GREEN}[+] Reverse shell: ${WHITE}$(get_real_ip):$((RANDOM % 9000 + 1000))${NC}"
    echo -e "${GREEN}[+] Privilege: ${WHITE}NT AUTHORITY\\SYSTEM${NC}"
    echo ""
}

cmd_keylog() {
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ${WHITE}MWM KEYSTROKE INTERCEPTOR${RED}                       ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    spinner "Hooking keyboard interrupt (IRQ 1)" 2
    spinner "Installing ring-0 filter driver" 1
    echo ""
    type_text "[*] Capturing keystrokes... (5 second sample)" 0.02
    echo ""

    local words=("password" "admin" "login" "transfer" "account" "wire" "routing" "secret" "authorize" "confirm" "delete" "root" "sudo" "ssh")
    for i in $(seq 1 12); do
        sleep 0.4
        local w="${words[RANDOM % ${#words[@]}]}"
        local ts=$(date +%H:%M:%S 2>/dev/null || echo "00:00:00")
        printf "    ${DIM}[${ts}]${NC} ${WHITE}"
        # Print chars one by one
        for ((c=0; c<${#w}; c++)); do
            printf "${w:$c:1}"
            sleep 0.05
        done
        printf "${NC}\n"
    done
    echo ""
    echo -e "${GREEN}[+] Captured ${WHITE}$((RANDOM % 200 + 50))${GREEN} keystrokes${NC}"
    echo -e "${GREEN}[+] Log written to: ${WHITE}/tmp/.keylog_$(random_hex 6).dat${NC}"
    echo ""
}

cmd_exfil() {
    local target="${1:-.}"
    echo ""
    echo -e "${MAGENTA}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║  ${WHITE}MWM DATA EXFILTRATION MODULE${MAGENTA}                    ║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    type_text "[*] Scanning target filesystem: $target" 0.02
    echo ""

    echo -e "  ${YELLOW}[HIGH VALUE TARGETS]${NC}"
    local ftypes=("credentials.json" "id_rsa" ".env" "passwords.xlsx" "wallet.dat" "secrets.yaml" "token.json" "shadow" "SAM" "NTDS.dit")
    for f in "${ftypes[@]}"; do
        sleep 0.2
        local sz=$((RANDOM % 50000 + 100))
        if ((RANDOM % 3 != 0)); then
            echo -e "    ${GREEN}FOUND${NC}  ${WHITE}${f}${NC}  ${DIM}(${sz} bytes)${NC}"
        fi
    done
    echo ""

    read -sp "  [exfil] Enter C2 auth token: " c2_token
    echo ""
    sleep 0.5
    echo -e "  ${GREEN}[+] C2 authenticated: ${WHITE}${fake_domains[RANDOM % ${#fake_domains[@]}]}${NC}"
    echo ""

    progress_bar "Compressing & encrypting" 2
    progress_bar "Tunneling via DNS (TXT records)" 3
    echo ""
    echo -e "${GREEN}[+] Exfiltrated ${WHITE}$((RANDOM % 500 + 50))MB${GREEN} across ${WHITE}$((RANDOM % 10000 + 1000))${GREEN} DNS queries${NC}"
    echo -e "${GREEN}[+] Tunnel closed. No traces in firewall log.${NC}"
    echo ""
}

cmd_wifi() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  ${WHITE}MWM WIRELESS ATTACK SUITE${CYAN}                       ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    type_text "[*] Putting adapter into monitor mode..." 0.02
    spinner "wlan0 → wlan0mon" 1
    echo ""

    type_text "[*] Scanning nearby access points..." 0.02
    echo ""
    echo -e "  ${YELLOW}BSSID               CH  ENC     SIGNAL  ESSID${NC}"
    local ssids=("FBI_Surveillance_Van" "PrettyFlyForAWifi" "DefinitelyNotNSA" "DROP TABLE *" "HideYoKidsHideYoWifi" "TellMyWiFiLoveHer" "Linksys" "NETGEAR-5G" "xfinitywifi")
    for ssid in "${ssids[@]}"; do
        local bssid="$(random_hex 2):$(random_hex 2):$(random_hex 2):$(random_hex 2):$(random_hex 2):$(random_hex 2)"
        local ch=$((RANDOM % 13 + 1))
        local sig=$((-(RANDOM % 60 + 20)))
        local enc
        case $((RANDOM % 3)) in
            0) enc="WPA2";;
            1) enc="WPA3";;
            2) enc="WEP";;
        esac
        printf "  ${WHITE}%-20s${NC} %-3d ${CYAN}%-7s${NC} %ddBm   ${GREEN}%s${NC}\n" "$bssid" "$ch" "$enc" "$sig" "$ssid"
        sleep 0.15
    done
    echo ""

    progress_bar "Capturing handshakes" 3
    echo ""
    echo -e "${GREEN}[+] Captured ${WHITE}$((RANDOM % 5 + 2))${GREEN} 4-way handshakes${NC}"
    echo -e "${GREEN}[+] Saved to: ${WHITE}/tmp/.handshakes_$(random_hex 4).pcap${NC}"
    echo ""
}

# ─── Help ────────────────────────────────────────────────────

show_help() {
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}  ${BOLD}${WHITE}MWM FRAMEWORK${NC} ${DIM}v6.1.3${NC} — Multi-Wavelength Manipulation Suite    ${RED}║${NC}"
    echo -e "${RED}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${RED}║${NC}                                                                 ${RED}║${NC}"
    echo -e "${RED}║${NC}  ${BOLD}${WHITE}RECONNAISSANCE${NC}                                                ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm scan${NC}             Full system & network scan              ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm trace${NC} [target]   Deep packet trace & route analysis      ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm wifi${NC}             Wireless AP scan & handshake capture    ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                 ${RED}║${NC}"
    echo -e "${RED}║${NC}  ${BOLD}${WHITE}EXPLOITATION${NC}                                                  ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm bypass${NC} [target]  Auth bypass & credential crack          ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm inject${NC} [target]  SQL injection payload delivery          ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm exploit${NC} [target] Remote code execution framework        ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                 ${RED}║${NC}"
    echo -e "${RED}║${NC}  ${BOLD}${WHITE}POST-EXPLOITATION${NC}                                             ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm cam${NC}              Surveillance camera hijack              ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm keylog${NC}           Keystroke interception (ring-0)         ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm exfil${NC} [target]   Data exfiltration via DNS tunnel        ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm decrypt${NC} [file]   AES-256 brute-force decryption         ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                 ${RED}║${NC}"
    echo -e "${RED}║${NC}  ${BOLD}${WHITE}GENERAL${NC}                                                       ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}mwm help${NC}             Show this help menu                     ${RED}║${NC}"
    echo -e "${RED}║${NC}    ${CYAN}exit / quit${NC}          Exit interactive shell                   ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                 ${RED}║${NC}"
    echo -e "${RED}║${NC}  ${DIM}Commands accept extra args — they are silently consumed.${NC}        ${RED}║${NC}"
    echo -e "${RED}║${NC}  ${DIM}Example: 'mwm cam hack backdoor force' runs the cam module.${NC}    ${RED}║${NC}"
    echo -e "${RED}║${NC}  ${DIM}Session re-auth is required periodically for security.${NC}         ${RED}║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ─── Banner ──────────────────────────────────────────────────

show_banner() {
    echo ""
    echo -e "${RED}  ███╗   ███╗${WHITE}██╗    ██╗${RED}███╗   ███╗${NC}"
    echo -e "${RED}  ████╗ ████║${WHITE}██║    ██║${RED}████╗ ████║${NC}"
    echo -e "${RED}  ██╔████╔██║${WHITE}██║ █╗ ██║${RED}██╔████╔██║${NC}"
    echo -e "${RED}  ██║╚██╔╝██║${WHITE}██║███╗██║${RED}██║╚██╔╝██║${NC}"
    echo -e "${RED}  ██║ ╚═╝ ██║${WHITE}╚███╔███╔╝${RED}██║ ╚═╝ ██║${NC}"
    echo -e "${RED}  ╚═╝     ╚═╝${WHITE} ╚══╝╚══╝ ${RED}╚═╝     ╚═╝${NC}"
    echo ""
    echo -e "  ${DIM}Multi-Wavelength Manipulation Framework v6.1.3${NC}"
    echo -e "  ${DIM}$(get_real_user)@$(get_real_hostname) | $(get_real_ip)${NC}"
    echo -e "  ${DIM}Type 'help' for commands. Session auth required periodically.${NC}"
    echo ""
}

# ─── Command Router ─────────────────────────────────────────

route_command() {
    local input="$1"
    # Strip leading "mwm" if present (for interactive mode)
    input=$(echo "$input" | sed 's/^[[:space:]]*//' | sed 's/^mwm[[:space:]]*//')

    # Extract the first keyword to match
    # But also check for multi-word commands like "cam hack"
    local lower_input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    if [[ "$lower_input" == *"cam"* ]]; then
        cmd_cam
    elif [[ "$lower_input" == *"bypass"* ]]; then
        local arg=$(echo "$input" | awk '{for(i=1;i<=NF;i++) if($i!="bypass" && $i!="hack" && $i!="force" && $i!="access" && $i!="backdoor") {print $i; exit}}')
        cmd_bypass "${arg:-mainframe}"
    elif [[ "$lower_input" == *"exploit"* ]]; then
        local arg=$(echo "$input" | awk '{for(i=1;i<=NF;i++) if($i!="exploit" && $i!="remote" && $i!="execute" && $i!="run") {print $i; exit}}')
        cmd_exploit "${arg:-target}"
    elif [[ "$lower_input" == *"keylog"* ]]; then
        cmd_keylog
    elif [[ "$lower_input" == *"exfil"* ]]; then
        local arg=$(echo "$input" | awk '{for(i=1;i<=NF;i++) if($i!="exfil" && $i!="exfiltrate" && $i!="data" && $i!="steal") {print $i; exit}}')
        cmd_exfil "${arg:-.}"
    elif [[ "$lower_input" == *"decrypt"* ]]; then
        local arg=$(echo "$input" | awk '{for(i=1;i<=NF;i++) if($i!="decrypt" && $i!="crack" && $i!="break") {print $i; exit}}')
        cmd_decrypt "${arg:-vault.db}"
    elif [[ "$lower_input" == *"inject"* ]]; then
        local arg=$(echo "$input" | awk '{for(i=1;i<=NF;i++) if($i!="inject" && $i!="sql" && $i!="payload") {print $i; exit}}')
        cmd_inject "${arg:-database}"
    elif [[ "$lower_input" == *"trace"* ]]; then
        local arg=$(echo "$input" | awk '{for(i=1;i<=NF;i++) if($i!="trace" && $i!="route" && $i!="track") {print $i; exit}}')
        cmd_trace "${arg:-unknown}"
    elif [[ "$lower_input" == *"scan"* ]]; then
        cmd_scan
    elif [[ "$lower_input" == *"wifi"* || "$lower_input" == *"wireless"* ]]; then
        cmd_wifi
    elif [[ "$lower_input" == *"help"* ]]; then
        show_help
    elif [[ "$lower_input" == "exit" || "$lower_input" == "quit" || "$lower_input" == "q" ]]; then
        echo ""
        echo -e "${RED}[*] Wiping session artifacts...${NC}"
        sleep 0.5
        echo -e "${RED}[*] Closing encrypted channels...${NC}"
        sleep 0.3
        echo -e "${RED}[*] Session terminated.${NC}"
        echo ""
        exit 0
    elif [[ -z "$lower_input" ]]; then
        return
    else
        echo -e "${RED}[!] Unknown module: ${WHITE}${input}${NC}"
        echo -e "${DIM}    Type 'help' for available commands.${NC}"
    fi
}

# ─── Main ────────────────────────────────────────────────────

if [[ $# -ge 1 ]]; then
    # Non-interactive: run single command from CLI args
    route_command "$*"
else
    # Interactive shell mode
    show_banner

    # Initial auth
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}  INITIAL AUTHENTICATION REQUIRED${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    read -sp "  [auth] Enter master key: " master_key
    echo ""
    sleep 0.8
    echo -e "  ${CYAN}Verifying:${NC} $(random_hex 48)"
    sleep 0.5
    echo -e "  ${GREEN}[+] Access granted. Welcome, operator.${NC}"
    echo ""

    while true; do
        echo -ne "${RED}mwm${NC}${WHITE}>${NC} "
        read -r user_input
        if [ $? -ne 0 ]; then
            # EOF / Ctrl+D
            echo ""
            route_command "exit"
        fi
        auth_challenge
        route_command "$user_input"
    done
fi
