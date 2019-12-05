#!/bin/sh
set -e

echo "FEK_System AutoStarting Setting..."
#FEKの自動起動有効化
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl enable td-agent.service
sudo systemctl enable kibana.service
sudo systemctl daemon-reload
#システムの起動
sudo systemctl start elasticsearch
sudo systemctl start td-agent
sudo systemctl start kibana
echo "Complete"