# NRGKick Proto

The NRGKick charging cable is managed by an Android App which uses Protobuf over a Websocket connection.

The websocket can be reached on port 8765.

## Files
### nrgcp.proto
This is the Protobuf proto file. Which can be compiled into code to use with Python/Go/etc.

For Python for example:
```
protoc --python_out=. --pyi_out=. nrgcp.proto
```

### protobuf_websocket.lua
This is a lua decoder for the Protobuf inside a Websocket for Wireshark.
You can put this inside `~/.local/lib/wireshark/plugins/`, which will make Wireshark print the protobuf data in a visible form.

## Protocol
The protocol used is in fact quite easy.
Every request had some header with the following fields:
- "type" -> GET/UPDATE
- "service" -> "CHARGE_CONTROL"/"WIFI"/...
- "property" -> "DYNAMIC_VALUES"/"STATUS"/...
- "uuid" -> UUID for authentication

Then also a "metdata" with a "requestId", this to be able to match the response with the request.
```
{
    "header": {
    "type": "GET",
    "service": "CHARGE_CONTROL",
    "property": "DYNAMIC_VALUES",
    "uuid": "xxxx-xxxx-xxxxxx"
    },
    "metadata": {
    "requestId": "68225d97"
    }
}
```

# UUID
In order to communicate with the NRGkick, a UUID is required. This UUID must be added to the NRGkick and subsequently specified during communication.

The [index.html](./index.html) in this repository allows for setting the UUID via a web browser through the WebSocket protocol. Download this file to your computer and open it in your preferred web browser. Complete the form that appears on your screen, and kick the UUID into your charging cable as necessary.
