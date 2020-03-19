module linguist.user_message_parser;

import linguist.user_message;

pure @safe:

struct UserMessageParser {
pure:
    private string _selfBotName;

    this(const(char)[ ] selfBotName) nothrow {
        import std.algorithm.iteration: map;
        import std.array: array;
        import std.ascii: toLower;
        import std.utf: byCodeUnit;

        // Telegram usernames are case-insensitive.
        _selfBotName = selfBotName.byCodeUnit().map!toLower().array();
    }

    UserMessage parse(string text) const {
        import std.algorithm.mutation;
        import std.algorithm.searching;
        import std.array: appender;
        import std.ascii: isAlphaNum, toLower;
        import std.utf: byCodeUnit;
        static import optlex;

        UserMessage result;
        auto s0 = text.byCodeUnit();
        if (s0.skipOver('/')) {
            // Parse the command's name and recipient.
            auto s1 = s0.stripLeft!(c => isAlphaNum(c) || c == '_');
            string cmdName = s0[0 .. $ - s1.length].source;
            if (s1.skipOver('@')) {
                if (!s1.skipOver!((a, b) => a.toLower() == b)(_selfBotName.byCodeUnit())) {
                    // This message is intended for another bot; let him do the job.
                    return UserMessage.init;
                }
                result.personallyAddressed = true;
            }
            // Omitting space between the command and its arguments is allowed but discouraged.

            // Consume the first line and parse it into an array of arguments.
            auto app = appender([cmdName]);
            s0 = s1.find('\n');
            app ~= optlex.splitter(s1[0 .. $ - s0.length].source);
            result.cmd = app.data;

            // Skip whitespace after the first line.
            s0.skipOver!(c => c == '\n' || optlex.isSpace(c));
        }
        result.extendedText = s0.source;
        return result;
    }
}

unittest {
    const parser = UserMessageParser("camelCaseBot");
    assert(parser.parse("/start") == UserMessage(["start", ""]));
    assert(parser.parse("/start@CamelCaseBot --verbose") == UserMessage(
        ["start", "--verbose", ""], "", true,
    ));
    assert(parser.parse("/start@camel_case_bot") == UserMessage.init);
    assert(parser.parse("/start\n Extra text") == UserMessage(["start", ""], "Extra text"));
}
