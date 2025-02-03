#!/bin/bash

# อัปเดตแพ็กเกจและติดตั้ง dependencies
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg

# ลบ GPG Key เก่าและเพิ่ม GPG Key ใหม่
sudo rm -rf /etc/apt/keyrings/docker.gpg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# เพิ่ม Docker Repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# ตรวจสอบว่าไฟล์ repository ถูกต้อง
cat /etc/apt/sources.list.d/docker.list

# อัปเดตแพ็กเกจและติดตั้ง Docker
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || \
sudo apt install -y docker.io  # ติดตั้ง docker.io ถ้าตัวหลักไม่สามารถใช้ได้

# ตรวจสอบเวอร์ชัน
docker --version

# เปิดใช้ Docker และตั้งค่าให้เริ่มอัตโนมัติ
sudo systemctl enable --now docker

# เพิ่ม User เข้า Group Docker
sudo usermod -aG docker $USER

# ใช้ newgrp เพื่อให้ User ใช้ Docker ได้เลยโดยไม่ต้อง Logout
exec sg docker newgrp id -gn

echo "✅ Docker ติดตั้งเสร็จแล้ว!"
echo "🚀 คุณสามารถใช้ Docker ได้เลยโดยไม่ต้อง Logout 🎉"
