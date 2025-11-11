#!/bin/bash
# Script para verificar instâncias do bot rodando

echo "=== Verificando instâncias do JegueGPT ==="
echo ""

# Verificar processos Python do bot
PROCESSES=$(ps aux | grep bot_openai_large.py | grep -v grep)

if [ -z "$PROCESSES" ]; then
    echo "✓ Nenhuma instância do bot está rodando"
else
    echo "⚠ Instâncias encontradas:"
    echo "$PROCESSES"
    echo ""
    COUNT=$(echo "$PROCESSES" | wc -l)
    echo "Total: $COUNT instância(s)"
    
    if [ "$COUNT" -gt 1 ]; then
        echo ""
        echo "❌ ERRO: Múltiplas instâncias detectadas!"
        echo "Isso causará o erro 'Conflict: terminated by other getUpdates request'"
        echo ""
        echo "Para resolver:"
        echo "1. Parar o serviço: sudo systemctl stop jeguegpt"
        echo "2. Matar processos: pkill -f bot_openai_large.py"
        echo "3. Iniciar apenas um: sudo systemctl start jeguegpt OU ./debug_bot.sh"
    fi
fi

echo ""

# Verificar status do systemd
echo "=== Status do serviço systemd ==="
if systemctl is-active --quiet jeguegpt 2>/dev/null; then
    echo "✓ Serviço jeguegpt está ATIVO"
    sudo systemctl status jeguegpt --no-pager -l | head -n 5
else
    echo "○ Serviço jeguegpt está INATIVO ou não existe"
fi
