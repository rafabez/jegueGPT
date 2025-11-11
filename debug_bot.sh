#!/bin/bash
# Script para debugar o JegueGPT bot

echo "=== JegueGPT Debug Script ==="
echo ""

# Verificar se o token está configurado
if [ -z "$SECOND_TELEGRAM_TOKEN" ]; then
    echo "❌ ERRO: Variável SECOND_TELEGRAM_TOKEN não está configurada!"
    echo "Configure com: export SECOND_TELEGRAM_TOKEN='seu_token_aqui'"
    exit 1
fi

echo "✓ Token encontrado: ${SECOND_TELEGRAM_TOKEN:0:10}..."
echo ""

# Verificar dependências
echo "Verificando dependências..."
python3 -c "import telegram; print('✓ python-telegram-bot instalado')" 2>/dev/null || echo "❌ python-telegram-bot NÃO instalado"
python3 -c "import requests; print('✓ requests instalado')" 2>/dev/null || echo "❌ requests NÃO instalado"
python3 -c "import certifi; print('✓ certifi instalado')" 2>/dev/null || echo "❌ certifi NÃO instalado"
echo ""

# Testar API Pollinations
echo "Testando API Pollinations..."
curl -s "https://text.pollinations.ai/teste?model=openai&referrer=interzone.art.br" | head -c 200
echo ""
echo ""

# Executar bot com logs detalhados
echo "=== Iniciando bot com logs detalhados ==="
echo "Pressione Ctrl+C para parar"
echo ""

python3 bot_openai_large.py
