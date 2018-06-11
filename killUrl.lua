local function close(red)
  if not red then
    return
  end
  --local ok,err = red:close() --直接关闭
  --连接池实现释放连接--
  local pool_max_idle_time = 1000 --ms
  local pool_size = 100 --连接池大小
  local ok,err = red:set_keepalive(pool_max_idle_time,pool_size)
  if not ok then
	ngx.header['killURL'] = 'redis closed err：'..err
        ngx.exit(500)
  end
end



local redis = require "resty.redis"
local redisKey = ngx.var.killUrls
local request_uri = ngx.var.curURL..ngx.var.request_uri


--创建实例
local red = redis:new()
red:set_timeout(1000) --ms
local ip = ngx.var.redisHost
local port = ngx.var.redisPort
local ok,err = red:connect(ip,port)
if not ok then
	ngx.header['killURL'] = err
	close(red)
	ngx.exit(500)
end



local list,err = red:eval("return redis.call('lrange',KEYS[1],0,-1)",1,redisKey);
for i,v in ipairs(list) do
	if string.find(request_uri,v,1,true) then
		ngx.header['killURL'] = 'This URL is forbidden to access'
		close(red)
		ngx.exit(404)
	end
end



close(red)

