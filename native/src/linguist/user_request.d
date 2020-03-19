module linguist.user_request;

import linguist.user_message;

@safe:

struct UserRequest {
    UserMessage message;
    bool inPM;
    // TODO: Attached file.
    // TODO: Quoted message.
}
