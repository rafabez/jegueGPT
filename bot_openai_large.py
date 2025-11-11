import os
import asyncio
import logging
import urllib.parse
import ssl
import certifi
import requests

from collections import defaultdict
from telegram import Update
from telegram.constants import ChatType
from telegram.ext import (
    ApplicationBuilder,
    MessageHandler,
    ContextTypes,
    filters,
)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s [%(name)s] %(message)s"
)

TELEGRAM_TOKEN = os.getenv("SECOND_TELEGRAM_TOKEN")
if TELEGRAM_TOKEN:
    TELEGRAM_TOKEN = TELEGRAM_TOKEN.strip()
    if TELEGRAM_TOKEN.startswith("="):
        TELEGRAM_TOKEN = TELEGRAM_TOKEN[1:].strip()

if not TELEGRAM_TOKEN:
    raise EnvironmentError("O token do bot não foi configurado.")

SYSTEM_PROMPT = (
    "Seu nome é JegueGPT. Você é um assitente muito burro que "
    "não sabe responder nada direito e só viaja na maionese nas respotas "
    "e nunca dá respostas certas"
)

conversation_history = defaultdict(list)

def call_pollinations(prompt: str) -> str:
    try:
        # Combinar system prompt com a mensagem do usuário
        full_prompt = f"{SYSTEM_PROMPT}\n\nUsuário: {prompt}\nJegueGPT:"
        encoded_prompt = urllib.parse.quote(full_prompt)
        base = f"https://text.pollinations.ai/{encoded_prompt}"
        params = {"model": "openai", "referrer": "interzone.art.br"}
        
        logging.info(f"Chamando Pollinations API com prompt: {prompt[:50]}...")
        logging.debug(f"URL completa: {base}")
        
        r = requests.get(base, params=params, timeout=60)
        
        logging.info(f"Status code: {r.status_code}")
        logging.debug(f"Response headers: {r.headers}")
        logging.debug(f"Response text (primeiros 200 chars): {r.text[:200]}")
        
        r.raise_for_status()
        response_text = r.text.strip()
        
        # Detectar respostas de erro da API
        if "aff" in response_text.lower() or "travei" in response_text.lower():
            logging.error(f"API retornou mensagem de erro: {response_text}")
        
        return response_text
    except requests.Timeout as e:
        logging.error(f"Timeout ao chamar Pollinations: {e}")
        return "Houve um problema ao processar sua solicitação. Tente novamente mais tarde."
    except requests.RequestException as e:
        logging.error(f"Pollinations falhou: {e}")
        logging.error(f"Tipo de erro: {type(e).__name__}")
        if hasattr(e, 'response') and e.response is not None:
            logging.error(f"Response status: {e.response.status_code}")
            logging.error(f"Response body: {e.response.text[:500]}")
        return "Houve um problema ao processar sua solicitação. Tente novamente mais tarde."
    except Exception as e:
        logging.error(f"Erro inesperado em call_pollinations: {e}", exc_info=True)
        return "Houve um problema ao processar sua solicitação. Tente novamente mais tarde."

async def handle_message(update: Update, ctx: ContextTypes.DEFAULT_TYPE):
    message = update.effective_message
    if not message or not message.text:
        return
    text = message.text.strip()
    chat = update.effective_chat
    
    logging.info(f"Mensagem recebida de chat_id={chat.id}, tipo={chat.type}: {text[:100]}")
    
    if chat.type in (ChatType.GROUP, ChatType.SUPERGROUP):
        low = text.lower()
        if "@jeguegpt_bot" not in low and "@jeguegpt" not in low:
            logging.debug(f"Mensagem ignorada (grupo sem menção): {text[:50]}")
            return
    
    conversation_history[chat.id].append({"role": "user", "content": text})
    
    try:
        loop = asyncio.get_running_loop()
        reply = await loop.run_in_executor(None, call_pollinations, text)
        conversation_history[chat.id].append({"role": "assistant", "content": reply})
        
        logging.info(f"Resposta enviada para chat_id={chat.id}: {reply[:100]}")
        await message.reply_text(reply)
    except Exception as e:
        logging.error(f"Erro ao processar mensagem: {e}", exc_info=True)
        await message.reply_text("Desculpe, ocorreu um erro ao processar sua mensagem.")

def main():
    logging.info("Iniciando JegueGPT bot...")
    logging.info(f"Token configurado: {TELEGRAM_TOKEN[:10]}...")
    
    ssl.create_default_context(cafile=certifi.where())
    app = ApplicationBuilder().token(TELEGRAM_TOKEN).build()
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    
    logging.info("Bot configurado e pronto para receber mensagens")
    print("O segundo bot para o modelo openai-large está funcionando...")
    
    try:
        app.run_polling(drop_pending_updates=True)
    except Exception as e:
        logging.error(f"Erro fatal no bot: {e}", exc_info=True)
        raise

if __name__ == "__main__":
    main()