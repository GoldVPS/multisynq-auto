#!/bin/bash
set -e

# === Terminal Colors ===
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

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

# === Step 1: Installation & Configuration ===
function install_and_configure() {
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

    echo -e "${GREEN}✅ Installation & configuration complete.${RESET}"
    echo ""
}

# === Step 2: Start Synchronizer Container ===
function start_synchronizer() {
    echo -e "${CYAN}Step 2: Starting Synchronizer Container...${RESET}"

    echo -e "${YELLOW}✔ Creating screen session 'multisynq'...${RESET}"
    screen -dmS multisynq bash -c "synchronize start"

    echo -e "${GREEN}✅ Synchronizer started inside 'multisynq' screen session.${RESET}"
    echo ""
}

# === Step 3: Check Web Dashboard ===
function show_dashboard_info() {
    echo -e "${CYAN}Step 3: Check Web Dashboard...${RESET}"
    echo -e "${YELLOW}✔ You can view performance dashboard via:${RESET}"
    echo -e "${GREEN}synchronize web${RESET}"
    echo -e "${YELLOW}Then open your browser and visit:${RESET}"
    echo -e "${CYAN}http://<your_vps_ip>:3000${RESET}"
    echo ""
}

# === Run All Steps ===
show_header
install_and_configure
start_synchronizer
show_dashboard_info

echo -e "${GREEN}🎉 Done! Your Multisynq Node is up and running.${RESET}"
