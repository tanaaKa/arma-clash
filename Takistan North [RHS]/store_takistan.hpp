//buyables set:
class bluforWeapons
{

	//category:  
	class Weapons {
		kindOf = "Weapons";
		displayName = "Weapons";

		// RIFLES
		class rhs_weap_m4a1 {
			displayName = "M4A1";
			description = "";
			price = 200;
			stock = 999;
		};
		class rhs_weap_m16a4 {
			displayName = "M16A4";
			description = "";
			price = 300;
			stock = 999;
		};
		class rhs_weap_m249 {
			displayName = "M249";
			description = "";
			price = 400;
			stock = 999;
		};
		class rhs_weap_m14ebrri {
			displayName = "M14 EBR-RI";
			description = "";
			price = 800;
			stock = 10;
		};
		// END RIFLES
		
		// LAUNCHERS
		class rhs_weap_rpg7 {
			displayName = "[LAUNCHER] RPG-7V2";
			description = "";
			price = 300;
			stock = 30;
		};
		class rhs_weap_maaws {
			displayName = "[LAUNCHER] M3 MAAWS";
			description = "";
			price = 400;
			stock = 20;
		};
		class rhs_weap_fgm148 {
			displayName = "[LAUNCHER] FGM-148 Javalin";
			description = "";
			price = 500;
			stock = 10;
		};
	};
	
	class Items {
		displayName = "Items";
		kindOf = "Items";
		
		// MEDICAL
		class ACE_elasticBandage {
			displayName = "Bandages (x2)";
			description = "";
			amount = 2;
			price = 50;
			stock = 300;    
		};
		class ACE_morphine {
			displayName = "Morphine Autoinjector";
			description = "";
			amount = 1;
			price = 50;
			stock = 300;     
		};
		class ACE_epinephrine {
			displayName = "Epinephrine Autoinjector";
			description = "";
			amount = 1;
			price = 50;
			stock = 300;  
		};
		class ACE_bloodIV_500 {
			displayName = "Bloodbag (500ml)";
			description = "";
			amount = 1;
			price = 10;
			stock = 999;
		};
		class ACE_splint {
			displayName = "Splint";
			description = "";
			amount = 1;
			price = 10;
			stock = 999;
		};
		// END MEDICAL
		
		// THROWABLES
		class HandGrenade {
			displayName = "M67 Hand Grenade";
			description = "";
			amount = 1;
			price = 100;
			stock = 200;
		};
		class SmokeShell {
			displayName = "M83 Smoke Grenade";
			description = "";
			amount = 1;
			price = 30;
			stock = 200;
		};
		// END THROWABLES
		
		// AMMUNITION
		class rhs_mag_30Rnd_556x45_M855A1_Stanag {
			displayName = "[M4/M16] Ammunition";
			description = "Three magazines of 5.56mm ammunition for the M4/M16";
			amount = 3;
			price = 200;
			stock = 999;   
		};
		class rhsusf_200rnd_556x45_mixed_box {
			displayName = "[M249] LMG Ammunition";
			description = "Two boxes of 5.56mm ammunition for the M249";
			amount = 2;
			price = 250;
			stock = 999;
		};
		class rhsusf_20Rnd_762x51_m118_special_Mag {
			displayName = "[M14] Ammunition";
			description = "Three magazines of 7.62x51mm ammunition for the M14";
			amount = 3;
			price = 250;
			stock = 999; 
		};
		class rhs_rpg7_PG7VL_mag {
			displayName = "[RPG-7V2] Rocket";
			description = "One PG-7VL HEAT rocket";
			amount = 1;
			price = 200;
			stock = 999;
		};
		class rhs_mag_maaws_HEAT {
			displayName = "[M3 MAAWS] Rocket";
			description = "One FFV751 HEAT rocket";
			amount = 1;
			price = 200;
			stock = 999;
		};
		class rhs_fgm148_magazine_AT {
			displayName = "[FGM-148 Javalin] Missile";
			description = "One FGM-148 missile";
			amount = 1;
			price = 300;
			stock = 999;
		};
		// END AMMUNITION
		
		// ATTACHMENTS
		class rhsusf_acc_eotech_xps3 {
			displayName = "[OPTIC] XPS3";
			description = "1x magnified optic";
			amount = 1;
			price = 100;
			stock = 999; 
		};
		class rhsusf_acc_acog {
			displayName = "[OPTIC] M150 RCO ACOG";
			description = "2.9x magnified optic";
			amount = 1;
			price = 250;
			stock = 999; 
		};
		class rhsusf_acc_leupoldmk4 {
			displayName = "[OPTIC] Leupold Mk4";
			description = "3.5-10x magnified optic";
			amount = 1;
			price = 400;
			stock = 999; 
		};
		// END ATTACHMENTS
		
		// EXPLOSIVES
		class SatchelCharge_Remote_Mag {
			displayName = "M183 Satchel Charge";
			description = "";
			amount = 1;
			price = 350;
			stock = 50;
		};
		// END EXPLOSIVES
		
		// MISC
		class ACE_artilleryTable {
			displayName = "Mortar table";
			description = "";
			amount = 1;
			price = 1;
			stock = 999;
		};
		// END MISC
	};
	
	class Wearables {
		displayName = "Gear";
		kindOf = "Wearables";
		
		// UNIFORMS
		class U_B_FullGhillie_ard {
			displayName = "Arid Ghillie Suit";
			description = "";
			amount = 1;
			price = 700;
			stock = 999; 
		};
		// END UNIFORMS
		
		// BACKPACKS
		class B_AssaultPack_cbr {
			displayName = "Assaultpack (Coyote)";
			description = "";
			amount = 1;
			price = 100;
			stock = 999; 
		};
		class B_Carryall_cbr {
			displayName = "Carryall (Coyote)";
			description = "";
			amount = 1;
			price = 200;
			stock = 999; 
		};
		class B_Mortar_01_weapon_F {
			displayName = "81mm Mortar Tube";
			description = "";
			amount = 1;
			price = 500;
			stock = 5; 
		};
		class B_Mortar_01_support_F {
			displayName = "81mm Mortar Bipod";
			description = "";
			amount = 1;
			price = 500;
			stock = 5; 
		};
		class I_C_HMG_02_high_weapon_F {
			displayName = "M2 .50cal Weapon";
			description = "";
			amount = 1;
			price = 500;
			stock = 15; 
		};
		class I_C_HMG_02_support_high_F {
			displayName = "M2 .50cal Tripod";
			description = "";
			amount = 1;
			price = 500;
			stock = 15;
		};
		// END BACKPACKS
	};
};

class opforWeapons
{

	//category:  
	class Weapons {
		kindOf = "Weapons";
		displayName = "Weapons";

		// RIFLES
		class rhs_weap_aks74n_npz {
			displayName = "AKS-74 with rails";
			description = "";
			price = 200;
			stock = 999;
		};
		class rhs_weap_akm_zenitco01_b33 {
			displayName = "AKM with rails";
			description = "";
			price = 300;
			stock = 999;
		};
		class rhs_weap_pkm {
			displayName = "PKM";
			description = "";
			price = 400;
			stock = 999;
		};
		class rhs_weap_svdp_wd_npz {
			displayName = "SVDM";
			description = "";
			price = 800;
			stock = 999;
		};
		// END RIFLES
		
		// LAUNCHERS
		class rhs_weap_rpg7 {
			displayName = "[LAUNCHER] RPG-7V2";
			description = "";
			price = 300;
			stock = 30;
		};
		class rhs_weap_maaws {
			displayName = "[LAUNCHER] M3 MAAWS";
			description = "";
			price = 400;
			stock = 30;
		};
		class rhs_weap_fgm148 {
			displayName = "[LAUNCHER] FGM-148 Javalin";
			description = "";
			price = 500;
			stock = 30;
		};
	};
	
	class Items {
		displayName = "Items";
		kindOf = "Items";
		
		// MEDICAL
		class ACE_elasticBandage {
			displayName = "Bandages (x2)";
			description = "";
			amount = 2;
			price = 50;
			stock = 300;    
		};
		class ACE_morphine {
			displayName = "Morphine Autoinjector";
			description = "";
			amount = 1;
			price = 50;
			stock = 300;     
		};
		class ACE_epinephrine {
			displayName = "Epinephrine Autoinjector";
			description = "";
			amount = 1;
			price = 50;
			stock = 300;  
		};
		class ACE_bloodIV_500 {
			displayName = "Bloodbag (500ml)";
			description = "";
			amount = 1;
			price = 10;
			stock = 999;
		};
		class ACE_splint {
			displayName = "Splint";
			description = "";
			amount = 1;
			price = 10;
			stock = 999;
		};
		// END MEDICAL
		
		// THROWABLES
		class HandGrenade {
			displayName = "M67 Hand Grenade";
			description = "";
			amount = 1;
			price = 100;
			stock = 200;
		};
		class SmokeShell {
			displayName = "M83 Smoke Grenade";
			description = "";
			amount = 1;
			price = 30;
			stock = 200;
		};
		// END THROWABLES
		
		// AMMUNITION
		class rhs_30Rnd_545x39_7N6M_AK {
			displayName = "[AKS-74] Ammunition";
			description = "Three magazines of 5.45mm ammunition for the AKS-74";
			amount = 3;
			price = 200;
			stock = 999;   
		};
		class rhs_30Rnd_762x39mm_bakelite {
			displayName = "[AKM] Ammunition";
			description = "Three magazines of 7.62mm ammunition for the AKM";
			amount = 3;
			price = 200;
			stock = 999;   
		};
		class rhs_100Rnd_762x54mmR {
			displayName = "[PKM] Ammunition";
			description = "Two boxes of 7.62mm ammunition for the PKM";
			amount = 2;
			price = 250;
			stock = 999;
		};
		class rhs_10Rnd_762x54mmR_7N1 {
			displayName = "[SVDM] Ammunition";
			description = "Three magazines of 7.62 ammunition for the SVDM";
			amount = 3;
			price = 250;
			stock = 999; 
		};
		class rhs_rpg7_PG7VL_mag {
			displayName = "[RPG-7V2] Rocket";
			description = "One PG-7VL HEAT rocket";
			amount = 1;
			price = 200;
			stock = 999;
		};
		class rhs_mag_maaws_HEAT {
			displayName = "[M3 MAAWS] Rocket";
			description = "One FFV751 HEAT rocket";
			amount = 1;
			price = 200;
			stock = 999;
		};
		class rhs_fgm148_magazine_AT {
			displayName = "[FGM-148 Javalin] Missile";
			description = "One FGM-148 missile";
			amount = 1;
			price = 300;
			stock = 999;
		};
		// END AMMUNITION
		
		// ATTACHMENTS
		class rhsusf_acc_eotech_xps3 {
			displayName = "[OPTIC] XPS3";
			description = "1x magnified optic";
			amount = 1;
			price = 100;
			stock = 999; 
		};
		class rhsusf_acc_acog {
			displayName = "[OPTIC] M150 RCO ACOG";
			description = "2.9x magnified optic";
			amount = 1;
			price = 250;
			stock = 999; 
		};
		class rhsusf_acc_leupoldmk4 {
			displayName = "[OPTIC] Leupold Mk4";
			description = "3.5-10x magnified optic";
			amount = 1;
			price = 400;
			stock = 999; 
		};
		// END ATTACHMENTS
		
		// EXPLOSIVES
		class SatchelCharge_Remote_Mag {
			displayName = "M183 Satchel Charge";
			description = "";
			amount = 1;
			price = 350;
			stock = 50;
		};
		// END EXPLOSIVES
		
		// MISC
		class ACE_artilleryTable {
			displayName = "Mortar table";
			description = "";
			amount = 1;
			price = 1;
			stock = 999;
		};
		// END MISC
	};
	
	class Wearables {
		displayName = "Gear";
		kindOf = "Wearables";
		
		// UNIFORMS
		class U_B_FullGhillie_ard {
			displayName = "Arid Ghillie Suit";
			description = "";
			amount = 1;
			price = 700;
			stock = 999; 
		};
		// END UNIFORMS
		
		// BACKPACKS
		class B_AssaultPack_cbr {
			displayName = "Assaultpack (Coyote)";
			description = "";
			amount = 1;
			price = 100;
			stock = 999; 
		};
		class B_Carryall_cbr {
			displayName = "Carryall (Coyote)";
			description = "";
			amount = 1;
			price = 200;
			stock = 999; 
		};
		class B_Mortar_01_weapon_F {
			displayName = "81mm Mortar Tube";
			description = "";
			amount = 1;
			price = 500;
			stock = 5; 
		};
		class B_Mortar_01_support_F {
			displayName = "81mm Mortar Bipod";
			description = "";
			amount = 1;
			price = 500;
			stock = 5; 
		};
		class I_C_HMG_02_high_weapon_F {
			displayName = "M2 .50cal Weapon";
			description = "";
			amount = 1;
			price = 500;
			stock = 15; 
		};
		class I_C_HMG_02_support_high_F {
			displayName = "M2 .50cal Tripod";
			description = "";
			amount = 1;
			price = 500;
			stock = 15;
		};
		// END BACKPACKS
	};
};