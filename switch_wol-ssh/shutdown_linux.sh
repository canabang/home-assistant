#!/bin/bash
/usr/bin/ssh -i /config/.ssh/id_rsa -o StrictHostKeyChecking=no -o ConnectTimeout=10 root@192.168.1.225 '/sbin/shutdown -h now'
