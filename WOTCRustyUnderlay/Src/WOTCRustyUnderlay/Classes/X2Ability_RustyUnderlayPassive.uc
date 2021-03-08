//*******************************************************************************************
//  FILE:   X2DownloadableContentInfo_WOTCRustyUnderlay.uc                                    
//  
//	File created by RustyDios	06/12/19	12:35	
//	LAST UPDATED				06/12/19	15:00
//
//	This OPTC opens up the 'Reinforced Underlay Breakthrough' tech from
//		the Purifier Autopsy to be config editable
//
//*******************************************************************************************

class X2Ability_RustyUnderlayPassive extends X2Ability_DefaultAbilitySet config (RustyUnderlay);

// Grab variables from the config

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(PurePassive('RustyUnderlayPassive', "img:///UILibrary_PerkIcons.UIPerk_item_flamesealant", true, 'eAbilitySource_Commander'));

	return Templates;
}	
