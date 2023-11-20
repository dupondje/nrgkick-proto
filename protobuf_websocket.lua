do
	local protobuf_websocket = Proto("protobuf_websocket", "Protobuf over Websocket")
	local protobuf_dissector = Dissector.get("protobuf")

	local f_length = ProtoField.uint32("protobuf_websocket.length", "Length", base.DEC)
	local f_data = ProtoField.string("protobuf_websocket.data", "Data", FT_STRING)
	protobuf_websocket.fields = { f_length, f_data }

	-- This must be the root message defined in your .proto file
	local msgtype = "nrgkick.Nrgcp"
	local f_wslength = Field.new("data.len")
	local f_wsdata = Field.new("data.data")
	local dissector

	function protobuf_websocket.dissector(tvb, pinfo, tree)
		if dissector then
			dissector:call(tvb, pinfo, tree)
		end

		local subtree = tree:add(protobuf_websocket, tvb())
		pinfo.columns.protocol:set("PROTOBUF_WEBSOCKET")

		if msgtype ~= nil then
			pinfo.private["pb_msg_type"] = "message," .. msgtype
		end
		pcall(Dissector.call, protobuf_dissector, tvb, pinfo, subtree)
	end

	-- register a chained dissector for port 8002
	local ws_dissector_table = DissectorTable.get("ws.port")
	dissector = ws_dissector_table:get_dissector(8765)
	ws_dissector_table:add(8765, protobuf_websocket)
end
