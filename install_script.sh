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
VERSION="1.0"

# 作者信息
AUTHOR="hiyuelin"
TELEGRAM="https://t.me/hiyuelin"

# 函数定义
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

print_menu() {
    clear
    print_logo
    echo -e "${PURPLE}=== 程序安装菜单 ===${NC}"
    echo -e "${BLUE}1)${NC} Docker 管理"
    echo -e "${BLUE}2)${NC} X-UI"
    echo -e "${BLUE}3)${NC} 3X-UI"
    echo -e "${BLUE}4)${NC} BBR加速"
    echo -e "${BLUE}5)${NC} 哪吒监控"
    echo -e "${BLUE}6)${NC} aaPanel"
    echo -e "${BLUE}7)${NC} IP质量体检"
    echo -e "${BLUE}8)${NC} frp内网穿透"
    echo -e "${BLUE}9)${NC} 检查Netflix解锁"
    echo -e "${BLUE}10)${NC} 查看本机IP信息"
    echo -e "${RED}0)${NC} 退出"
    echo
}

docker_menu() {
    while true; do
        clear
        print_logo
        echo -e "${PURPLE}=== Docker 管理菜单 ===${NC}"
        echo -e "${BLUE}1)${NC} 安装 Docker"
        echo -e "${BLUE}2)${NC} 安装 Docker Compose"
        echo -e "${BLUE}3)${NC} 查看镜像"
        echo -e "${BLUE}4)${NC} 查看容器"
        echo -e "${BLUE}5)${NC} 删除容器"
        echo -e "${BLUE}6)${NC} 删除镜像"
        echo -e "${BLUE}7)${NC} 部署 Pixman 应用"
        echo -e "${BLUE}8)${NC} 删除 Pixman 应用"
        echo -e "${BLUE}9)${NC} 部署 Allinone 应用"
        echo -e "${BLUE}10)${NC} 删除 Allinone 应用"
        echo -e "${BLUE}11)${NC} 设置自动更新 Docker 镜像"
        echo -e "${RED}0)${NC} 返回主菜单"
        echo

        read -p "请输入选项数字: " docker_choice
        case $docker_choice in
            1)
                install_docker
                ;;
            2)
                install_docker_compose
                ;;
            3)
                docker images
                read -p "按回车键继续..."
                ;;
            4)
                docker ps -a
                read -p "按回车键继续..."
                ;;
            5)
                delete_container
                ;;
            6)
                delete_image
                ;;
            7)
                deploy_pixman
                ;;
            8)
                remove_pixman
                ;;
            9)
                deploy_allinone
                ;;
            10)
                remove_allinone
                ;;
            11)
                setup_auto_update
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}无效选项，请重新选择${NC}"
                read -p "按回车键继续..."
                ;;
        esac
    done
}

delete_container() {
    echo -e "${YELLOW}当前运行的容器：${NC}"
    docker ps -a
    echo
    read -p "请输入要删除的容器 CONTAINER ID: " container_id
    if [ -n "$container_id" ]; then
        docker stop $container_id
        docker rm $container_id
        echo -e "${GREEN}容器 $container_id 已被删除${NC}"
        
        read -p "是否同时删除相关的镜像？(y/n): " delete_image_choice
        if [[ $delete_image_choice == [yY] ]]; then
            delete_image
        fi
    else
        echo -e "${RED}未输入容器 CONTAINER ID，操作取消${NC}"
    fi
    read -p "按回车键继续..."
}

delete_image() {
    echo -e "${YELLOW}当前的镜像：${NC}"
    docker images
    echo
    read -p "请输入要删除的镜像 IMAGE ID: " image_id
    if [ -n "$image_id" ]; then
        docker rmi $image_id
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}镜像 $image_id 已被除${NC}"
        else
            echo -e "${RED}删除像 $image_id 失败，可能是因为该镜像正在被使用或不存在${NC}"
        fi
    else
        echo -e "${RED}未输入镜像 IMAGE ID，操作取消${NC}"
    fi
    read -p "按回车键继续..."
}

install_docker() {
    echo -e "${GREEN}开始安装 Docker...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的源。${NC}"
    wget -qO- get.docker.com | bash
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Docker 安装完成${NC}"
    docker --version
    read -p "按回车键继续..."
}

install_docker_compose() {
    echo -e "${GREEN}开始安装 Docker Compose...${NC}"
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误：Docker 未安装。请先安装 Docker。${NC}"
        read -p "按回车键继续..."
        return
    fi
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Docker Compose 安装完成${NC}"
    docker-compose --version
    read -p "按回车键继续..."
}

install_xui() {
    echo -e "${GREEN}开始安装 X-UI...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
    echo -e "${GREEN}X-UI 安装脚本执行完成${NC}"
    read -p "按回车键继续..."
}

install_3xui() {
    echo -e "${GREEN}开始安装 3X-UI...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载执行脚本。请确保您信任该脚本的来源。${NC}"
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    echo -e "${GREEN}3X-UI 安装脚本执行完成${NC}"
    read -p "按回车键继续..."
}

install_bbr() {
    echo -e "${GREEN}开始安装 BBR 加速...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh"
    chmod +x tcp.sh
    ./tcp.sh
    echo -e "${GREEN}BBR 加速安装脚本执行完成${NC}"
    read -p "按回车键继续..."
}

install_nezha() {
    echo -e "${GREEN}开始安装哪吒监控...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh
    chmod +x nezha.sh
    sudo ./nezha.sh
    echo -e "${GREEN}哪吒监控安装脚本执行完成${NC}"
    read -p "按回车键继续..."
}

install_aapanel() {
    echo -e "${GREEN}开始装 aaPanel...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh
    bash install.sh aapanel
    echo -e "${GREEN}aaPanel 安装脚本执行完成${NC}"
    read -p "按回车键继续..."
}

install_ip_check() {
    echo -e "${GREEN}开始执行 IP 质量体检...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    bash <(curl -Ls IP.Check.Place)
    echo -e "${GREEN}IP 质量体检执行完成${NC}"
    read -p "按回车键继续..."
}

install_frp() {
    echo -e "${GREEN}开始安装 frp 内网穿透...${NC}"
    echo -e "${YELLOW}警告：此操作直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
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
            return
            ;;
    esac
    chmod 700 ./install-frps.sh
    ./install-frps.sh install
    echo -e "${GREEN}frp 内网穿透安装完成${NC}"
    read -p "按回车键继续..."
}

install_netflix_check() {
    echo -e "${GREEN}开始检查Netflix解锁...${NC}"
    echo -e "${YELLOW}警告：此操作将直接从网络下载并执行脚本。请确保您信任该脚本的来源。${NC}"
    wget -O nf https://github.com/sjlleo/netflix-verify/releases/download/2.01/nf_2.01_linux_amd64 && chmod +x nf && clear && ./nf
    echo -e "${GREEN}Netflix解锁检查执行完成${NC}"
    read -p "按回车键继续..."
}

deploy_pixman() {
    echo -e "${GREEN}开始部署 Pixman 应用...${NC}"

    # 选择架构
    echo "请选择您的系统架构："
    echo "1) x86"
    echo "2) ARM/v7"
    read -p "请输入选项数字: " arch_choice

    case $arch_choice in
        1)
            image="pixman/pixman"
            ;;
        2)
            image="pixman/pixman-armv7"
            ;;
        *)
            echo -e "${RED}无效选项，取消部署。${NC}"
            return
            ;;
    esac

    # 拉取镜像
    echo -e "${YELLOW}正在拉取 $image 镜像...${NC}"
    docker pull $image

    # 设置端口
    read -p "请输入要运行的端口 (默认 5000): " port
    port=${port:-5000}

    # 设置变量
    variables=""

    # MYTVSUPER TOKEN
    read -p "是否有 MYTVSUPER TOKEN? (y/n): " has_mytvsuper
    if [[ $has_mytvsuper == [yY] ]]; then
        read -p "请输入 MYTVSUPER TOKEN: " mytvsuper_token
        variables="$variables -e MYTVSUPER_TOKEN=$mytvsuper_token"
    fi

    # Hamivideo
    read -p "是否需要添加 Hamivideo? (y/n): " has_hamivideo
    if [[ $has_hamivideo == [yY] ]]; then
        read -p "请输入 HAMI_SESSION_ID: " hami_session_id
        read -p "请输入 HAMI_SERIAL_NO: " hami_serial_no
        read -p "请输入 HAMI_SESSION_IP: " hami_session_ip
        variables="$variables -e HAMI_SESSION_ID=$hami_session_id -e HAMI_SERIAL_NO=$hami_serial_no -e HAMI_SESSION_IP=$hami_session_ip"
    fi

    # 运行容器
    echo -e "${YELLOW}正在创建并运行 Pixman 容器...${NC}"
    if [ -z "$variables" ]; then
        docker run -d --name=pixman -p $port:5000 $image
    else
        docker run -d --name=pixman -p $port:5000 $variables $image
    fi

    echo -e "${GREEN}Pixman 应用部署完成。容器正在后台运行，端口为 $port${NC}"
    read -p "按回车键继续..."
}

remove_pixman() {
    echo -e "${GREEN}开始删除 Pixman 应用...${NC}"

    # 选择架构
    echo "请选择您的系统架构："
    echo "1) x86"
    echo "2) ARM/v7"
    read -p "请输入选项数字: " arch_choice

    case $arch_choice in
        1)
            image="pixman/pixman"
            container_name="pixman"
            ;;
        2)
            image="pixman/pixman-armv7"
            container_name="pixman"
            ;;
        *)
            echo -e "${RED}无效选项，取消删除。${NC}"
            return
            ;;
    esac

    echo -e "${YELLOW}正在停止并删除 Pixman 容器...${NC}"
    docker stop $container_name
    docker rm $container_name

    echo -e "${YELLOW}正在删除 Pixman 镜像...${NC}"
    docker rmi $image

    echo -e "${GREEN}Pixman 应用已成功删除${NC}"
    read -p "按回车键继续..."
}

deploy_allinone() {
    echo -e "${GREEN}开始部署 Allinone 应用...${NC}"

    # 拉取镜像
    echo -e "${YELLOW}正在拉取 youshandefeiyang/allinone 镜像...${NC}"
    docker pull youshandefeiyang/allinone

    # 设置端口
    read -p "请输入要运行的端口 (默认 5000): " port
    port=${port:-5000}

    # 运行容器
    echo -e "${YELLOW}正在创建并运行 Allinone 容器...${NC}"
    docker run -d --name=allinone --restart=unless-stopped --privileged=true -p $port:35455 youshandefeiyang/allinone

    echo -e "${GREEN}Allinone 应用部署完成。容器正在后台运行，端口为 $port${NC}"
    read -p "按回车键继续..."
}

remove_allinone() {
    echo -e "${GREEN}开始删除 Allinone 应用...${NC}"

    echo -e "${YELLOW}正在停止并删除 Allinone 容器...${NC}"
    docker stop allinone
    docker rm allinone

    echo -e "${YELLOW}正在删除 Allinone 镜像...${NC}"
    docker rmi youshandefeiyang/allinone

    echo -e "${GREEN}Allinone 应用已成功删除${NC}"
    read -p "按回车键继续..."
}

# 在其他函数定义之后，添加这个新函数
check_ip_info() {
    while true; do
        clear
        print_logo
        echo -e "${PURPLE}=== 查看本机IP信息 ===${NC}"
        echo -e "${BLUE}1)${NC} 查看网卡IP"
        echo -e "${BLUE}2)${NC} 查看互联网IP"
        echo -e "${RED}0)${NC} 返回主菜单"
        echo

        read -p "请输入选项数字: " ip_choice
        case $ip_choice in
            1)
                echo -e "${GREEN}网卡IP信息：${NC}"
                ip addr
                read -p "按回车键继续..."
                ;;
            2)
                echo -e "${GREEN}互联网IP信息：${NC}"
                curl -s ipinfo.io
                echo  # 添加一个空行，使输出更整洁
                read -p "按回车键继续..."
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}无效选项，请重新选择${NC}"
                read -p "按回车键继续..."
                ;;
        esac
    done
}

setup_auto_update() {
    echo -e "${GREEN}设置自动更新 Docker 镜像${NC}"
    echo "请选择要自动更新的应用："
    echo "1) Pixman"
    echo "2) Allinone"
    read -p "请输入选项数字: " app_choice

    case $app_choice in
        1)
            app_name="Pixman"
            echo "请选择 Pixman 的架构："
            echo "1) x86"
            echo "2) ARM/v7"
            read -p "请输入选项数字: " arch_choice
            case $arch_choice in
                1)
                    image_name="pixman/pixman"
                    ;;
                2)
                    image_name="pixman/pixman-armv7"
                    ;;
                *)
                    echo -e "${RED}无效选项，取消设置。${NC}"
                    return
                    ;;
            esac
            default_port=5000
            ;;
        2)
            app_name="Allinone"
            image_name="youshandefeiyang/allinone"
            default_port=35455
            ;;
        *)
            echo -e "${RED}无效选项，取消设置。${NC}"
            return
            ;;
    esac

    read -p "请输入应用当前运行的端口 (默认 $default_port): " port
    port=${port:-$default_port}

    echo "请选择更新频率："
    echo "1) 每天"
    echo "2) 每2天"
    echo "3) 每周"
    read -p "请输入选项数字: " freq_choice

    case $freq_choice in
        1)
            cron_schedule="0 4 * * *"
            freq_text="每天"
            ;;
        2)
            cron_schedule="0 4 */2 * *"
            freq_text="每2天"
            ;;
        3)
            cron_schedule="0 4 * * 0"
            freq_text="每周"
            ;;
        *)
            echo -e "${RED}无效选项，取消设置。${NC}"
            return
            ;;
    esac

    update_script="/usr/local/bin/update_${app_name,,}_image.sh"
    echo '#!/bin/bash' > $update_script
    echo "docker pull $image_name" >> $update_script
    echo "docker stop $app_name" >> $update_script
    echo "docker rm $app_name" >> $update_script
    if [ "$app_name" = "Pixman" ]; then
        echo "docker run -d --name=$app_name --restart=unless-stopped -p $port:5000 $image_name" >> $update_script
    else
        echo "docker run -d --name=$app_name --restart=unless-stopped --privileged=true -p $port:35455 $image_name" >> $update_script
    fi
    chmod +x $update_script

    # 检查是否已存在相同的 cron 任务
    if crontab -l | grep -q "$update_script"; then
        sed -i "\|$update_script|d" <(crontab -l)
    fi

    (crontab -l 2>/dev/null; echo "$cron_schedule $update_script") | crontab -

    echo -e "${GREEN}自动更新已设置。$app_name 将$freq_text凌晨4点自动更新。使用端口: $port${NC}"
    read -p "按回车键继续..."
}

# 主程序
while true; do
    print_menu
    read -p "请输入选项数字: " choice
    case $choice in
        1)
            docker_menu
            ;;
        2)
            install_xui
            ;;
        3)
            install_3xui
            ;;
        4)
            install_bbr
            ;;
        5)
            install_nezha
            ;;
        6)
            install_aapanel
            ;;
        7)
            install_ip_check
            ;;
        8)
            install_frp
            ;;
        9)
            install_netflix_check
            ;;
        10)
            check_ip_info
            ;;
        0)
            echo -e "${GREEN}感谢使用，再见！${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}无效选项，请重新选择${NC}"
            read -p "按回车键继续..."
            ;;
    esac
done
