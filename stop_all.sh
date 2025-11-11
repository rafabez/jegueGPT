#!/bin/bash
# Script para parar TODAS as instâncias do JegueGPT bot

echo "=== Parando todas as instâncias do JegueGPT ==="
echo ""

# Parar serviço systemd
echo "1. Parando serviço systemd..."
sudo systemctl stop jeguegpt 2>/dev/null
if [ $? -eq 0 ]; then
    echo "   ✓ Serviço parado"
else
    echo "   ○ Serviço não estava rodando ou não existe"
fi
echo ""

# Verificar processos antes
echo "2. Processos do jeguegpt antes:"
BEFORE=$(ps aux | grep -E "jeguegpt.*bot_openai_large.py" | grep -v grep)
if [ -z "$BEFORE" ]; then
    echo "   ○ Nenhum processo encontrado"
else
    echo "$BEFORE"
fi
echo ""

# Matar processos específicos do jeguegpt
echo "3. Matando processos do jeguegpt..."
pkill -f "jeguegpt.*bot_openai_large.py"
sleep 2
echo "   ✓ Comando executado"
echo ""

# Verificar processos depois
echo "4. Processos do jeguegpt depois:"
AFTER=$(ps aux | grep -E "jeguegpt.*bot_openai_large.py" | grep -v grep)
if [ -z "$AFTER" ]; then
    echo "   ✓ Nenhum processo rodando - SUCESSO!"
else
    echo "   ⚠ Ainda existem processos:"
    echo "$AFTER"
    echo ""
    echo "   Tentando kill -9 forçado..."
    pkill -9 -f "jeguegpt.*bot_openai_large.py"
    sleep 1
fi
echo ""

echo "=== Limpeza concluída ==="
echo ""
echo "Agora você pode iniciar UMA instância:"
echo "  • Via systemd: sudo systemctl start jeguegpt"
echo "  • Manualmente: ./debug_bot.sh"
