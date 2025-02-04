# Docker
# 🚀 ติดตั้ง Docker บน Ubuntu

## 📌 ขั้นตอนการติดตั้ง Docker บน Ubuntu Server

### ✅ 1. สร้างไฟล์ `install_docker.sh`
รันคำสั่งนี้ใน **Ubuntu Terminal**:
```sh
sudo nano install_docker.sh
```
📌 คัดลอกโค้ดต่อไปนี้ไปวางในไฟล์:

```sh
#!/bin/bash

# ออกจาก script ทันทีหากเกิดข้อผิดพลาด
set -e

# ฟังก์ชันแจ้งข้อผิดพลาดและออกจาก script
error_exit() {
    echo "[ERROR] $1" >&2
    exit 1
}

# ฟังก์ชันแจ้งข้อมูล
info() {
    echo "[INFO] $1"
}

# ตรวจสอบว่าสคริปต์รันด้วยสิทธิ์ root หรือไม่
if [ "$EUID" -ne 0 ]; then
    error_exit "กรุณารันสคริปต์ด้วยสิทธิ์ root หรือใช้ sudo"
fi

# ตรวจสอบ OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VERSION=$VERSION_ID
else
    error_exit "ไม่สามารถตรวจสอบ OS ได้"
fi
info "กำลังติดตั้ง Docker บน $OS $VERSION"

# ลบ Docker เวอร์ชันเก่า (ถ้ามี)
info "กำลังลบ Docker เวอร์ชันเก่าที่ติดตั้งไว้..."
apt-get remove -y docker.io docker-doc docker-compose podman-docker containerd runc || true

# อัปเดตแพ็กเกจและติดตั้ง dependencies
info "กำลังอัปเดตแพ็กเกจและติดตั้ง dependencies..."
apt-get update -y
apt-get install -y ca-certificates curl gnupg

# ลบ GPG Key เก่าก่อนเพิ่มใหม่
info "กำลังจัดการ GPG Key ของ Docker..."
rm -rf /etc/apt/keyrings/docker.gpg
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# ตั้งค่า Docker Repository
info "กำลังเพิ่ม Docker Repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# อัปเดตแพ็กเกจอีกครั้ง
info "กำลังอัปเดตแพ็กเกจ..."
apt-get update -y

# ติดตั้ง Docker
info "กำลังติดตั้ง Docker..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || \
apt-get install -y docker.io  # ใช้ docker.io เป็นตัวเลือกสำรองหากติดตั้งตัวหลักไม่ได้

# ตรวจสอบเวอร์ชัน Docker
if docker --version; then
    info "Docker ติดตั้งเรียบร้อยแล้ว!"
else
    error_exit "การติดตั้ง Docker ล้มเหลว!"
fi

# เปิดใช้งาน Docker และตั้งค่าให้เริ่มอัตโนมัติ
info "กำลังเปิดใช้งาน Docker..."
systemctl enable --now docker

# เพิ่ม User เข้า Group Docker
if [ "$SUDO_USER" ]; then
    info "กำลังเพิ่มผู้ใช้ $SUDO_USER เข้า group docker..."
    usermod -aG docker $SUDO_USER
    info "โปรดออกจากระบบและเข้าสู่ระบบใหม่เพื่อให้มีผล"
fi

# แสดงข้อความสำเร็จ
info "✅ Docker ติดตั้งเสร็จสมบูรณ์! 🚀"
```

### ✅ 2. ให้สิทธิ์รันไฟล์ `install_docker.sh`
รันคำสั่งนี้ใน **Ubuntu Terminal**:
```sh
chmod +x install_docker.sh
```

### ✅ 3. รันไฟล์ติดตั้ง Docker
รันคำสั่งนี้ใน **Ubuntu Terminal**:
```sh
./install_docker.sh
```

✅ **เสร็จเรียบร้อย!** 🚀 ตอนนี้คุณสามารถใช้งาน **Docker ได้เลย โดยไม่ต้อง Logout** 🎉
