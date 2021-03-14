//*******************************************************************************************
//  FILE:   X2DownloadableContentInfo_WOTCRustyUnderlay.uc                                    
//  
//	File created by RustyDios	06/12/19	12:35	
//	LAST UPDATED				11/03/21	12:00
//
//	This OPTC opens up the 'Reinforced Underlay Breakthrough' tech from
//		the Purifier Autopsy to be config editable
//
//*******************************************************************************************

class X2DownloadableContentInfo_WOTCRustyUnderlay extends X2DownloadableContentInfo config (RustyUnderlay);

// Grab variables from the config
var localized string AblativeHP;

var config bool bEnableLogging;
		
var config int iRUSTYUNDERLAY_HP, iRUSTYUNDERLAY_OFFENSE, iRUSTYUNDERLAY_MOBILITY, iRUSTYUNDERLAY_WILL, iRUSTYUNDERLAY_DODGE;	// basic stats
var config int iRUSTYUNDERLAY_DEFENSE, iRUSTYUNDERLAY_HACK, iRUSTYUNDERLAY_PSIOFF, iRUSTYUNDERLAY_CRITCHANCE;			// advanced stats
var config int iRUSTYUNDERLAY_FLANKINGCRITCHANCE, iRUSTYUNDERLAY_FLANKINGAIM;							// flank stats
var config int iRUSTYUNDERLAY_ARMOUR, iRUSTYUNDERLAY_ARMOURPIPS, iRUSTYUNDERLAY_ABLATIVESHIELDS;				// Armour and Shields
var config bool bRUSTYUNDERLAY_SHOWPASSIVEICON, bRUSTYUNDERLAY_SHOWINARMOURY;							// Icon Display

var config array<name>	ExcludedItems;		// Items excluded from armoury icon

//*******************************************************************************************
/// Called on new campaign while this DLC / Mod is installed
static event InstallNewCampaign(XComGameState StartState){}		//empty_func

/// Called on first time load game if not already installed	
static event OnLoadedSavedGame()
{
	CheckAndConfirmAutopsyComplete();
}

// Called on load into a save game strategy layer
static event OnLoadedSavedGameToStrategy()
{
	CheckAndConfirmAutopsyComplete();
}

//*******************************************************************************************
// Check the XCOMHQ boolean matches the autopsy being done 
//	- called on Load Save to Strat
//*******************************************************************************************
//console function to forece the below
exec function RustyFix_Underlay_ForcePostAutopsy()
{
	CheckAndConfirmAutopsyComplete(true);
}

static function CheckAndConfirmAutopsyComplete(bool bForce = false)
{
	local XComGameState_HeadquartersXCom	XComHQ;
	local array<XComGameState_Tech>			CompletedTechs;
	local XComGameState_Tech				TechState;

	XComHQ = `XCOMHQ;

	CompletedTechs = XComHQ.GetAllCompletedTechStates();

	foreach CompletedTechs(TechState)
	{
		if(TechState.GetMyTemplateName() == 'AutopsyAdventPurifier')
		{
			//autopsy IS done, ensure the HQ toggle is on
		
			`LOG("Purifier Autopsy was complete. Reinforced Underlay toggle is ::" @XComHQ.bReinforcedUnderlay, default.bEnableLogging,'WOTCRustyUnderlay');
			if (!XComHQ.bReinforcedUnderlay)
			{
				XComHQ.bReinforcedUnderlay = true;
				`LOG("Purifier Autopsy was complete. Reinforced Underlay toggle was set to ::" @XComHQ.bReinforcedUnderlay, default.bEnableLogging,'WOTCRustyUnderlay');
			}

			`LOG("Purifier Autopsy was complete. Reinforced Underlay popup seen was ::" @XComHQ.bHasSeenReinforcedUnderlayPopup, default.bEnableLogging,'WOTCRustyUnderlay');
			if (!XComHQ.bHasSeenReinforcedUnderlayPopup)
			{
				XComHQ.bHasSeenReinforcedUnderlayPopup = true;
				`LOG("Purifier Autopsy was complete. Reinforced Underlay popup was set to ::" @XComHQ.bHasSeenReinforcedUnderlayPopup, default.bEnableLogging,'WOTCRustyUnderlay');
			}

		}
	}//end foreach

	if (bForce)
	{
		XComHQ.bReinforcedUnderlay = true;
		XComHQ.bHasSeenReinforcedUnderlayPopup = true;
		`LOG("Reinforced Underlay was forced active by console command", bForce,'WOTCRustyUnderlay');
	}

	//now actually set an icon for the armory
	//actual PurifierAutopsyVestBonus is given elsewhere in the on load to tactical...
	PatchDefenseUnderlays();

}

//*******************************************************************************************
// Patch all defense items in the inventory, 
//	- called on Load Save to Strat AND at end of Purifier Autopsy
//*******************************************************************************************

static function PatchDefenseUnderlays()
{
	local XComGameState_HeadquartersXCom	XComHQ;

	local X2ItemTemplateManager				ItemMgr;
	local X2EquipmentTemplate				ItemTemplate;
	local X2DataTemplate					Template;

	//get the XCOM HQ, updated code from Astral Descend
	//History = `XCOMHISTORY;
	//XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = `XCOMHQ;

	//get the item manager
	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	//if set to be shown by the config
	if (default.bRUSTYUNDERLAY_SHOWINARMOURY)
	{
		//go through every item template in the game
		foreach ItemMgr.IterateTemplates(Template, none)
		{
			//ensure the item is a piece of equipment
			ItemTemplate = X2EquipmentTemplate(Template);

			//find ~XCOM~ item templates with the defense cat
			if(ItemTemplate != none && ItemTemplate.ItemCat == 'defense' && default.ExcludedItems.Find(ItemTemplate.DataName) < 0 )//XComHQ.HasItem(ItemTemplate) )
			{
				//if it's there, remove it, this resets in case a game switch has happened where the templates have already been adjusted
				if (ItemTemplate.Abilities.Find('RustyUnderlayPassive') != INDEX_NONE)
				{
					ItemTemplate.Abilities.RemoveItem('RustyUnderlayPassive');

					//report the change to log
					`LOG("Patched Defense Item: "@ItemTemplate.GetItemFriendlyName() @" :: Template: "@ItemTemplate.DataName @" :: Icon Removed",default.bEnableLogging,'WOTCRustyUnderlay');
				}

				//IF Purifier Autopsy is done/Reinforced Underlay is active
				if (XComHQ.bReinforcedUnderlay)
				{
					//add it back
					ItemTemplate.Abilities.AddItem('RustyUnderlayPassive');
					//AugmentStatMarkups(ItemTemplate);	// ~ removed, didn't function as well as I thought it would

					//report the change to log
					`LOG("Patched Defense Item: "@ItemTemplate.GetItemFriendlyName() @" :: Template: "@ItemTemplate.DataName @" :: Added Icon Post HQ Check",default.bEnableLogging,'WOTCRustyUnderlay');
				}
			}
		}
	}
}

//*******************************************************************************************
// Change the Stat Markups on items to include values from this mod
//	~ removed, didn't function as well as I thought it would
//	~ code kept in case I can make it work better, maybe, not the first mod with commented out 'dead code'
//*******************************************************************************************
/*
static function AugmentStatMarkups(X2EquipmentTemplate Template)
{
	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel,			eStat_HP,					default.iRUSTYUNDERLAY_HP					);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,			eStat_Offense,				default.iRUSTYUNDERLAY_OFFENSE				);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel,		eStat_Mobility,				default.iRUSTYUNDERLAY_MOBILITY				);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel,			eStat_Will,					default.iRUSTYUNDERLAY_WILL					);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel,			eStat_Dodge,				default.iRUSTYUNDERLAY_DODGE				);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DefenseLabel,		eStat_Defense,				default.iRUSTYUNDERLAY_DEFENSE				);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechLabel,			eStat_Hacking,				default.iRUSTYUNDERLAY_HACK					);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseLabel,		eStat_PsiOffense,			default.iRUSTYUNDERLAY_PSIOFF				);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.CriticalChanceLabel,	eStat_CritChance,			default.iRUSTYUNDERLAY_CRITCHANCE			);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.FlankingCritBonus,	eStat_FlankingCritChance,	default.iRUSTYUNDERLAY_FLANKINGCRITCHANCE	);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.FlankingAimBonus,	eStat_FlankingAimBonus,		default.iRUSTYUNDERLAY_FLANKINGAIM			);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel,			eStat_ArmorMitigation,		default.iRUSTYUNDERLAY_ARMOURPIPS			);
	Template.SetUIStatMarkup(default.AblativeHP,								eStat_ShieldHP,				default.iRUSTYUNDERLAY_ABLATIVESHIELDS		);
}
*/
//*******************************************************************************************
// ADD/CHANGES AFTER TEMPLATES LOAD ~ OPTC ~
//*******************************************************************************************

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager			AbilityMgr;			//holder for all abilities
	local X2AbilityTemplate					AbilityTemplate;	//current thing to focus on
	local X2Effect_PersistentStatChange		StatEffectsToAdd;	//Added to Deadeye

	local X2StrategyElementTemplateManager	StratMgr;			//holder for all strats
	local X2StrategyElementTemplate			StratTemplate;		//current strat to focus on
	local X2TechTemplate					TechTemplate;		//current tech to focus on

	//Karen !! get the managers !
	AbilityMgr	= class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	StratMgr	= class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	//////////////////////////////////////////////////////////////////////////////////////////
	// Switch up the Autopsy complete function to include my patch
	//////////////////////////////////////////////////////////////////////////////////////////

	StratTemplate = StratMgr.FindStrategyElementTemplate('AutopsyAdventPurifier');
	if (StratTemplate != none)
	{
		TechTemplate = X2TechTemplate(StratTemplate);

		TechTemplate.ResearchCompletedFn = class'X2StrategyElement_RustyUnderlay'.static.AutopsyAdventPurifierTacticalBonusCompleted_Rusty;
		`LOG("Patched TechTemplate: "@TechTemplate.DataName ,default.bEnableLogging,'WOTCRustyUnderlay');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// Expand and Expose the underlay values to config
	//////////////////////////////////////////////////////////////////////////////////////////

	AbilityTemplate = AbilityMgr.FindAbilityTemplate('PurifierAutopsyVestBonus');
	if (AbilityTemplate != none)
	{
		//change the icon
		AbilityTemplate.AbilitySourceName = 'eAbilitySource_Commander'; // Green	was eAbilitySource_Perk		= Yellow
		AbilityTemplate.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_flamesealant";  // or nanofibervest

		//ensure only one icon shows on tactical map
		AbilityTemplate.OverrideAbilities.AddItem('RustyUnderlayPassive');

		//clear the previous settings !!
		AbilityTemplate.AbilityTargetEffects.Length = 0;

		//configure the new settings
		StatEffectsToAdd = new class'X2Effect_PersistentStatChange';
		StatEffectsToAdd.BuildPersistentEffect(1, true, false, false);
			// basic stats
		StatEffectsToAdd.AddPersistentStatChange(eStat_HP,					default.iRUSTYUNDERLAY_HP);
		StatEffectsToAdd.AddPersistentStatChange(eStat_Offense,				default.iRUSTYUNDERLAY_OFFENSE);
		StatEffectsToAdd.AddPersistentStatChange(eStat_Mobility,			default.iRUSTYUNDERLAY_MOBILITY);
		StatEffectsToAdd.AddPersistentStatChange(eStat_Will,				default.iRUSTYUNDERLAY_WILL);
		StatEffectsToAdd.AddPersistentStatChange(eStat_Dodge,				default.iRUSTYUNDERLAY_DODGE);
			// advanced stats
		StatEffectsToAdd.AddPersistentStatChange(eStat_Defense,				default.iRUSTYUNDERLAY_DEFENSE);
		StatEffectsToAdd.AddPersistentStatChange(eStat_Hacking,				default.iRUSTYUNDERLAY_HACK);
		StatEffectsToAdd.AddPersistentStatChange(eStat_PsiOffense,			default.iRUSTYUNDERLAY_PSIOFF);
		StatEffectsToAdd.AddPersistentStatChange(eStat_CritChance,			default.iRUSTYUNDERLAY_CRITCHANCE);
			// flank stats
		StatEffectsToAdd.AddPersistentStatChange(eStat_FlankingCritChance,	default.iRUSTYUNDERLAY_FLANKINGCRITCHANCE);
		StatEffectsToAdd.AddPersistentStatChange(eStat_FlankingAimBonus,	default.iRUSTYUNDERLAY_FLANKINGAIM);
			// Armour and Shields
		StatEffectsToAdd.AddPersistentStatChange(eStat_ArmorChance,			default.iRUSTYUNDERLAY_ARMOUR);
		StatEffectsToAdd.AddPersistentStatChange(eStat_ArmorMitigation,		default.iRUSTYUNDERLAY_ARMOURPIPS);
		StatEffectsToAdd.AddPersistentStatChange(eStat_ShieldHP,			default.iRUSTYUNDERLAY_ABLATIVESHIELDS);

		StatEffectsToAdd.SetDisplayInfo(ePerkBuff_Passive, AbilityTemplate.LocFriendlyName, AbilityTemplate.GetMyLongDescription(), AbilityTemplate.IconImage,
			default.bRUSTYUNDERLAY_SHOWPASSIVEICON,,AbilityTemplate.AbilitySourceName);

		//actually add the effects to the ability
		AbilityTemplate.AddTargetEffect(StatEffectsToAdd);

		//control setting the stats on UI - did not work correctly?
	
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel,			eStat_HP,					default.iRUSTYUNDERLAY_HP,					true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,				eStat_Offense,				default.iRUSTYUNDERLAY_OFFENSE,				true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel,		eStat_Mobility,				default.iRUSTYUNDERLAY_MOBILITY,			true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel,			eStat_Will,					default.iRUSTYUNDERLAY_WILL,				true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel,			eStat_Dodge,				default.iRUSTYUNDERLAY_DODGE,				true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.DefenseLabel,			eStat_Defense,				default.iRUSTYUNDERLAY_DEFENSE,				true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.TechLabel,			eStat_Hacking,				default.iRUSTYUNDERLAY_HACK,				true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseLabel,		eStat_PsiOffense,			default.iRUSTYUNDERLAY_PSIOFF,				true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.CriticalChanceLabel,	eStat_CritChance,			default.iRUSTYUNDERLAY_CRITCHANCE,			true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.FlankingCritBonus,	eStat_FlankingCritChance,	default.iRUSTYUNDERLAY_FLANKINGCRITCHANCE,	true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.FlankingAimBonus,		eStat_FlankingAimBonus,		default.iRUSTYUNDERLAY_FLANKINGAIM,			true);
		AbilityTemplate.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel,			eStat_ArmorMitigation,		default.iRUSTYUNDERLAY_ARMOURPIPS,			true);
		AbilityTemplate.SetUIStatMarkup(default.AblativeHP,									eStat_ShieldHP,				default.iRUSTYUNDERLAY_ABLATIVESHIELDS,		true);
	}
}

//*******************************************************************************************
// Tag Expansion Handler - this creates the custom string fields for localisation file
//*******************************************************************************************
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name TagText;
	
	TagText = name(InString);
	switch (TagText)
	{
		case 'RUSTYUNDERLAY_HP':
			if (default.iRUSTYUNDERLAY_HP >= 1)					{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_HP) @ " Bonus to Health.<br/>";								return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_OFFENSE':
			if (default.iRUSTYUNDERLAY_OFFENSE >= 1)			{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_OFFENSE) @ " Bonus to Aim %.<br/>";							return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_MOBILITY':
			if (default.iRUSTYUNDERLAY_MOBILITY >= 1)			{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_MOBILITY) @ " Bonus to Mobility.<br/>";						return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_WILL':
			if (default.iRUSTYUNDERLAY_WILL >= 1)				{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_WILL) @ " Bonus to Will.<br/>";								return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_DODGE':
			if (default.iRUSTYUNDERLAY_DODGE >= 1)				{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_DODGE) @ " Bonus to Dodge.<br/>";							return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_DEFENSE':
			if (default.iRUSTYUNDERLAY_DEFENSE >= 1)			{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_DEFENSE) @ " Bonus to Defense.<br/>";						return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_HACK':
			if (default.iRUSTYUNDERLAY_HACK >= 1)				{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_HACK) @ " Bonus to Hacking.<br/>";							return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_PSIOFF':
			if (default.iRUSTYUNDERLAY_PSIOFF >= 1)				{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_PSIOFF) @ " Bonus to Psi Offense.<br/>";						return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_CRITCHANCE':
			if (default.iRUSTYUNDERLAY_CRITCHANCE >= 1)			{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_CRITCHANCE) @ " Bonus to Critical Hit %.<br/>";				return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_FLANKINGCRITCHANCE':
			if (default.iRUSTYUNDERLAY_FLANKINGCRITCHANCE >= 1)	{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_FLANKINGCRITCHANCE) @ " Bonus to Crit % whilst flanking.<br/>";return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_FLANKINGAIM':
			if (default.iRUSTYUNDERLAY_FLANKINGAIM >= 1)		{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_FLANKINGAIM) @ " Bonus to Aim % whilst flanking.<br/>";		return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_ARMOURPIPS':
			if (default.iRUSTYUNDERLAY_ARMOURPIPS >= 1)			{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_ARMOURPIPS) @ " Bonus to Armour.<br/>";						return true;}
			else	{	OutString = "";		return true;	}

		case 'RUSTYUNDERLAY_ABLATIVESHIELDS':
			if (default.iRUSTYUNDERLAY_ABLATIVESHIELDS >= 1)	{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_ABLATIVESHIELDS) @ " Bonus to Shields.<br/>";				return true;}
			else	{	OutString = "";		return true;	}
		default:
            return false;
    }  
}
