#!/bin/bash
# Script para resolver o problema de múltiplos venvs (.venv e venv)

echo "=== Corrigindo problema de múltiplos virtual environments ==="
echo ""

cd /home/ubuntu/bots/jeguegpt || exit 1

# 1. Parar TUDO
echo "1. Parando todas as instâncias..."
sudo systemctl stop jeguegpt 2>/dev/null
pkill -9 -f "jeguegpt.*bot_openai_large.py"
sleep 2
echo "   ✓ Tudo parado"
echo ""

# 2. Verificar quais venvs existem
echo "2. Verificando virtual environments existentes..."
if [ -d ".venv" ]; then
    echo "   • .venv encontrado"
    VENV_DOT_SIZE=$(du -sh .venv 2>/dev/null | cut -f1)
    echo "     Tamanho: $VENV_DOT_SIZE"
fi

if [ -d "venv" ]; then
    echo "   • venv encontrado"
    VENV_SIZE=$(du -sh venv 2>/dev/null | cut -f1)
    echo "     Tamanho: $VENV_SIZE"
fi
echo ""

# 3. Decidir qual manter
echo "3. Recomendação: manter apenas 'venv' (sem ponto)"
echo ""
read -p "Deseja remover .venv e manter apenas venv? (s/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[SsYy]$ ]]; then
    if [ -d ".venv" ]; then
        echo "   Removendo .venv..."
        rm -rf .venv
        echo "   ✓ .venv removido"
    fi
    
    if [ ! -d "venv" ]; then
        echo "   venv não existe. Criando..."
        python3 -m venv venv
        source venv/bin/activate
        pip install --upgrade pip
        pip install -r requirements.txt
        deactivate
        echo "   ✓ venv criado e dependências instaladas"
    else
        echo "   ✓ venv já existe e será usado"
    fi
else
    echo "   Operação cancelada"
    exit 0
fi
echo ""

# 4. Atualizar systemd service
echo "4. Atualizando arquivo de serviço systemd..."
if [ -f "jeguegpt.service" ]; then
    # Garantir que usa venv, não .venv
    sed -i 's|ExecStart=/home/ubuntu/bots/jeguegpt/.venv/|ExecStart=/home/ubuntu/bots/jeguegpt/venv/|g' jeguegpt.service
    
    echo "   Copiando para /etc/systemd/system/..."
    sudo cp jeguegpt.service /etc/systemd/system/
    sudo systemctl daemon-reload
    echo "   ✓ Serviço atualizado"
else
    echo "   ⚠ Arquivo jeguegpt.service não encontrado"
fi
echo ""

# 5. Verificar
echo "5. Verificação final..."
./check_instances.sh
echo ""

echo "=== Correção concluída! ==="
echo ""
echo "Agora você pode iniciar o bot:"
echo "  sudo systemctl start jeguegpt"
echo "  sudo journalctl -u jeguegpt -f"
