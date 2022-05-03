fx_version 'adamant'
games { 'gta5' }

client_scripts {
    "rageui/RMenu.lua",
    "rageui/menu/RageUI.lua",
    "rageui/menu/Menu.lua",
    "rageui/menu/MenuController.lua",
    "rageui/components/Audio.lua",
    "rageui/components/Rectangle.lua",
    "rageui/components/Screen.lua",
    "rageui/components/Sprite.lua",
    "rageui/components/Text.lua",
    "rageui/components/Visual.lua",
    "rageui/menu/elements/ItemsBadge.lua",
    "rageui/menu/elements/ItemsColour.lua",
    "rageui/menu/elements/PanelColour.lua",
    "rageui/menu/items/UIButton.lua",
    "rageui/menu/items/UICheckBox.lua",
    "rageui/menu/items/UIList.lua",
    "rageui/menu/items/UIProgress.lua",
    "rageui/menu/items/UISlider.lua",
    "rageui/menu/items/UISliderHeritage.lua",
    "rageui/menu/items/UISeparator.lua",
    "rageui/menu/items/UISliderProgress.lua",
    "rageui/menu/panels/UIColourPanel.lua",
    "rageui/menu/panels/UIGridPanel.lua",
    "rageui/menu/panels/UIGridPanelHorizontal.lua",
    "rageui/menu/panels/UIPercentagePanel.lua",
    "rageui/menu/panels/UIStatisticsPanel.lua",
    "rageui/menu/windows/UIHeritage.lua",
	"lib/Proxy.lua",
    "lib/Tunnel.lua",
    "client/cl_*.lua",
}

server_scripts {
    "@lvl/lib/utils.lua",
    "server/sv_*.lua"
}

shared_scripts {
    "cfgs/cfg_*.lua"
}
  