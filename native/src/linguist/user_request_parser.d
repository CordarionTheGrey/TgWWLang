module linguist.user_request_parser;

import tg = tg.d;

import linguist.user_request;
import linguist.user_text_message;
import linguist.user_text_message_parser;

@safe:

struct UserRequestParser {
private /+pure+/:
    public UserTextMessageParser textMessageParser;

    UserTextMessage _parseUserTextMessage(string text, const(tg.MessageEntity)[ ] entities) const {
        import std.algorithm.searching: canFind;

        // There should be a "bot_command" entity at the very start of the message.
        return entities.canFind!(e => !e.offset && e.type == tg.EntityType.bot_command) ? (
            textMessageParser.parse(text)
        ) : UserTextMessage(null, text);
    }

    static const(tg.Document)* _getDocFromQuoted(tg.Message quoted) nothrow {
        if (quoted.document.isNull)
            return null;
        // `quoted`'s lifetime will expire as soon as we return.
        auto doc = new tg.Document;
        *doc = quoted.document;
        return doc;
    }

    public UserRequest parse(/+const(+/tg.Message/+)+/* message) const
    in { assert(message !is null); }
    do {
        import std.range.primitives;

        UserRequest req = {
            message: message,
            inPM: message.chat.type == tg.ChatType.private_,
        };
        if (!message.text.empty) {
            // A text message.
            req.textMessage = _parseUserTextMessage(message.text, message.entities);
            req.docs[0] = _getDocFromQuoted(message.reply_to_message);
        } else if (!message.document.isNull) {
            // A file.
            req.textMessage = _parseUserTextMessage(message.caption, message.caption_entities);
            req.docs = [&message.document, _getDocFromQuoted(message.reply_to_message)];
        }
        if (req.inPM && !req.textMessage.cmd.empty)
            req.textMessage.personallyAddressed = true;
        return req;
    }
}
