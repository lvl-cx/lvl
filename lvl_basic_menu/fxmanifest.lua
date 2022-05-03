--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

fx_version 'cerulean'
games { 'gta5' }

description "lvl_basic_menu"


client_scripts{ 
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client.lua",
  "playerblips/client.lua",
  "tptowaypoint/client.lua",
  "drag/client.lua",
  "spikes/client.lua"
}

server_scripts{ 
  "@lvl/lib/utils.lua",
  "server.lua"
}
