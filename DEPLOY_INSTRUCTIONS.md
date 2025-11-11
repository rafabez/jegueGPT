# Instruções de Deploy no Servidor

## 1. Configurar o Serviço Systemd

### Passo 1: Editar o arquivo de serviço
Edite o arquivo `jeguegpt.service` e substitua `YOUR_TOKEN_HERE` pelo token real do bot:

```bash
nano jeguegpt.service
```

### Passo 2: Copiar para o systemd
```bash
sudo cp jeguegpt.service /etc/systemd/system/
sudo systemctl daemon-reload
```

### Passo 3: Habilitar e iniciar o serviço
```bash
sudo systemctl enable jeguegpt
sudo systemctl start jeguegpt
```

### Passo 4: Verificar status
```bash
sudo systemctl status jeguegpt
```

## 2. Ver Logs do Bot

### Logs em tempo real
```bash
sudo journalctl -u jeguegpt -f
```

### Últimas 100 linhas
```bash
sudo journalctl -u jeguegpt -n 100
```

### Logs desde hoje
```bash
sudo journalctl -u jeguegpt --since today
```

### Logs com mais detalhes
```bash
sudo journalctl -u jeguegpt -n 100 --no-pager
```

## 3. Debug Manual (sem systemd)

### Opção 1: Usar o script de debug
```bash
cd /home/ubuntu/bots/jeguegpt
export SECOND_TELEGRAM_TOKEN='seu_token_aqui'
chmod +x debug_bot.sh
./debug_bot.sh
```

### Opção 2: Executar diretamente
```bash
cd /home/ubuntu/bots/jeguegpt
export SECOND_TELEGRAM_TOKEN='seu_token_aqui'
python3 bot_openai_large.py
```

## 4. Comandos Úteis

### Reiniciar o bot
```bash
sudo systemctl restart jeguegpt
```

### Parar o bot
```bash
sudo systemctl stop jeguegpt
```

### Ver se está rodando
```bash
sudo systemctl is-active jeguegpt
ps aux | grep bot_openai_large
```

## 5. Troubleshooting

### Problema: "Unit jeguegpt.service not found"
**Solução:** O serviço não foi instalado. Siga os passos 1 e 2 acima.

### Problema: Bot responde "aff...travei aqui"
**Causa:** A API Pollinations está retornando erro.

**Debug:**
1. Verifique os logs: `sudo journalctl -u jeguegpt -n 50`
2. Procure por linhas com "ERROR" ou "API retornou mensagem de erro"
3. Teste a API manualmente:
   ```bash
   curl "https://text.pollinations.ai/teste?model=openai&referrer=interzone.art.br"
   ```

### Problema: Bot não responde
**Debug:**
1. Verifique se está rodando: `sudo systemctl status jeguegpt`
2. Verifique os logs: `sudo journalctl -u jeguegpt -n 50`
3. Verifique o token: O token está correto no arquivo de serviço?
4. Teste manualmente com o script de debug

### Problema: "No entries" nos logs
**Causa:** O serviço não está configurado ou nunca foi iniciado.

**Solução:** Configure o serviço seguindo os passos 1-3 acima.

## 6. Atualizar o Código

Quando fizer alterações no código:

```bash
cd /home/ubuntu/bots/jeguegpt
git pull  # ou copie os arquivos atualizados
sudo systemctl restart jeguegpt
sudo journalctl -u jeguegpt -f  # acompanhe os logs
```
