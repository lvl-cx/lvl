dependency 'lvl'






client_scripts {
	'client.lua',
	'lib/Proxy.lua',
	'lib/Tunnel.lua',
	'cl_gate.lua',
}

server_scripts{
	'@lvl/lib/utils.lua',
	'server.lua',
	'sv_gate.lua',
}
