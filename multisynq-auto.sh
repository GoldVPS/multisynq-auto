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

    echo -e "${GREEN}✅ Installation complete.${RESET}"
    echo ""

    echo -e "${CYAN}Step 2: Starting Synchronizer in screen...${RESET}"
    screen -dmS multisynq bash -c "synchronize start"
    echo -e "${GREEN}✔ Node is running inside screen session 'multisynq'${RESET}"

    echo -e "${CYAN}Step 3: Access Web Dashboard${RESET}"
    echo -e "Run: ${GREEN}synchronize web${RESET}"
    echo -e "Then open: ${CYAN}http://<your_vps_ip>:3000${RESET}"
    echo ""
}

# === Menu ===
function show_menu() {
    echo -e "${YELLOW}Please select an option:${RESET}"
    echo "1) Install and Run Multisynq Node"
    echo "2) Exit"
    echo ""
    read -p "Enter your choice [1-2]: " choice

    case $choice in
        1)
            install_and_run
            ;;
        2)
            echo -e "${RED}Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Try again.${RESET}"
            show_menu
            ;;
    esac
}

# === Run ===
show_header
show_menu
