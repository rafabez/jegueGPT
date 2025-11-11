#!/bin/bash
# Script para fazer deploy no servidor

echo "=== Deploy do JegueGPT ==="
echo ""

# Verificar se estamos no diretório correto
if [ ! -f "bot_openai_large.py" ]; then
    echo "❌ Execute este script no diretório do projeto"
    exit 1
fi

# 1. Commit e push local
echo "1. Fazendo commit e push..."
git add .
read -p "Mensagem do commit: " commit_msg
git commit -m "$commit_msg"
git push
echo "✓ Push concluído"
echo ""

# 2. Deploy no servidor
echo "2. Fazendo deploy no servidor..."
echo "   Conectando via SSH..."

# Substitua com seu servidor
SERVER="ubuntu@telegram-bots"
REMOTE_PATH="/home/ubuntu/bots/jeguegpt"

ssh $SERVER << 'EOF'
cd /home/ubuntu/bots/jeguegpt
echo "   • Fazendo git pull..."
git pull
echo "   • Reiniciando serviço..."
sudo systemctl restart jeguegpt
echo "   • Verificando status..."
sleep 2
sudo systemctl status jeguegpt --no-pager -l | head -n 10
EOF

echo ""
echo "=== Deploy concluído! ==="
echo ""
echo "Para ver os logs:"
echo "  ssh $SERVER 'sudo journalctl -u jeguegpt -f'"
