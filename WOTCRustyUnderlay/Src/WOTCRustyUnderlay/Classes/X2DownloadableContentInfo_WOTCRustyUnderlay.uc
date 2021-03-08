//*******************************************************************************************
//  FILE:   X2DownloadableContentInfo_WOTCRustyUnderlay.uc                                    
//  
//	File created by RustyDios	06/12/19	12:35	
//	LAST UPDATED				03/12/20	12:00
//
//	This OPTC opens up the 'Reinforced Underlay Breakthrough' tech from
//		the Purifier Autopsy to be config editable
//
//*******************************************************************************************

class X2DownloadableContentInfo_WOTCRustyUnderlay extends X2DownloadableContentInfo config (RustyUnderlay);

// Grab variables from the config
var config bool bEnableLogging;
		// basic stats
var config int iRUSTYUNDERLAY_BONUS_HP;
var config int iRUSTYUNDERLAY_BONUS_OFFENSE; //aim
var config int iRUSTYUNDERLAY_BONUS_MOBILITY;
var config int iRUSTYUNDERLAY_BONUS_WILL;
var config int iRUSTYUNDERLAY_BONUS_DODGE;
		// advanced stats
var config int iRUSTYUNDERLAY_BONUS_DEFENSE;
var config int iRUSTYUNDERLAY_BONUS_HACK;
var config int iRUSTYUNDERLAY_BONUS_PSIOFF;
var config int iRUSTYUNDERLAY_BONUS_CRITCHANCE;
		// flank stats
var config int iRUSTYUNDERLAY_BONUS_FLANKINGCRITCHANCE;
var config int iRUSTYUNDERLAY_BONUS_FLANKINGAIM;
		// sight
var config int iRUSTYUNDERLAY_BONUS_SIGHT;
		// Armour and Shields
var config int iRUSTYUNDERLAY_BONUS_ARMOUR;
var config int iRUSTYUNDERLAY_BONUS_ARMOURPIPS;
var config int iRUSTYUNDERLAY_BONUS_ABLATIVESHIELDS;
		// Icon Display
var config bool bRUSTYUNDERLAY_SHOWPASSIVEICON;
var config bool bRUSTYUNDERLAY_SHOWINARMOURY;
		// Items excluded from armoury icon
var config array<name>	ExcludedItems;
		// Localized Strings for UI display
//var localized string strRustyUnderlayShields;
//var localized string strRustyUnderlaySight;
 
/// Called on new campaign while this DLC / Mod is installed
static event InstallNewCampaign(XComGameState StartState){}		//empty_func

/// Called on first time load game if not already installed	
static event OnLoadedSavedGame()
{
	PatchDefenseUnderlays();
}

// Called on load into a save game strategy layer
static event OnLoadedSavedGameToStrategy()
{
	PatchDefenseUnderlays();
}

//*******************************************************************************************
// Patch all defense items in the inventory, 
//	- called on Load Save to Strat AND at end of Purifier Autopsy
//*******************************************************************************************

static function PatchDefenseUnderlays()
{
	local XComGameState_HeadquartersXCom	XComHQ;

	local X2ItemTemplateManager				AllItems;
	local X2EquipmentTemplate				ItemTemplate;
	local X2DataTemplate					Template;

	//get the XCOM HQ, updated code from Astral Descend
	//History = `XCOMHISTORY;
	//XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = `XCOMHQ;

	//get the item manager
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	//if set to be shown by the config
	if (default.bRUSTYUNDERLAY_SHOWINARMOURY)
	{
		//go through every item template in the game
		foreach AllItems.IterateTemplates(Template, none)
		{
			//ensure the item is a piece of equipment
			ItemTemplate = X2EquipmentTemplate(Template);

			//find ~XCOM~ item templates with the defense cat
			if(ItemTemplate != none && ItemTemplate.ItemCat == 'defense' && default.ExcludedItems.Find(ItemTemplate.DataName) < 0 )//XComHQ.HasItem(ItemTemplate) )
			{
				//if it's there, remove it, this resets in case a game switch has happened where the templates have already been adjusted
				ItemTemplate.Abilities.RemoveItem('RustyUnderlayPassive');

				//report the change to log
				`LOG("Patched Defense Item: "@ItemTemplate.GetItemFriendlyName() @" :: Template: "@ItemTemplate.DataName @" :: Icon Removed",default.bEnableLogging,'WOTCRustyUnderlay');

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
	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel,			eStat_HP,					default.iRUSTYUNDERLAY_BONUS_HP					);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,			eStat_Offense,				default.iRUSTYUNDERLAY_BONUS_OFFENSE			);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel,		eStat_Mobility,				default.iRUSTYUNDERLAY_BONUS_MOBILITY			);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel,			eStat_Will,					default.iRUSTYUNDERLAY_BONUS_WILL				);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel,			eStat_Dodge,				default.iRUSTYUNDERLAY_BONUS_DODGE				);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DefenseLabel,		eStat_Defense,				default.iRUSTYUNDERLAY_BONUS_DEFENSE			);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechLabel,			eStat_Hacking,				default.iRUSTYUNDERLAY_BONUS_HACK				);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseLabel,		eStat_PsiOffense,			default.iRUSTYUNDERLAY_BONUS_PSIOFF				);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.CriticalChanceLabel,	eStat_CritChance,			default.iRUSTYUNDERLAY_BONUS_CRITCHANCE			);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.FlankingCritBonus,	eStat_FlankingCritChance,	default.iRUSTYUNDERLAY_BONUS_FLANKINGCRITCHANCE	);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.FlankingAimBonus,	eStat_FlankingAimBonus,		default.iRUSTYUNDERLAY_BONUS_FLANKINGAIM		);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel,			eStat_ArmorMitigation,		default.iRUSTYUNDERLAY_BONUS_ARMOURPIPS			);
	Template.SetUIStatMarkup(default.strRustyUnderlayShields,					eStat_ShieldHP,				default.iRUSTYUNDERLAY_BONUS_ABLATIVESHIELDS	);
	Template.SetUIStatMarkup(default.strRustyUnderlaySight,						eStat_SightRadius,			default.iRUSTYUNDERLAY_BONUS_SIGHT				);
}
*/
//*******************************************************************************************
// ADD/CHANGES AFTER TEMPLATES LOAD ~ OPTC ~
//*******************************************************************************************

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager			AllAbilities;		//holder for all abilities
	local X2AbilityTemplate					CurrentAbility;		//current thing to focus on
	local X2Effect_PersistentStatChange		StatEffectsToAdd;	//Added to Deadeye

	local X2StrategyElementTemplateManager	AllTechs;			//holder for all strats
	local X2StrategyElementTemplate			CurrentStrat;		//current strat to focus on
	local X2TechTemplate					CurrentTech;		//current tech to focus on

	//Karen !! get the managers !
	AllAbilities		= class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AllTechs			= class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	//////////////////////////////////////////////////////////////////////////////////////////
	// Switch up the Autopsy complete function to include my patch
	//////////////////////////////////////////////////////////////////////////////////////////

	CurrentStrat = AllTechs.FindStrategyElementTemplate('AutopsyAdventPurifier');
	if (CurrentStrat != none)
	{
		CurrentTech = X2TechTemplate(CurrentStrat);

		CurrentTech.ResearchCompletedFn = class'X2StrategyElement_RustyUnderlay'.static.AutopsyAdventPurifierTacticalBonusCompleted_Rusty;
		`LOG("Patched TechTemplate: "@CurrentTech.DataName ,default.bEnableLogging,'WOTCRustyUnderlay');
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// Expand and Expose the underlay values to config
	//////////////////////////////////////////////////////////////////////////////////////////

	CurrentAbility = AllAbilities.FindAbilityTemplate('PurifierAutopsyVestBonus');
	if (CurrentAbility != none)
	{
		//change the icon
		CurrentAbility.AbilitySourceName = 'eAbilitySource_Commander'; // Green		was eAbilitySource_Perk		= Yellow
		CurrentAbility.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_flamesealant";  // or nanofibervest
		//CurrentAbility.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
		//CurrentAbility.Hostility = eHostility_Neutral;

		// change how it triggers ... default to everyone 100% on tactical start
		//CurrentAbility.AbilityToHitCalc = default.DeadEye;
		//TargetStyle = new class'X2AbilityTarget_Self';
		//CurrentAbility.AbilityTargetStyle = TargetStyle;
		//Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
		//CurrentAbility.AbilityTriggers.AddItem(Trigger);

		//ensure only one icon shows on tactical map
		CurrentAbility.OverrideAbilities.AddItem('RustyUnderlayPassive');

		//clear the previous settings
		CurrentAbility.AbilityTargetEffects.Length = 0;

		//configure the new settings
		StatEffectsToAdd = new class'X2Effect_PersistentStatChange';
		StatEffectsToAdd.BuildPersistentEffect(1, true, false, false);
			// basic stats
		StatEffectsToAdd.AddPersistentStatChange(eStat_HP,					default.iRUSTYUNDERLAY_BONUS_HP);
		StatEffectsToAdd.AddPersistentStatChange(eStat_Offense,				default.iRUSTYUNDERLAY_BONUS_OFFENSE);
		StatEffectsToAdd.AddPersistentStatChange(eStat_Mobility,			default.iRUSTYUNDERLAY_BONUS_MOBILITY);
		StatEffectsToAdd.AddPersistentStatChange(eStat_Will,				default.iRUSTYUNDERLAY_BONUS_WILL);
		StatEffectsToAdd.AddPersistentStatChange(eStat_Dodge,				default.iRUSTYUNDERLAY_BONUS_DODGE);
			// advanced stats
		StatEffectsToAdd.AddPersistentStatChange(eStat_Defense,				default.iRUSTYUNDERLAY_BONUS_DEFENSE);
		StatEffectsToAdd.AddPersistentStatChange(eStat_Hacking,				default.iRUSTYUNDERLAY_BONUS_HACK);
		StatEffectsToAdd.AddPersistentStatChange(eStat_PsiOffense,			default.iRUSTYUNDERLAY_BONUS_PSIOFF);
		StatEffectsToAdd.AddPersistentStatChange(eStat_CritChance,			default.iRUSTYUNDERLAY_BONUS_CRITCHANCE);
			// flank stats
		StatEffectsToAdd.AddPersistentStatChange(eStat_FlankingCritChance,	default.iRUSTYUNDERLAY_BONUS_FLANKINGCRITCHANCE);
		StatEffectsToAdd.AddPersistentStatChange(eStat_FlankingAimBonus,	default.iRUSTYUNDERLAY_BONUS_FLANKINGAIM);
			// sight
		StatEffectsToAdd.AddPersistentStatChange(eStat_SightRadius,			default.iRUSTYUNDERLAY_BONUS_SIGHT);
			// Armour and Shields
		StatEffectsToAdd.AddPersistentStatChange(eStat_ArmorChance,			default.iRUSTYUNDERLAY_BONUS_ARMOUR);
		StatEffectsToAdd.AddPersistentStatChange(eStat_ArmorMitigation,		default.iRUSTYUNDERLAY_BONUS_ARMOURPIPS);
		StatEffectsToAdd.AddPersistentStatChange(eStat_ShieldHP,			default.iRUSTYUNDERLAY_BONUS_ABLATIVESHIELDS);

		//show a passive icon in tactical layer only
		if (default.bRUSTYUNDERLAY_SHOWPASSIVEICON)
		{
			StatEffectsToAdd.SetDisplayInfo(ePerkBuff_Passive, CurrentAbility.LocFriendlyName, CurrentAbility.GetMyLongDescription(), CurrentAbility.IconImage,true,,CurrentAbility.AbilitySourceName);
		}

		//actually add the effects to the ability
		CurrentAbility.AddTargetEffect(StatEffectsToAdd);

		//control setting the stats on UI - did not work correctly?
	
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel,			eStat_HP,					default.iRUSTYUNDERLAY_BONUS_HP,					true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,				eStat_Offense,				default.iRUSTYUNDERLAY_BONUS_OFFENSE,				true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel,			eStat_Mobility,				default.iRUSTYUNDERLAY_BONUS_MOBILITY,				true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel,				eStat_Will,					default.iRUSTYUNDERLAY_BONUS_WILL,					true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel,			eStat_Dodge,				default.iRUSTYUNDERLAY_BONUS_DODGE,					true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.DefenseLabel,			eStat_Defense,				default.iRUSTYUNDERLAY_BONUS_DEFENSE,				true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.TechLabel,				eStat_Hacking,				default.iRUSTYUNDERLAY_BONUS_HACK,					true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseLabel,		eStat_PsiOffense,			default.iRUSTYUNDERLAY_BONUS_PSIOFF,				true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.CriticalChanceLabel,	eStat_CritChance,			default.iRUSTYUNDERLAY_BONUS_CRITCHANCE,			true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.FlankingCritBonus,		eStat_FlankingCritChance,	default.iRUSTYUNDERLAY_BONUS_FLANKINGCRITCHANCE,	true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.FlankingAimBonus,		eStat_FlankingAimBonus,		default.iRUSTYUNDERLAY_BONUS_FLANKINGAIM,			true);
		CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel,			eStat_ArmorMitigation,		default.iRUSTYUNDERLAY_BONUS_ARMOURPIPS,			true);
		//CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.ShieldLabel,			eStat_ShieldHP,				default.iRUSTYUNDERLAY_BONUS_ABLATIVESHIELDS,		true);
		//CurrentAbility.SetUIStatMarkup(class'XLocalizedData'.default.SightLabel,			eStat_SightRadius,			default.iRUSTYUNDERLAY_BONUS_SIGHT,					true);
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
		case 'iRUSTYUNDERLAY_BONUS_HP':
			if (default.iRUSTYUNDERLAY_BONUS_HP >= 1) 					{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_HP) @ " Bonus to Health.<br/>";								return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_OFFENSE':
			if (default.iRUSTYUNDERLAY_BONUS_OFFENSE >= 1)				{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_OFFENSE) @ " Bonus to Aim %.<br/>";							return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_MOBILITY':
			if (default.iRUSTYUNDERLAY_BONUS_MOBILITY >= 1)				{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_MOBILITY) @ " Bonus to Mobility.<br/>";						return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_WILL':
			if (default.iRUSTYUNDERLAY_BONUS_WILL >= 1)					{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_WILL) @ " Bonus to Will.<br/>";								return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_DODGE':
			if (default.iRUSTYUNDERLAY_BONUS_DODGE >= 1)				{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_DODGE) @ " Bonus to Dodge.<br/>";								return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_DEFENSE':
			if (default.iRUSTYUNDERLAY_BONUS_DEFENSE >= 1)				{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_DEFENSE) @ " Bonus to Defense.<br/>";							return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_HACK':
			if (default.iRUSTYUNDERLAY_BONUS_HACK >= 1)					{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_HACK) @ " Bonus to Hacking.<br/>";								return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_PSIOFF':
			if (default.iRUSTYUNDERLAY_BONUS_PSIOFF >= 1)				{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_PSIOFF) @ " Bonus to Psi Offense.<br/>";						return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_CRITCHANCE':
			if (default.iRUSTYUNDERLAY_BONUS_CRITCHANCE >= 1)			{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_CRITCHANCE) @ " Bonus to Critical Hit %.<br/>";				return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_FLANKINGCRITCHANCE':
			if (default.iRUSTYUNDERLAY_BONUS_FLANKINGCRITCHANCE >= 1)	{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_FLANKINGCRITCHANCE) @ " Bonus to Crit % whilst flanking.<br/>";return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_FLANKINGAIM':
			if (default.iRUSTYUNDERLAY_BONUS_FLANKINGAIM >= 1)			{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_FLANKINGAIM) @ " Bonus to Aim % whilst flanking.<br/>";		return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_SIGHT':
			if (default.iRUSTYUNDERLAY_BONUS_SIGHT >= 1)				{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_SIGHT) @ " Bonus to Sight Radius.<br/>";						return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_ARMOURPIPS':
			if (default.iRUSTYUNDERLAY_BONUS_ARMOURPIPS >= 1)			{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_ARMOURPIPS) @ " Bonus to Armour.<br/>";						return true;		}
			else	{	OutString = "";		return true;	}

		case 'iRUSTYUNDERLAY_BONUS_ABLATIVESHIELDS':
			if (default.iRUSTYUNDERLAY_BONUS_ABLATIVESHIELDS >= 1)		{OutString = "<Bullet/> +" @ string(default.iRUSTYUNDERLAY_BONUS_ABLATIVESHIELDS) @ " Bonus to Shields.<br/>";					return true;		}
			else	{	OutString = "";		return true;	}
		default:
            return false;
    }  
}
