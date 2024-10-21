整合了一些我常的程序安装脚本，特别优化了 Pixman 应用的部署、删除和自动更新流程。
基本上能完美的解决小白用户安装部署作者的 Pixman 遇到的所有问题，如果还有遗漏可以留言或者TG联络我补充。

![](https://img.pixman.cloud/photo/lolee/8153092b-7bba-4db7-929e-bbeeab7f5da1.png?x-oss-process=image%2Fresize%2Cw_1920)

![](https://img.pixman.cloud/photo/lolee/f91d8258-5227-46a4-aa78-994aabe0bba2.png?x-oss-process=image%2Fresize%2Cw_1920)

![](https://img.pixman.cloud/photo/lolee/77acf0e5-a04a-4cf7-9eee-2a327cc65ef4.png?x-oss-process=image%2Fresize%2Cw_1920)


一键脚本

```
bash <(curl -s https://raw.githubusercontent.com/chinggirltube/install_script/refs/heads/main/install_script.sh)
```



## 主要功能

1. Docker 管理（包括 Pixman应用）
2. X-UI 安装
3. 3X-UI 安装
4. BBR 加速安装
5. 哪吒监控安装
6. aaPanel 安装
7. IP 质量检测
8. frp 内网穿透
9. Netflix 解锁检查
10. 本机 IP 信息查看

## Pixman 相关功能

### 部署 Pixman

1. 在主菜单中选择 "1) Docker 管理"
2. 在 Docker 管理菜单中选择 "7) 部署 Pixman 应用"
3. 根据提示选择系统架构（x86 或 ARM/v7）
4. 设置运行端口（默认 5000）
5. 根据需要设置 MYTVSUPER TOKEN 和 Hamivideo 相关信息
6. 部署完成后，脚本会显示所有可用的直播源链接

### 删除 Pixman

1. 在主菜单中选择 "1) Docker 管理"
2. 在 Docker 管理菜单中选择 "8) 删除 Pixman 应用"
3. 根据提示选择系统架构（x86 或 ARM/v7）

### Pixman 应用 Mytvsuper 生成静态 m3u

1. 在主菜单中选择 "1) Docker 管理"
2. 在 Docker 管理菜单中选择 "9) Pixman 应用 Mytvsuper 生成静态 m3u"
3. 脚本会生成 Mytvsuper 静态 m3u 并显示订阅链接
4. 可选择是否添加每24小时自动执行一次的任务

### 设置 Pixman 自动更新

1. 在主菜单中选择 "1) Docker 管理"
2. 在 Docker 管理菜单中选择 "12) 设置自动更新 Docker 镜像"
3. 选择 "1) Pixman"
4. 选择 Pixman 的架构（x86 或 ARM/v7）
5. 输入当前运行的端口
6. 选择更新频率（每天、每2天或每周）

## Pixman 可用直播源

部署 Pixman 后，会提示以下直播源链接

- 四季線上 4GTV: `http://ip:port/4gtv.m3u`
- 江苏移动魔百盒 TPTV: 
  - `http://ip:port/tptv.m3u`
  - `http://ip:port/tptv_proxy.m3u`
- 央视频直播源: `http://ip:port/ysp.m3u`
- MytvSuper 直播源: `http://ip:port/mytvsuper.m3u`
- Beesport 直播源: `http://ip:port/beesport.m3u`
- 中国移动 iTV 平台:
  - `http://ip:port/itv.m3u`
  - `http://ip:port/itv_proxy.m3u`
- TheTV: `http://ip:port/thetv.m3u`
- Hami Video: `http://ip:port/hami.m3u`
- DLHD: `http://ip:port/dlhd.m3u`

## 注意事项

- 使用前请确保您的系统已经安装了 curl
- 部分功能可能需要稳定的网络连接
- 请在使用前备份重要数据


