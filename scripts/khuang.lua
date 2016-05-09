function load_counter_from_file(file)
  local content = 0
  local f = io.open(file, "r")
  content = tonumber(f:read())
  f:close()

  local f = io.open(file, "w+")
  if content > 310000 then
    f:write(tostring(0))
  else
    f:write(tostring(content+10000))
  end
  f:close()

  return content
end

counter = load_counter_from_file("/home/ubuntu/wrk/scripts/counter.txt")
print("khuang: generate request count=", counter)

request = function()
  -- Get the next requests array element
  local request_object = {
    path="/errors",
    body=nil,
    method="POST",
    headers={}
  }
  request_object.headers["Content-Type"]="text/json"
  -- request_object.body="{\"id\":"..counter.."}"
  request_object.body="{\"id\":"..counter..", \"event_properties\": {\"playable_id\": \"55555_55555\"}}\r\n{\"id\":"..counter..", \"event_properties\": {\"playable_id\": \"55555_55555\"}}"
  -- Increment the counter
  counter = counter + 1

  -- Return the request object with the current URL path
  return wrk.format(request_object.method, request_object.path, request_object.headers, request_object.body)
end
