#!/bin/bash
# Script de instalação do JegueGPT bot usando Virtual Environment (melhor prática)

echo "=== Instalação do JegueGPT Bot (com venv) ==="
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

# Criar virtual environment
echo "Criando virtual environment..."
if [ -d "venv" ]; then
    echo "⚠ Virtual environment já existe. Removendo..."
    rm -rf venv
fi

python3 -m venv venv
echo "✓ Virtual environment criado"
echo ""

# Ativar venv e instalar dependências
echo "Instalando dependências no venv..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
echo ""

# Verificar instalação
echo "Verificando instalação..."
python -c "import telegram; print('✓ python-telegram-bot instalado com sucesso')" || echo "❌ Erro ao instalar python-telegram-bot"
python -c "import requests; print('✓ requests instalado')" || echo "❌ Erro ao instalar requests"
python -c "import certifi; print('✓ certifi instalado')" || echo "❌ Erro ao instalar certifi"
deactivate
echo ""

echo "=== Instalação concluída! ==="
echo ""
echo "Próximos passos:"
echo "1. Configure o token: export SECOND_TELEGRAM_TOKEN='seu_token_aqui'"
echo "2. Execute o bot com venv:"
echo "   source venv/bin/activate"
echo "   python bot_openai_large.py"
echo ""
echo "OU use o script de debug atualizado: ./debug_bot.sh"
