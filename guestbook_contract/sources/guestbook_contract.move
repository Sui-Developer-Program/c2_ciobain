/*
/// Module: guestbook_contract
module guestbook_contract::guestbook_contract;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module guestbook_contract::guestbook_contract;

use std::string::{Self, String};

const MAX_LENGTH: u64 = 100;
const EInvalidLength:u64 = 7;

public struct Message has store {
    sender: address,
    content: String,
}

public struct GuestBook has key, store{
        id: UID,
        message: vector <Message>,
        number_of_messages: u64,
}

fun init(ctx: &mut TxContext) {
    let guestbook: GuestBook = GuestBook {
        id: object::new(ctx),
        message:vector::empty<Message>(),
        number_of_messages:0,
    };
    
    sui::transfer::share_object(guestbook);

}

public fun post_message(guestbook: &mut GuestBook, message: Message) {
    let length:u64 = string::length(&message.content);
    assert!(length > 0 && length  <= MAX_LENGTH, EInvalidLength);

    vector::push_back(&mut guestbook.message, message);

    guestbook.number_of_messages = guestbook.number_of_messages +1;
}

public fun create_message(message: vector<u8>, ctx: TxContext): Message {
    Message {
        sender: ctx.sender(),
        content: string::utf8(message),

    }
}

