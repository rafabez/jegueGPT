#!/bin/bash
# Script de instalação do JegueGPT bot

echo "=== Instalação do JegueGPT Bot ==="
echo ""

# Verificar se está no diretório correto
if [ ! -f "bot_openai_large.py" ]; then
    echo "❌ ERRO: Execute este script no diretório do bot"
    exit 1
fi

# Verificar Python
echo "Verificando Python..."
python3 --version || { echo "❌ Python3 não encontrado"; exit 1; }
echo ""

# Verificar pip
echo "Verificando pip..."
pip3 --version || { echo "❌ pip3 não encontrado. Instalando..."; sudo apt-get install -y python3-pip; }
echo ""

# Instalar dependências
echo "Instalando dependências do requirements.txt..."
pip3 install -r requirements.txt --user
echo ""

# Verificar instalação
echo "Verificando instalação..."
python3 -c "import telegram; print('✓ python-telegram-bot instalado com sucesso')" || echo "❌ Erro ao instalar python-telegram-bot"
python3 -c "import requests; print('✓ requests instalado')" || echo "❌ Erro ao instalar requests"
python3 -c "import certifi; print('✓ certifi instalado')" || echo "❌ Erro ao instalar certifi"
echo ""

echo "=== Instalação concluída! ==="
echo ""
echo "Próximos passos:"
echo "1. Configure o token: export SECOND_TELEGRAM_TOKEN='seu_token_aqui'"
echo "2. Execute o bot: ./debug_bot.sh"
echo "   OU"
echo "   Configure o systemd seguindo DEPLOY_INSTRUCTIONS.md"
