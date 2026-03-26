import asyncio
import json
from os.path import exists
from telegram import InlineQueryResultCachedPhoto, InlineQueryResultCachedGif, InlineQueryResultCachedVideo, InlineQueryResultCachedDocument, Update
from telegram.ext import Application, CommandHandler, MessageHandler, ContextTypes, filters, ConversationHandler, InlineQueryHandler

API_TOKEN = ""
ADMINS_IDS = []
BLACK_LIST = []

DATA_FILE = 'tempdata/data.json'
MEDIA_STORAGE = {}
NAMING, WAITING_FOR_MEDIA = range(2)

if exists(DATA_FILE):
    with open(DATA_FILE, "r", encoding="utf-8") as f:
        MEDIA_STORAGE = json.load(f)
else:
    MEDIA_STORAGE = {}

def save_db():
    with open(DATA_FILE, "w", encoding="utf-8") as f:
        json.dump(MEDIA_STORAGE, f, ensure_ascii=False, indent=4)

async def inline_query(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_id = update.inline_query.from_user.id
    if user_id in BLACK_LIST:
        return

    query = update.inline_query.query.strip().lower()
    results = []

    for name, data in MEDIA_STORAGE.items():
        if not query or query in name.lower():
            if isinstance(data, dict):
                file_id = data.get("id")
                m_type = data.get("type")
            else:
                file_id = data[0]
                m_type = data[1]

            res_id = f"id_{hash(name+file_id)}"
            try:
                if m_type == "photo":
                    results.append(InlineQueryResultCachedPhoto(id=res_id, photo_file_id=file_id, title=name))
                elif m_type == "animation":
                    results.append(InlineQueryResultCachedGif(id=res_id, gif_file_id=file_id, title=name))
                elif m_type == "video":
                    results.append(InlineQueryResultCachedVideo(id=res_id, video_file_id=file_id, title=name))
                elif m_type == "document":
                    results.append(InlineQueryResultCachedDocument(id=res_id, document_file_id=file_id, title=name))
            except Exception as e:
                print(f"Ошибка создания результата для {name}: {e}")
    await update.inline_query.answer(results[:50], cache_time=10, is_personal=True)

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.effective_user.id not in ADMINS_IDS:
        await update.message.reply_text("⛔ You do not have ADMINKA, use bot with @gifs7tvbot name.")
        return ConversationHandler.END
    await update.message.reply_text("Usage:\n/add - Add new media\n/send [name] - Send saved media")

async def add_start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.effective_user.id not in ADMINS_IDS:
        await update.message.reply_text("⛔ You do not have permission to add media.")
        return ConversationHandler.END
    await update.message.reply_text("Enter a name for this media:")
    return NAMING

async def get_name(update: Update, context: ContextTypes.DEFAULT_TYPE):
    context.user_data['temp_name'] = update.message.text
    await update.message.reply_text(f"Now send the media (Photo, Video, GIF, or Doc) for '{update.message.text}':")
    return WAITING_FOR_MEDIA

async def save_media(update: Update, context: ContextTypes.DEFAULT_TYPE):
    msg = update.message
    name = context.user_data.get('temp_name')

    if msg.photo: file_id, m_type = msg.photo[-1].file_id, "photo"
    elif msg.animation: file_id, m_type = msg.animation.file_id, "animation"
    elif msg.video: file_id, m_type = msg.video.file_id, "video"
    elif msg.document: file_id, m_type = msg.document.file_id, "document"
    else:
        await msg.reply_text("Unsupported format. Send photo/video/gif/doc.")
        return WAITING_FOR_MEDIA

    MEDIA_STORAGE[name] = {"id": file_id, "type": m_type}
    save_db()

    await msg.reply_text(f"✅ Added! Use '/send {name}' to see it.")
    return ConversationHandler.END

async def send_media(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if not context.args:
        await update.message.reply_text("Provide a name: /send name")
        return

    name = context.args[0]
    if name not in MEDIA_STORAGE:
        await update.message.reply_text("Media not found!")
        return

    data = MEDIA_STORAGE[name]
    file_id, m_type = (data["id"], data["type"]) if isinstance(data, dict) else (data[0], data[1])

    chat_id = update.effective_chat.id
    if m_type == "photo": await context.bot.send_photo(chat_id, file_id)
    elif m_type == "animation": await context.bot.send_animation(chat_id, file_id)
    elif m_type == "video": await context.bot.send_video(chat_id, file_id)
    elif m_type == "document": await context.bot.send_document(chat_id, file_id)

async def delete_media(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.effective_user.id not in ADMINS_IDS:
        await update.message.reply_text("⛔ You do not have permission to delete media.")
        return

    name = " ".join(context.args)
    if name in MEDIA_STORAGE:
        del MEDIA_STORAGE[name]
        save_db()
        await update.message.reply_text(f"🗑 Deleted: {name}")
    else:
        await update.message.reply_text("File does not exist.")

async def cancel(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("Action cancelled.")
    return ConversationHandler.END

def main():
    app = Application.builder().token(API_TOKEN).connect_timeout(30).read_timeout(30).build()

    conv_handler = ConversationHandler(
        entry_points=[CommandHandler("add", add_start)],
        states={
            NAMING: [MessageHandler(filters.TEXT & ~filters.COMMAND, get_name)],
            WAITING_FOR_MEDIA: [MessageHandler(filters.PHOTO | filters.ANIMATION | filters.VIDEO | filters.Document.ALL, save_media)],
        },
        fallbacks=[CommandHandler("cancel", cancel)],
    )

    app.add_handler(conv_handler)
    app.add_handler(InlineQueryHandler(inline_query))
    app.add_handler(CommandHandler("delete", delete_media))
    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("send", send_media))

    print("Bot is running...")
    app.run_polling()

if __name__ == "__main__":
    main()
