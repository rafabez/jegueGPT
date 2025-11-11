#!/bin/bash
# Script para debugar o JegueGPT bot

echo "=== JegueGPT Debug Script ==="
echo ""

# Verificar se já existe instância rodando
RUNNING=$(ps aux | grep bot_openai_large.py | grep -v grep | wc -l)
if [ "$RUNNING" -gt 0 ]; then
    echo "⚠ AVISO: Detectada(s) $RUNNING instância(s) do bot já rodando!"
    echo ""
    ps aux | grep bot_openai_large.py | grep -v grep
    echo ""
    echo "Isso causará erro 'Conflict: terminated by other getUpdates request'"
    echo ""
    read -p "Deseja parar todas as instâncias e continuar? (s/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
        echo "Parando serviço systemd (se existir)..."
        sudo systemctl stop jeguegpt 2>/dev/null
        echo "Matando processos..."
        pkill -f bot_openai_large.py
        sleep 2
        echo "✓ Instâncias anteriores paradas"
    else
        echo "Abortando. Pare as instâncias manualmente primeiro."
        exit 1
    fi
    echo ""
fi

# Ativar venv se existir
if [ -d "venv" ]; then
    echo "✓ Ativando virtual environment..."
    source venv/bin/activate
    echo ""
fi

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
