#!/bin/sh
set -e

##
# Install dependencies into a dedicated venv with pinned versions.
# (System-wide pip is blocked on modern Debian/PEP 668, so we use a venv
#  instead of unpinned apt packages — see requirements.txt.)
##
VENV=/opt/docker-watchdog/venv

sudo apt-get update
sudo apt-get install -qq python3 python3-venv

sudo mkdir -p /opt/docker-watchdog
sudo python3 -m venv "$VENV"
sudo "$VENV/bin/pip" install --no-cache-dir --upgrade pip
sudo "$VENV/bin/pip" install --no-cache-dir --require-hashes -r requirements.txt

##
# Install service
# #
chmod +x ./docker-watchdog.py
sudo cp ./docker-watchdog.py /usr/local/bin/
sudo cp ./docker-watchdog.service /usr/lib/systemd/system/

##
# Reload systemd & start service
##
sudo systemctl daemon-reload
sudo systemctl enable docker-watchdog.service
sudo systemctl restart docker-watchdog.service
