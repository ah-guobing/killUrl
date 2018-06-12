# killUrl
Nginx URL黑名单插件，将要禁止的URL（如：http://www.123.com.cn/show/99-99.html）存入Redis List结构中

### 环境要求
Nginx安装了Lua支持

### Nginx配置
1、在 server 配置节之上添加lua扩展<br />
lua_package_path "/usr/local/nginx/conf/lua/lib/?.lua;;";<br />
lua_package_cpath "/usr/local/nginx/conf/lua/lib/?.so;;";<br />

2、在需要使用的 server 里启用URL黑名单插件<br />
&#35; 当前站点的URL，如果是非80端口，则需要写上端口好，结尾不要带/<br />
set $curURL "http://lua.com:90";<br />
&#35; 存储URL黑名单的Redis Key<br />
set $killUrls "killUrls";<br />
&#35; Redis主机IP<br />
set $redisHost "192.168.1.88";<br />
&#35; Redis主机端口<br />
set $redisPort "6379";<br />
&#35; lua_code_cache off;<br />
access_by_lua_file conf/lua/killURL.lua;<br />
