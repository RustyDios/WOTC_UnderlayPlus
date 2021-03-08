//*******************************************************************************************
//  FILE:   X2StrategyElement_RustyUnderlay.uc                                    
//  
//	File created by RustyDios	11/12/19	17:00	
//	LAST UPDATED				03/12/20	11:30
//
//	'Overwrites' the Purifier autopsy tactical bonus completed function
//	Added support for Lago's Research Rework
//
//*******************************************************************************************

class X2StrategyElement_RustyUnderlay extends X2StrategyElement_XpackTechs config (RustyUnderlay);

static function AutopsyAdventPurifierTacticalBonusCompleted_Rusty(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local array<name> ItemRewards;
	local int iRandIndex;
		
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	ItemRewards = TechState.GetMyTemplate().ItemRewards;
	iRandIndex = `SYNC_RAND_STATIC(ItemRewards.Length);
	ItemTemplate = ItemTemplateManager.FindItemTemplate(ItemRewards[iRandIndex]);

	if (ItemTemplate != none)
	{
		GiveLagoReward(NewGameState, TechState, ItemTemplate);
	}

	XComHQ = XComGameState_HeadquartersXCom( `XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom') );
	XComHQ = XComGameState_HeadquartersXCom( NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID) );
	XComHQ.TacticalTechBreakthroughs.AddItem( TechState.GetReference() );
	XComHQ.bReinforcedUnderlay = true;

	`LOG("First time setup of RustyUnderlay Run" ,class'X2DownloadableContentinfo_WOTCRustyUnderlay'.default.bEnableLogging,'WOTCRustyUnderlay');
	class'X2DownloadableContentinfo_WOTCRustyUnderlay'.static.PatchDefenseUnderlays();
}

private static function GiveLagoReward(XComGameState NewGameState, XComGameState_Tech TechState, X2ItemTemplate ItemTemplate)
{	
	class'XComGameState_HeadquartersXCom'.static.GiveItem(NewGameState, ItemTemplate);

	TechState.ItemRewards.Length = 0; // Reset the item rewards array in case the tech is repeatable
	TechState.ItemRewards.AddItem(ItemTemplate); // Needed for UI Alert display info
	TechState.bSeenResearchCompleteScreen = false; // Reset the research report for techs that are repeatable
}