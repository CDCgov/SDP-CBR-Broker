json.id message[:cbr_id]
json.source message[:source]
json.source_id message[:source_id]
json.source_received_time message[:source_received_time]
json.payload message[:payload]
json.sender message[:sender]
json.recipient message[:recipient]
json.cbr_received_time message[:cbr_received_time]
json.batch message[:batch]
json.batch_index message[:batch_index]
json.source_attributes deserialize_source_attributes(message)
