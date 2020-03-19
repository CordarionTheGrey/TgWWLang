module linguist.user_text_message;

@safe:

struct UserTextMessage {
    // Empty if no command is given; otherwise, `cmd[0]` is the command's name.
    // After parsing, `cmd[1]` becomes the literate text passed to the command.
    string[ ] cmd;
    // Everything except the command line.
    string extendedText;
    // `true` if `/command@bot_name` form is used or the command is sent to the private chat.
    bool personallyAddressed;
}
