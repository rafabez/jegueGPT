#!/bin/bash
# Script para verificar instâncias do bot rodando

echo "=== Verificando instâncias do JegueGPT ==="
echo ""

# Verificar processos Python do bot (apenas jeguegpt)
PROCESSES=$(ps aux | grep -E "jeguegpt.*bot_openai_large.py" | grep -v grep)

if [ -z "$PROCESSES" ]; then
    echo "✓ Nenhuma instância do jeguegpt está rodando"
else
    echo "⚠ Instâncias do jeguegpt encontradas:"
    echo "$PROCESSES"
    echo ""
    COUNT=$(echo "$PROCESSES" | wc -l)
    echo "Total: $COUNT instância(s) do jeguegpt"
    
    if [ "$COUNT" -gt 1 ]; then
        echo ""
        echo "❌ ERRO: Múltiplas instâncias do jeguegpt detectadas!"
        echo "Isso causará o erro 'Conflict: terminated by other getUpdates request'"
        echo ""
        echo "Para resolver rapidamente:"
        echo "  chmod +x stop_all.sh && ./stop_all.sh"
        echo ""
        echo "Ou manualmente:"
        echo "1. Parar o serviço: sudo systemctl stop jeguegpt"
        echo "2. Matar processos: pkill -f 'jeguegpt.*bot_openai_large.py'"
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
