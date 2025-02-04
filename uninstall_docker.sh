#!/bin/bash

# ออกจาก script ทันทีหากเกิดข้อผิดพลาด
set -e

# ฟังก์ชันแจ้งข้อมูล
info() {
    echo "[INFO] $1"
}

# ตรวจสอบว่าสคริปต์รันด้วยสิทธิ์ root หรือไม่
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] กรุณารันสคริปต์ด้วยสิทธิ์ root หรือใช้ sudo" >&2
    exit 1
fi

# หยุดและปิดการใช้งาน Docker service
info "กำลังหยุดและปิดการใช้งาน Docker..."
systemctl stop docker || true
systemctl disable docker || true

# ลบแพ็กเกจ Docker ทั้งหมด
info "กำลังลบแพ็กเกจ Docker..."
apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker.io || true

# ลบข้อมูล Docker ทั้งหมด
info "กำลังลบข้อมูล Docker..."
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
rm -rf /etc/apt/keyrings/docker.gpg
rm -rf /etc/apt/sources.list.d/docker.list

# ลบกลุ่ม docker (ถ้ามี)
info "กำลังลบกลุ่ม docker..."
groupdel docker || true

info "✅ Docker ถูกถอนการติดตั้งเรียบร้อยแล้ว!"
