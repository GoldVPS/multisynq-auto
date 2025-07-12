#!/bin/bash
set -e

# === Terminal Colors ===
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'
BLUE_LINE="\e[38;5;220m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"

# === Header Display ===
function show_header() {
    clear
    echo -e "\e[38;5;220m"
    echo " ██████╗  ██████╗ ██╗     ██████╗ ██╗   ██╗██████╗ ███████╗"
    echo "██╔════╝ ██╔═══██╗██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝"
    echo "██║  ███╗██║   ██║██║     ██║  ██║██║   ██║██████╔╝███████╗"
    echo "██║   ██║██║   ██║██║     ██║  ██║╚██╗ ██╔╝██╔═══╝ ╚════██║"
    echo "╚██████╔╝╚██████╔╝███████╗██████╔╝ ╚████╔╝ ██║     ███████║"
    echo " ╚═════╝  ╚═════╝ ╚══════╝╚═════╝   ╚═══╝  ╚═╝     ╚══════╝"
    echo -e "\e[0m"
    echo -e "🚀 \e[1;33mMultisynq Auto Installer\e[0m - Powered by \e[1;33mGoldVPS Team\e[0m 🚀"
    echo -e "🌐 \e[4;33mhttps://goldvps.net\e[0m"
    echo ""
}

# === Installation Function ===
function install_and_run() {
    echo -e "${CYAN}Step 1: Installation & Configuration...${RESET}"
    
    echo -e "${YELLOW}✔ Installing Node.js (v18 LTS)...${RESET}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs

    echo -e "${YELLOW}✔ Installing Docker...${RESET}"
    apt-get install -y docker.io

    echo -e "${YELLOW}✔ Installing screen...${RESET}"
    apt-get install -y screen

    echo -e "${YELLOW}✔ Installing synchronizer-cli...${RESET}"
    npm install -g synchronizer-cli

    echo -e "${YELLOW}✔ Running synchronize init...${RESET}"
    synchronize init

    echo -e "${CYAN}Step 2: Starting Synchronizer in screen...${RESET}"
    screen -dmS multisynq bash -c "synchronize start"
    echo -e "${GREEN}✔ Node is now running in screen session named: ${YELLOW}multisynq${RESET}"
    echo -e "${CYAN}To view logs, run: ${GREEN}screen -r multisynq${RESET}"

    echo -e "${YELLOW}✔ Opening necessary ports via UFW...${RESET}"
    if command -v ufw &>/dev/null; then
        ufw allow 22/tcp > /dev/null 2>&1 || true
        ufw allow 3000/tcp > /dev/null 2>&1 || true
        echo -e "${GREEN}✔ Ports 22 (SSH) and 3000 (Web) opened successfully.${RESET}"
    else
        echo -e "${RED}⚠️ UFW not found, please open ports 22 and 3000 manually if needed.${RESET}"
    fi
    echo ""
}

# === Check & Open Required Ports ===
function check_and_open_ports() {
    for port in 3000 3001; do
        if ! ufw status | grep -q "$port/tcp"; then
            echo -e "${YELLOW}🔓 Port $port not open. Opening now...${RESET}"
            ufw allow "$port"/tcp > /dev/null 2>&1 || true
        else
            echo -e "${GREEN}✅ Port $port already open.${RESET}"
        fi
    done
}

# === Check Performance Function ===
function check_performance() {
    PUBLIC_IP=$(curl -s ipv4.icanhazip.com || echo "<your_vps_ip>")

    echo -e "${CYAN}Launching Web Dashboard...${RESET}"
    check_and_open_ports

    synchronize web > /root/multisynq-web.log 2>&1 &

    sleep 2

    echo -e "${GREEN}✔ Web dashboard started.${RESET}"
    echo -e "${YELLOW}🌐 Open in browser:${RESET} ${CYAN}http://$PUBLIC_IP:3000${RESET}"
    echo -e "${YELLOW}📊 Metrics: ${RESET}${CYAN}http://$PUBLIC_IP:3001/metrics${RESET}"
    echo -e "${YELLOW}❤️ Health Check: ${RESET}${CYAN}http://$PUBLIC_IP:3001/health${RESET}"
    echo ""
    echo -e "${GREEN}✔ Your node is running inside screen session: ${YELLOW}multisynq${RESET}"
    echo -e "${CYAN}To view node logs: ${GREEN}screen -r multisynq${RESET}"
    echo -e "${CYAN}To view dashboard logs: ${GREEN}cat /root/multisynq-web.log${RESET}"
    echo ""
    read -p "🔙 Press Enter to return to the main menu..."
}

# === Enable Web Dashboard as Service ===
function enable_web_service() {
    echo -e "${CYAN}Setting up Web Dashboard as a systemd service...${RESET}"

    if [ -f /root/synchronizer-cli/synchronizer-cli-web.service ]; then
        sudo cp /root/synchronizer-cli/synchronizer-cli-web.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable synchronizer-cli-web
        sudo systemctl start synchronizer-cli-web
        echo -e "${GREEN}✔ Web Dashboard service installed and started successfully!${RESET}"
        echo -e "${YELLOW}🌐 Access it at: ${CYAN}http://$(curl -s ipv4.icanhazip.com):3000${RESET}"
    else
        echo -e "${RED}❌ Service file not found. Please launch Web Dashboard at least once using Option 2 first.${RESET}"
    fi

    echo ""
    read -p "🔙 Press Enter to return to the main menu..."
}

# === Main Menu ===
while true; do
    show_header
    echo -e "${BLUE_LINE}"
    echo -e "  ${GREEN}1.${RESET} Install and Run Multisynq Node"
    echo -e "  ${GREEN}2.${RESET} Check Node Performance (Web Dashboard)"
    echo -e "  ${GREEN}3.${RESET} Enable Auto-Start Web Dashboard (Systemd)"
    echo -e "  ${GREEN}4.${RESET} Exit"
    echo -e "${BLUE_LINE}"
    read -p "Select an option (1–4): " choice

    case $choice in
        1)
            install_and_run
            ;;
        2)
            check_performance
            ;;
        3)
            enable_web_service
            ;;
        4)
            echo -e "${RED}Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please try again.${RESET}"
            sleep 1
            ;;
    esac
done
