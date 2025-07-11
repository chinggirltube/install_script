#!/bin/bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 版本信息
VERSION="1.1"

# 作者信息
AUTHOR="hiyuelin & AI Assistant"
TELEGRAM="https://t.me/hiyuelin"

# --- 核心函数 ---

print_logo() {
    echo -e "${CYAN}"
    echo "  _____           _        _ _    _____           _       _   "
    echo " |_   _|         | |      | | |  / ____|         (_)     | |  "
    echo "   | |  _ __  ___| |_ __ _| | | | (___   ___ _ __ _ _ __ | |_ "
    echo "   | | | '_ \/ __| __/ _\` | | |  \___ \ / __| '__| | '_ \| __|"
    echo "  _| |_| | | \__ \ || (_| | | |  ____) | (__| |  | | |_) | |_ "
    echo " |_____|_| |_|___/\__\__,_|_|_| |_____/ \___|_|  |_| .__/ \__|"
    echo "                                                   | |        "
    echo "                                                   |_|        "
    echo -e "${NC}"
    echo -e "${YELLOW}Version: ${VERSION}${NC}"
    echo -e "${YELLOW}Author: ${AUTHOR}${NC}"
    echo -e "${YELLOW}Telegram: ${TELEGRAM}${NC}"
    echo
}

# 优雅地等待用户按键
press_any_key_to_continue() {
    echo
    read -n 1 -s -r -p "按任意键返回菜单..."
}

# --- 系统工具与维护 ---

update_system() {
    echo -e "${GREEN}开始更新系统...${NC}"
    if [ -f /etc/redhat-release ]; then
        echo "检测到 CentOS/RHEL 系统..."
        sudo yum update -y
    elif [ -f /etc/debian_version ]; then
        echo "检测到 Debian/Ubuntu 系统..."
        sudo apt-get update && sudo apt-get upgrade -y
    else
        echo -e "${RED}未知的 Linux 发行版，无法自动更新。${NC}"
    fi
    echo -e "${GREEN}系统更新完成。${NC}"
    press_any_key_to_continue
}

sync_time() {
    echo -e "${GREEN}开始同步系统时间到 Asia/Shanghai 时区...${NC}"
    sudo timedatectl set-timezone Asia/Shanghai
    echo -e "${GREEN}时间同步完成。当前时间: $(date)${NC}"
    press_any_key_to_continue
}

install_bbr() {
    echo -e "${GREEN}开始安装 BBR 加速...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
    echo -e "${GREEN}BBR 加速安装脚本执行完成。${NC}"
    press_any_key_to_continue
}

install_ffmpeg() {
    echo -e "${GREEN}开始安装 FFmpeg...${NC}"
    if command -v ffmpeg &> /dev/null; then
        echo -e "${YELLOW}FFmpeg 已安装。版本信息:${NC}"
        ffmpeg -version | head -n 1
        press_any_key_to_continue
        return
    fi
    
    echo "正在下载 FFmpeg 最新静态版 (amd64)..."
    wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -O ffmpeg-release-amd64-static.tar.xz
    if [ $? -ne 0 ]; then
        echo -e "${RED}下载 FFmpeg 失败，请检查网络或架构。${NC}"
        press_any_key_to_continue
        return
    fi
    
    echo "正在解压..."
    tar xvf ffmpeg-release-amd64-static.tar.xz
    
    echo "正在安装到 /usr/bin..."
    sudo mv ffmpeg-*-amd64-static/ffmpeg /usr/bin/
    sudo mv ffmpeg-*-amd64-static/ffprobe /usr/bin/
    
    echo "清理下载文件..."
    rm -rf ffmpeg-*-amd64-static ffmpeg-release-amd64-static.tar.xz
    
    echo -e "${GREEN}FFmpeg 安装成功！${NC}"
    ffmpeg -version | head -n 1
    press_any_key_to_continue
}

view_crontab() {
    echo -e "${GREEN}正在显示当前用户的计划任务...${NC}"
    echo -e "${YELLOW}------------------------------------${NC}"
    crontab -l 2>/dev/null || echo "当前用户没有计划任务。"
    echo -e "${YELLOW}------------------------------------${NC}"
    echo "提示：您可以使用 'crontab -e' 命令来编辑计划任务。"
    press_any_key_to_continue
}

# --- 面板与应用安装 ---

install_xui() {
    echo -e "${GREEN}开始安装 X-UI...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
    echo -e "${GREEN}X-UI 安装脚本执行完成。${NC}"
    press_any_key_to_continue
}

install_3xui() {
    echo -e "${GREEN}开始安装 3X-UI...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载执行脚本。请确保您信任该脚本的来源。${NC}"
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    echo -e "${GREEN}3X-UI 安装脚本执行完成。${NC}"
    press_any_key_to_continue
}

install_gost() {
    echo -e "${GREEN}开始安装 Gost...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    wget --no-check-certificate -O gost.sh https://raw.githubusercontent.com/KANIKIG/Multi-EasyGost/master/gost.sh && chmod +x gost.sh && ./gost.sh
    echo -e "${GREEN}Gost 安装脚本执行完成。${NC}"
    press_any_key_to_continue
}

install_nezha() {
    echo -e "${GREEN}开始安装哪吒监控 Agent...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh
    echo -e "${GREEN}哪吒监控安装脚本执行完成。${NC}"
    press_any_key_to_continue
}

install_aapanel() {
    echo -e "${GREEN}开始安装 aaPanel (国际版)...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && sudo bash install.sh aapanel
    echo -e "${GREEN}aaPanel 安装脚本执行完成。${NC}"
    press_any_key_to_continue
}

install_bt_panel_hacked() {
    echo -e "${GREEN}开始安装宝塔面板 (开心版)...${NC}"
    echo -e "${YELLOW}警告：此脚本来自第三方，请自行承担风险。${NC}"
    wget -O install.sh http://v7.hostcli.com/install/install-ubuntu_6.0.sh && sudo bash install.sh
    echo -e "${GREEN}宝塔面板安装脚本执行完成。${NC}"
    press_any_key_to_continue
}

install_frp() {
    echo -e "${GREEN}开始安装 frp (内网穿透)...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    echo "请选择安装源："
    echo "1) Gitee"
    echo "2) Github"
    read -p "请输入选项数字: " frp_choice
    case $frp_choice in
        1)
            wget https://gitee.com/mvscode/frps-onekey/raw/master/install-frps.sh -O ./install-frps.sh
            ;;
        2)
            wget https://raw.githubusercontent.com/mvscode/frps-onekey/master/install-frps.sh -O ./install-frps.sh
            ;;
        *)
            echo -e "${RED}无效选项，取消安装。${NC}"
            press_any_key_to_continue
            return
            ;;
    esac
    chmod 700 ./install-frps.sh && ./install-frps.sh install
    echo -e "${GREEN}frp 内网穿透安装完成。${NC}"
    press_any_key_to_continue
}

# --- 网络与IP工具 ---

check_local_ip_info() {
    echo -e "${GREEN}本机公网IP详细信息：${NC}"
    curl ipinfo.io
    press_any_key_to_continue
}

install_netflix_check() {
    local url="https://github.com/sjlleo/netflix-verify/releases/download/2.01/nf_2.01_linux_amd64"
    local proxy_url="https://ghproxy.com/${url}"
    
    echo -e "${GREEN}开始检查Netflix解锁状态...${NC}"
    
    echo -e "${YELLOW}Attempt 1: 正在从 GitHub 直接下载 (15秒超时)...${NC}"
    wget --no-check-certificate -T 15 -O nf "$url"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}直接下载失败。${NC}"
        echo -e "${YELLOW}Attempt 2: 正在尝试通过代理下载...${NC}"
        wget --no-check-certificate -T 15 -O nf "$proxy_url"
        
        if [ $? -ne 0 ]; then
            echo -e "${RED}通过代理下载也失败了。请检查您的网络连接。${NC}"
            press_any_key_to_continue
            return
        fi
    fi
    
    echo -e "${GREEN}下载成功，准备执行检查...${NC}"
    sleep 1
    
    chmod +x nf
    clear
    ./nf

    echo
    echo -e "${YELLOW}----------------------------------------${NC}"
    echo -e "${YELLOW}Netflix检查工具已运行完毕。${NC}"
    press_any_key_to_continue
    
    rm -f nf
}

install_ddns() {
    echo -e "${GREEN}开始执行一键DDNS脚本...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    wget -O ddns.sh https://raw.githubusercontent.com/chinggirltube/my_script/main/ddns.sh && sudo bash ddns.sh
    echo -e "${GREEN}DDNS 脚本执行完成。${NC}"
    press_any_key_to_continue
}

# --- Docker 管理 ---

install_docker() {
    echo -e "${GREEN}开始安装 Docker...${NC}"
    if command -v docker &> /dev/null; then
        echo -e "${YELLOW}Docker 已安装。${NC}"
        press_any_key_to_continue
        return
    fi
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。${NC}"
    curl -fsSL https://get.docker.com | bash
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Docker 安装完成。请重新登录以使用户组生效。${NC}"
    docker --version
    press_any_key_to_continue
}

install_docker_compose() {
    echo -e "${GREEN}开始安装 Docker Compose...${NC}"
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误：Docker 未安装。请先安装 Docker。${NC}"
        press_any_key_to_continue
        return
    fi
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Docker Compose 安装完成。${NC}"
    docker-compose --version
    press_any_key_to_continue
}

delete_container() {
    echo -e "${YELLOW}当前运行的容器：${NC}"
    docker ps -a
    echo
    read -p "请输入要删除的容器 CONTAINER ID: " container_id
    if [ -n "$container_id" ]; then
        docker stop $container_id && docker rm $container_id
        echo -e "${GREEN}容器 $container_id 已被删除。${NC}"
        
        read -p "是否同时删除相关的镜像？(y/n): " delete_image_choice
        if [[ $delete_image_choice == [yY] ]]; then
            delete_image
        fi
    else
        echo -e "${RED}未输入容器 CONTAINER ID，操作取消。${NC}"
    fi
    press_any_key_to_continue
}

delete_image() {
    echo -e "${YELLOW}当前的镜像：${NC}"
    docker images
    echo
    read -p "请输入要删除的镜像 IMAGE ID: " image_id
    if [ -n "$image_id" ]; then
        docker rmi $image_id
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}镜像 $image_id 已被删除。${NC}"
        else
            echo -e "${RED}删除镜像 $image_id 失败，可能是因为该镜像正在被使用或不存在。${NC}"
        fi
    else
        echo -e "${RED}未输入镜像 IMAGE ID，操作取消。${NC}"
    fi
    press_any_key_to_continue
}

setup_auto_update() {
    echo -e "${GREEN}设置 Docker 容器自动更新 (Watchtower)${NC}"
    echo "Watchtower 将会监控所有正在运行的容器，并在其镜像有新版本时自动更新它们。"
    read -p "确定要部署 Watchtower 吗? (y/n): " choice
    if [[ $choice != [yY] ]]; then
        echo -e "${RED}操作取消。${NC}"
        press_any_key_to_continue
        return
    fi

    echo -e "${YELLOW}正在部署 Watchtower...${NC}"
    docker run -d \
      --name watchtower \
      --restart unless-stopped \
      -v /var/run/docker.sock:/var/run/docker.sock \
      containrrr/watchtower
      
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Watchtower 部署成功！它将在后台静默运行，自动更新您的容器。${NC}"
    else
        echo -e "${RED}Watchtower 部署失败。${NC}"
    fi
    press_any_key_to_continue
}

# --- 菜单定义 ---

docker_menu() {
    while true; do
        clear
        print_logo
        echo -e "${PURPLE}========= Docker 管理 =========${NC}"
        echo -e "${BLUE}1)${NC} 安装 Docker"
        echo -e "${BLUE}2)${NC} 安装 Docker Compose"
        echo -e "${BLUE}3)${NC} 查看所有镜像"
        echo -e "${BLUE}4)${NC} 查看所有容器"
        echo -e "${BLUE}5)${NC} 删除指定容器"
        echo -e "${BLUE}6)${NC} 删除指定镜像"
        echo -e "${BLUE}7)${NC} 部署 Watchtower (自动更新容器)"
        echo -e "${RED}0)${NC} 返回主菜单"
        echo

        read -p "请输入选项数字: " docker_choice
        case $docker_choice in
            1) install_docker ;;
            2) install_docker_compose ;;
            3) clear; echo -e "${YELLOW}当前所有镜像：${NC}"; docker images; press_any_key_to_continue ;;
            4) clear; echo -e "${YELLOW}当前所有容器：${NC}"; docker ps -a; press_any_key_to_continue ;;
            5) delete_container ;;
            6) delete_image ;;
            7) setup_auto_update ;;
            0) return ;;
            *) echo -e "${RED}无效选项，请重新选择${NC}"; press_any_key_to_continue ;;
        esac
    done
}

system_menu() {
    while true; do
        clear
        print_logo
        echo -e "${PURPLE}======= 系统工具与维护 =======${NC}"
        echo -e "${BLUE}1)${NC} 更新系统 (apt/yum)"
        echo -e "${BLUE}2)${NC} 同步服务器时间 (北京时间)"
        echo -e "${BLUE}3)${NC} 安装 BBR 加速"
        echo -e "${BLUE}4)${NC} 安装 FFmpeg"
        echo -e "${BLUE}5)${NC} 查看计划任务 (crontab)"
        echo -e "${RED}0)${NC} 返回主菜单"
        echo
        read -p "请输入选项数字: " choice
        case $choice in
            1) update_system ;;
            2) sync_time ;;
            3) install_bbr ;;
            4) install_ffmpeg ;;
            5) view_crontab ;;
            0) return ;;
            *) echo -e "${RED}无效选项，请重新选择${NC}"; press_any_key_to_continue ;;
        esac
    done
}

panel_app_menu() {
    while true; do
        clear
        print_logo
        echo -e "${PURPLE}====== 面板与应用安装 ======${NC}"
        echo -e "${BLUE}1)${NC} 安装 X-UI"
        echo -e "${BLUE}2)${NC} 安装 3X-UI"
        echo -e "${BLUE}3)${NC} 安装 Gost"
        echo -e "${BLUE}4)${NC} 安装 哪吒监控 Agent"
        echo -e "${BLUE}5)${NC} 安装 aaPanel (国际版)"
        echo -e "${BLUE}6)${NC} 安装 宝塔面板 (开心版)"
        echo -e "${BLUE}7)${NC} 安装 frp (内网穿透)"
        echo -e "${RED}0)${NC} 返回主菜单"
        echo
        read -p "请输入选项数字: " choice
        case $choice in
            1) install_xui ;;
            2) install_3xui ;;
            3) install_gost ;;
            4) install_nezha ;;
            5) install_aapanel ;;
            6) install_bt_panel_hacked ;;
            7) install_frp ;;
            0) return ;;
            *) echo -e "${RED}无效选项，请重新选择${NC}"; press_any_key_to_continue ;;
        esac
    done
}

network_ip_menu() {
    while true; do
        clear
        print_logo
        echo -e "${PURPLE}======== 网络与IP工具 ========${NC}"
        echo -e "${BLUE}1)${NC} 查看本机公网IP信息"
        echo -e "${BLUE}2)${NC} Netflix 解锁检查"
        echo -e "${BLUE}3)${NC} 设置动态DNS (DDNS)"
        echo -e "${RED}0)${NC} 返回主菜单"
        echo
        read -p "请输入选项数字: " choice
        case $choice in
            1) check_local_ip_info ;;
            2) install_netflix_check ;;
            3) install_ddns ;;
            0) return ;;
            *) echo -e "${RED}无效选项，请重新选择${NC}"; press_any_key_to_continue ;;
        esac
    done
}

print_main_menu() {
    clear
    print_logo
    echo -e "${PURPLE}=============== 主菜单 ===============${NC}"
    echo -e "${GREEN}1) 系统工具与维护${NC}"
    echo -e "${GREEN}2) 面板与应用安装${NC}"
    echo -e "${GREEN}3) Docker 管理${NC}"
    echo -e "${GREEN}4) 网络与IP工具${NC}"
    echo -e "${RED}0) 退出脚本${NC}"
    echo
}

# --- 主程序循环 ---
while true; do
    print_main_menu
    read -p "请输入选项数字: " main_choice
    case $main_choice in
        1) system_menu ;;
        2) panel_app_menu ;;
        3) docker_menu ;;
        4) network_ip_menu ;;
        0) echo -e "${GREEN}感谢使用，再见！${NC}"; exit 0 ;;
        *) echo -e "${RED}无效选项，请重新选择${NC}"; press_any_key_to_continue ;;
    esac
done
