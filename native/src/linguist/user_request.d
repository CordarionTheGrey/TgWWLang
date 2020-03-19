module linguist.user_request;

import tg = tg.d;

import linguist.user_text_message;

@safe:

// Objects of this struct must not outlive the message they refer to.
struct UserRequest {
    const(tg.Message)* message;
    UserTextMessage textMessage;
    bool inPM;
    const(tg.Document)*[2] docs;

    invariant {
        assert(message !is null);
        assert(docs[0] !is null || docs[1] is null);
    }
}
