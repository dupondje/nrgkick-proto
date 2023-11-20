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

## UUID
The UUID is generated when configuring the NRGKick/App for the first time.
This UUID is the way it authenticates to your NRGKick device.
I haven't found a way to generate a new UUID for custom usage.
So if you want to use this proto in a tool, you need to capture traffic via tcpdump/wireshark and find out (with the wireshark plugin) which UUID is used. Then you can use that UUID in your own tool.
