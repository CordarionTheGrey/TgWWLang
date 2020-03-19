module linguist.user_message;

@safe:

struct UserMessage {
    // Empty if no command is given; otherwise, `cmd[0]` is the command's name.
    // After parsing `cmd[1]` becomes the literate text passed to the command.
    string[ ] cmd;
    string extendedText; // Everything except the command line.
    bool personallyAddressed; // Whether `/command@bot_name` form is used.
}
