/*********************MANUALS (BOOKS)***********************/

//Oh god what the fuck I am not good at computer
/obj/item/weapon/book/manual
	icon = 'icons/obj/library.dmi'
	due_date = 0 // Game time in 1/10th seconds
	unique = 1   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified

/obj/item/weapon/book/manual/rpg
	name = "Gareth's Roleplay Rulebook"
	icon_state ="demonomicon"
	author = "Gareth Gygax" // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Gareth's Roleplay Rulebook"
	desc = "A thick, leather-bound tome filled with rules. This could be a long read..."
	dat = {"<html>
				<head>
					<b><center><large>Microlite20 Character Creation and Core Rules</large></center></b>
				</head>
				<body>
					<br><br>
					<center><b>Characters</b></center><br><br>
					<b>Stats:</b><br><br>

					There are 3 stats : Strength (STR), Dexterity (DEX) and Mind (MIND).<br>
					Roll 4d6, drop lowest dice. Total remaining 3 dice and allocate to one of the stats. Repeat for remaining stats.
					Stat bonus = (STAT-10)/2, round down.<br><br>
					
					Races:<br><br>
					
					Humans get +1 to all skill rolls<br>
					Elves get +2 MIND<br>
					Dwarves get +2 STR<br>
					Halflings get +2 DEX<br><br>
					
					<b>Classes</b><br><br>
					
					The classes are Fighter, Rogue, Mage, Cleric. Characters begin at Level 1.<br><br>
					
					Fighters Wear any kind of armour and use shields. They have a +3 bonus to Physical and add +1 to all attack and damage rolls. This increases by +1 at 5th level and every five levels on.<br><br>
					
					Rogues can use light armour. They have a +3 bonus to Subterfuge. If they successfully Sneak (usually Subterfuge + DEX, but depends on situation) up on a foe they can add their Subterfuge skill rank to the damage of their first attack.<br><br>
					
					Magi Wear no armour. They can cast arcane spells, and gain a +3 bonus to Knowledge.<br><br>
					
					Clerics can wear light or medium armour. They cast divine spells and gain +3 bonus to Communication. A Cleric can Turn Undead with a successful Magic Attack. DC is the current Hit Points of the Undead. If the DC is exceeded by 10 it is destroyed. This can be used (2 + Level + MIND Bonus) times per day.<br><br>
					
					<b>Skills</b><br><br>
					
					There are just 4 skills : Physical, Subterfuge, Knowledge and Communication. Roll higher than the given Difficulty Class to succeed.<br>
					Skill rank = your level + any bonus due to your class or race<br>
					Skill roll = d20 + skill rank + whatever stat bonus is most applicable to the use + situation modifiers<br>
					
					For example, Climbing would use Physical + STR bonus. Dodging a falling rock is Physical + DEX bonus. Finding a trap is Subterfuge + MIND bonus. Disabling a trap is Subterfuge + DEX bonus.<br><br>
					
					Note that there are no saving throws in this game; use Physical + STR or DEX bonus for Fortitude and Reflex saves. Saving against magic (Will save) is usually MIND bonus + your level.<br><br>
					
					<b>Magic</b><br><br>
					
					Magi can cast any arcane spell, and Clerics any divine spell, with a spell level equal or below 1/2 their class level, rounded up. They have access to all arcane spells in the SRD spell list.<br><br>
					
					Casting a spell of any kind costs Hit Points. The cost is: 1 + double the level of the spell being cast.
					So a Level 0 spell costs 1+2*0=1, a Level 1 spell 1+2*1=3 etc. etc.<br><br>
					
					This loss cannot be healed normally, but is recovered after 8 hours rest. There is no need to memorise spells in advance.<br><br>
					
					Just because a character can cast any spell, doesn't mean that they should. Choose spells that suit the character. Select one "signature" spell per level from 1st upward that they prefer to use over any other.<br>
					These spells are easier to cast due to familiarity, costing 1 less HP to use.<br><br>
					
					The Difficulty Class (DC) for all spells: 10 + Caster Level + Caster MIND bonus<br><br>
					
					
					<center><b>Combat</b></center><br><br>

					Hit Points = STR Stat + 1d6/Level. If HP reach 0, character becomes unconscious and near death. Further damage directly reduces STR. If that reaches 0, the character dies.<br><br>
					
					Roll d20 + DEX bonus for initiative order. Everyone can do one thing each turn; move, attack, cast a spell, etc.<br><br>
					
					Melee attack bonus = STR bonus + Level<br><br>
					
					Missile attack bonus = DEX bonus + Level<br><br>
					
					Magic attack bonus = MIND bonus + Level<br><br>
					
					Add attack bonus to d20 roll. If higher than your opponent's Armour Class (AC), it's a hit.A Natural 20 is automatically a critical hit doing maximum damage.<br><br>
					
					Fighters and Rogues can use DEX bonus + Level as Melee attack bonus instead if wielding a light weapon. Fighters and Rogues can wield 2 light weapons and attack with both in around if they take a -2 penalty on all attack rolls that round. Rapiers count as light weapons, but you cannot wield two rapiers at the same time.<br><br>
					
					If the total bonus is +6 or more a second attack can be made with a -5 penalty. If the total bonus is +11 or more a third attack can be made at -10.<br>
					For example, if the total bonus is +12, three attacks can be made at +12/+7/+2.<br><br>
					
					Add STR bonus to Melee damage, x2 for two handed weapons.<br>
					Armour Class (AC) = 10 + DEX bonus + Armour bonus.<br><br>
					
					<b>Other Hazards:</b><br><br>
					
					Falling: 1d6 damage per 10ï¿½, half damage on Phys+DEX save. DC = depth fallen in feet.<br><br>
					
					Spikes: add +1 point to falling damage per 10ï¿½ fallen, max +10<br><br>
					
					Poison: Phys+STR save to avoid or for half, depending on poison. Effect varies with poison type.<br><br>
					
					Extreme Heat & Cold: If not wearing suitable protection, Phys+STR save once every 10 minutes (DC 15, +1 per previous check), taking 1d6 damage on each failed save.<br><br>
					
					
					<center><b>Level Advancement</b></center><br><br>
					
					Encounter Level = Hit Dice of defeated monsters, or the given EL for the trap, situation, etc.<br>
					Add +1 for each doubling of the number of foes. eg: 1 kobold = EL1. 2 kobolds = EL2. 4 kobolds = EL3, etc.<br><br>
					
					Add up the Encounter Levels (ELs) of every encounter you take part in.<br>
					When the total = 10 x your current level, youï¿½ve advanced to the next level. Reset the total to 0 after advancing.<br><br>
					
					Each level adds:<br><br>
					
					+1d6 to Hit Points<br><br>
					
					+1 to all attack rolls<br><br>
					
					+1 to all skills<br><br>
					
					If the level divides by three (i.e. level 3,6,9, etc.), add 1 point to STR, DEX or MIND.<br><br>
					
					Fighters gain +1 to their attack and damage rolls at levels 5,10,15,etc.<br><br>
					
					Clerics and Magi gain access to new spell levels at levels 3,5,7,9,etc.<br><br>
					
					Example: The 1st level adventureres have just completed a dungeon and defeated 5 EL1 encounters, an EL2 trap and the EL3 leader. That's a total of EL10, so they all advance to level 2. They need to defeat another 20 Encounter Levels to advance to level 3.<br><br>

					
					<center><b>Equipment</b></center><br><br>

					<b>Starting Wealth</b><br><br>

					The most common coin is the gold piece (gp). A gold piece is worth 10 silver pieces. Each silver piece is worth 10 copper pieces (cp). In addition to copper, silver, and gold coins there are also platinum pieces (pp), which are each worth 10 gp.You begin with a certain amount of acquired wealth, determined by your character class.<br><br>

					Fighter: 150 gp<br><br>
					
					Rogue: 125 gp<br><br>
					
					Mage: 75 gp<br><br>
					
					Cleric: 120 gp<br><br>
					
					The character uses this accumulated wealth to purchase his initial weapons, armour, and adventuring equipment.
					Please consult the Equipment List book for a list of equipment and its prices.<br><br>
					
					<center>Have fun, and may RNG have mercy on you!</center>
				</body>
			</html>"}
	
/obj/item/weapon/book/manual/rpg/guide
	name = "Microlite20 - Player's Guide"
	icon_state ="bookDetective"
	author = "Silas Colt" // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Microlite20 - Player's Guide"
	desc = "A fan-made guide to understanding the Microlite20 rules."
	dat = {"<html>
				<head>
					<b><center><large>Microlite20 Core Rules - Abridged Version</large></center></b>
				</head>
				<body>
					<br><br>
					First, choose a name.<br>
					Then a race.<br>
					Race choices are <b>Human</b> (+1 to all skill checks), <b>Elf</b> (+2 to MIND), <b>Dwarf</b> (+2 to STRENGTH), and <b>Lizardman</b> (+2 to DEXTERITY). Your DM may have additional options at his discression.<br><br>

					Next, choose your class.<br>
					Class choices are <b>Fighter</b> (use any armour and shield. +3 to physical and 1 +1/5 levels to all attack and damage rolls), <b>Rogue</b> (not rouge. Rogues can use light armour. +3 to subterfuge. If they successfully sneak up on a foe they can add their subterfuge rank to the damage of their first attack), <b>Magic-User</b> (No armour, uses arcane spells, +3 to knowledge), and <b>Cleric</b> (Light or medium armour, cast divine spells, +3 to communication, ability to Turn Undead 2 + level + MIND bonus per day).<br><br>
					
					Then, your alignment.<br>
					The alignment is made from two parts. Chaotic to Lawful and Evil to Good. For example: Lawful Good, Chaotic Neutral, Neutral Evil, etc.<br><br>
					
					<b>Skills:</b><br>
					In Microlite20 there are jsut 4 skills: Physical, Subterfuge, Knowledge and Communication. Roll higher than the given Difficulty Class to succeed a skill check.<br>
					Skill rank = your level + any bonus due to your class or race<br>
					Skill roll = 1d20 + skill rank + whichever stat bonus is relevant + situational modifiers<br><br>
					
					<b>Combat:</b><br>
					Hit Points = STR stat + 1d6/level. If HP reaches 0, you become unconcious and are near death. Further damage that takes you into a negative ammount greater than your strength will kill you.<br>
					Roll 1D20 + DEX bonus for turn order. Everyone can do one thing per turn, in addition to moving; attack, cast a spell, use an item, etc.<br><br>
					
					Melee attack bonus = STR bonus + level<br>
					Missile attack bonus = DEX bonus + level<br>
					Magic attack bonus = MIND bonus + level<br><br>
					
					Add attack bonus to 1d20 roll. If higher than your opponent's AC it's a hit. Natural 20 is automatically a critical doing maximum damage.<br>
					
					Fighters and Rogues can use DEX bonus + level as Melee attack bonus instead, if weilding a light weapon.<br>
					Fighters and Rogues can wield 2 light weapons and attack with both of them in a round if they take a -2 penalty on all attack rolls that round. Rapiers count as light weapons, but you cannot wield two rapiers at the same time.<br><br>
					
					If the total bonus is above +5 then extra attacks may be made at -5 per extra attack.<br>
					For example: If the total bonus is +12 then three attacks can be made at +12/+7/+2<br><br>
					
					Add STR bonus to melee damage, x2 for two handed weapons.<br>
					AC = 10 + DEX bonus + Armour bonus<br><br>
					
					<b>Level Advancement:</b><br>
					More likely, your DM will just tell you to roll a character of the appropriate level for his campaign, but here you go:<br>
					EL = Hit Dice of defeated monsters, or the given EL for the trap, situation, etc. Add +1 for each doubling of the number of foes. Add up the EL of each encounter you take part in. When the total = 10 x your current level, you've advanced to the next level. Reset the total to - after advancing.<br><br>
					
					<b>Each level adds:</b><br>
					+1d6 HP<br>
					+1 to all attack rolls<br>
					+1 to all skills<br>
					If the level divides by three add 1 point to STR, DEX or MIND.<br>
					Fighters gain an additional +1 to their attack and damage rolls every five levels
				</body>
			</html>"}
	
/obj/item/weapon/book/manual/rpg/equipment
	name = "Gareth's Equipment List"
	icon_state ="bookDwarf"
	author = "Gareth Gygax" // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Gareth's Equipment List"
	desc = "A book with lists of Microlite20 equipment."
	dat = {"<html>
				<head>
					<b><center><large>Microlite20 Equipment List</large></center></b>
				</head>
				<body>
					<br><br>
					<center><b>Weapons:</b><br>
					For weapons, the order is NAME, COST, DAMAGE, RANGE(if applicable)<br><br></center>
					
					<b>Light Weapons:</b><br>
					Axe, throwing 8GP 1d6 10ft<br>
					Dagger 2GP 1d4 10ft<br>
					Gauntlet, spiked 5GP 1d4<br>
					Hammer, light 1GP 1d6 20ft<br>
					Handaxe 6GP 1d4<br>
					Mace, light 5GP 1d6<br>
					Pick, light 4GP 1d4<br>
					Sap 1GP 1d6<br>
					Sickle 6GP 1d6<br>
					Sword, short 10GP 1d6<br><br>

					<b>One-Handed Weapons:</b><br>
					Battleaxe 10GP 1d8<br>
					Club 1d6 10ft<br>
					Flail 8GP 1d8<br>
					Longsword 15GP 1d8<br>
					Mace, heavy 12GP 1d8<br>
					Morningstar 8GP 1d8<br>
					Pick, heavy 8GP 1d6<br>
					Rapier 20GP 1d6<br>
					Scimitar 15GP 1d6<br>
					Shortspear 1GP 1d6 20ft<br>
					Sword, bastard 35GP 1d10<br>
					Trident 15GP 1d8 10ft<br>
					Waraxe, dwarven 30GP 1d10<br>
					Warhammer 12GP 1d8<br>
					Whip 1GP 1d3<br><br>

					<b>Two Handed Weapons:</b><br>
					Chain, spiked 25GP 2d4<br>
					Falchion 75GP 1d6<br>
					Flail, epic 15GP 1d8<br>
					Glaive 8GP 1d8<br>
					Greataxe 20GP 1d10<br>
					Greatclub 5GP 1d8<br>
					Greatsword 50GP 2d6<br>
					Guisarme 9GP 2d4<br>
					Halberd 10GP 1d10<br>
					Lance 10GP 1d8<br>
					Longspear 5GP 1d8<br>
					Quarterstaff 1d6<br>
					Scythe 18GP 2d4<br>
					Spear 2GP 1d8 20ft<br><br>

					<b>Ranged Weapons:</b><br>
					Crossbow, hand 100GP 1d4 30ft<br>
					Crossbow, heavy 50GP 1d10 120ft<br>
					Crossbow, light 35GP 1d8 80ft<br>
					Dart 5SP 1d4 20ft<br>
					Javelin 1GP 1d6 30ft<br>
					Longbow 75GP 1d8 100ft<br>
					Net 20GP 10ft<br>
					Shortbow 30GP 1d6 60ft<br>
					Sling 1d4 50ft<br><br>

					<center><b>Armour and Shields:</b><br>
					For armour, the order is NAME, COST, AC BONUS<br><br></center>
					
					<b>Light Armour:</b><br><br>
					Padded 2GP +1<br>
					Leather 10GP +2<br>
					Studded Leather 25GP +3<br>
					Chain Shirt 100GP +4<br><br>

					<b>Medium Armour:</b><br>
					Hide 15GP +3<br>
					Scale Armour 50GP +4<br>
					Mail 150GP +5<br>
					Breastplate 200GP +5<br><br>

					<b>Heavy Armour:</b><br>
					Splint Armour 200GP +6<br>
					Banded Armour 250GP +6<br>
					Half-Plate 600GP +7<br>
					Full Plate 1500GP +8<br><br>

					<b>Shields:</b><br>
					Buckler 15GP +1<br>
					Shield, light wooden 3GP +1<br>
					Shield, light steel 9GP +1<br>
					Shield, heavy wooden 7GP +2<br>
					Shield, heavy steel 20GP +2<br>
					Shield, tower 30GP +4<br><br>

					<center><b>Adventuring Equipment:</b><br>
					For Equipment, the order is NAME, COST<br><br></center>
					
					Acid Flask 10GP<br>
					Antitoxin vial 50GP<br>
					Artisan's Tools 5GP<br>
					Backpack 2GP<br>
					Barrel 2GP<br>
					Basket 4SP<br>
					Bedroll 1SP<br>
					Bell 1GP<br>
					Blanket 5SP<br>
					Block and Tackle 5GP<br>
					Bottle, wine, empty 2GP<br>
					Bucket, empty 5SP<br>
					Caltrops 1GP<br>
					Candle 1CP<br>
					Canvas (sq. yd.) 1SP<br>
					Case, map or scroll 1GP<br>
					Chain (10 ft.) 30GP<br>
					Chalk, 1 piece 1CP<br>
					Chest, empty 2GP<br>
					Craftsman's tools 5GP<br>
					Crowbar 2GP<br>
					Disguise Kit 50GP<br>
					Firewood (1 day) 1CP<br>
					Fishhook 1SP<br>
					Fishing Net(25 sq. ft.) 4GP<br>
					Flask, empty 3CP<br>
					Flint and Steel 1GP<br>
					Grappling Hook 1GP<br>
					Hammer 5SP<br>
					Healer's Kit 50GP<br>
					Holy Symbol, wooden 1GP<br>
					Holy Symbol, silver 25GP<br>
					Holy Water, flask 25GP<br>
					Hourglass 25GP<br>
					Ink, vial 8GP<br>
					Inkpen 1SP<br>
					Jug, clay 3CP<br>
					Ladder, 10ft. 5CP<br>
					Lamp, common 1SP<br>
					Lantern, bullseye 12GP<br>
					Lantern, hooded 7GP<br>
					Lock S/A/G 20/40/80GP<br>
					Magnifying Glass 100GP<br>
					Manacles 15GP<br>
					Mirror, small steel 10GP<br>
					Mug/Tankard, clay 2CP<br>
					Musical Instrument 5GP<br>
					Oil, pint 1SP<br>
					Paper, sheet 4SP<br>
					Parchment, sheet 2SP<br>
					Pick, miner's 3GP<br>
					Pitcher, clay 2CP<br>
					Piton 1SP<br>
					Pole, 10ft. 2SP<br>
					Pot, iron 5SP<br>
					Pouch, belt 1GP<br>
					Ram, portable 10GP<br>
					Rations, trail (1day) 5SP<br>
					Rope, hempen(50ft.) 1GP<br>
					Rope, silk(50ft.) 10GP<br>
					Sack 1SP<br>
					Sealing Wax 1GP<br>
					Sewing Needle 5SP<br>
					Signal Whistle 8SP<br>
					Signet Ring 5GP<br>
					Sledge 1GP<br>
					Soap (per LB) 5SP<br>
					Spade or Shovel 2GP<br>
					Spell material pouch 5GP<br>
					Spellbook, blank 15GP<br>
					Spyglass 1000GP<br>
					Tent 10GP<br>
					Thieves' Tools 30GP<br>
					Torch 1CP<br>
					Vial, ink or potion 1GP<br>
					Waterskin 1GP<br>
					Whetstone 2CP<br><br>

					<b>For other gear, or nonstandard gear, consult your DM or await the next version of this equipment list.</b>
					</body>
				</html>"}
		
/obj/item/weapon/book/manual/rpg/spells
	name = "Gareth's Spell List"
	icon_state ="bookfireball"
	author = "Gareth Gygax" // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Gareth's Spell List"
	desc = "A book containing lists of Microlite20 spells."
	dat = {"<html>
				<head>
					<b><center><large>Microlite20 Spell List</large></center></b>
				</head>
				<body>
					<br><br>
					<b>The spell system:</b><br>
					Mages cast arcane spells and Clerics cast divine spells. They can cast any of their respective spells of a spell level equal or below 1/2 their class level, rounded up.<br>
					Casting a spell costs HP. The cost is 1 + double the level of the spell being cast. This loss cannot be healed normally, but is recovered after 8 hours rest.<br>
					One signature spell can be chosen per player level, at a spell level which the player can cast at that level. These spells cost 1 less HP to cast.<br><br>
					
					<b>0-Level arcane spells (cantrips)</b><br>
					
					Arcane Mark: Inscribes a permanent personal rune (visible or invisible).<br>
					Detect Magic: Detects spells and magic items within 60ft. for up to 1min./level or untill concentration ends.<br>
					Ghost Sound: Figment sounds for 1 round/level.<br>
					Light: Object shines like a torch for 10min./level.<br>
					Mage Hand: 5-pound telekinesis. Lasts until concentration ends.<br>
					Prestidigitation: performs minor tricks for 1 hour.<br>
					Read Magic: Read scrolls and spellbooks for 10min./level.<br><br>
					
					<b>1st-Level arcane spells</b><br>
					
					Feather Fall: Objects or creatures fall slowly for 1 round/level or until landing.<br>
					Floating Disk: Creates a disk of less than 3-ft + level diameter. lasts for 1 hour/level.<br>
					Mage Armour: Gives subject +4 armour bonus for 1 hour/level.<br>
					Magic Missile: 1d4+1 damage; +1 missile per two levels above 1st (max 5).<br>
					Sleep: Puts 4HD of creatures into magical slumber for 1min./level.<br>
					Shocking Grasp: Touch delivers 1d6/level electricity damage (max 5d6).<br><br>
					
					<b>2nd Level arcane spells</b><br>
					
					Acid Arrow: Ranged touch attack; 2d4 damage for 1 round + 1 round/3 levels.<br>
					Flaming Sphere: Creates rolling ball fo fire, 2d6 damage, lasts 1 round/level.<br>
					Invisibility: Subject is invisible for 1min./level or until it attacks.<br>
					Knock: Opens locked or magically sealed door.<br>
					Levitate: Subject moves up and down at your discression for 1min./level.<br>
					Spider Climb: Grants ability to walk on walls and ceilings for 10min./level.<br><br>
					
					<b>3rd Level arcane spells</b><br>
					
					Clairaudience/Clairvoyance: Hear or see at a distance for 1 min./level.<br>
					Dispell Magic: Cancels magical spells and effects.<br>
					Fireball: 1d6 damage per level, 20ft. radius.<br>
					Fly: Subject flies at speed of 60ft. for 1 min./level.<br>
					Lightning bolt: Electricity deals 1d6/level damage.<br>
					Vampiric touch: Touch deals 1d6/two levels damage; caster gains damage as HP which last for 1 hour.<br><br>
					
					<b>4th Level arcane spells</b><br>
					
					Animate Dead: Creates level X2 HD of undead skeletons or zombies.<br>
					Arcane Eye: Invisible floating eye moves 30 ft./round for 1 min./level.<br>
					Black Tentacles: Tentacles grapple all within 20 ft.<br>
					Dimension Door: Teleports you a short distance.<br>
					Polymorph: Gives one willing subject a new form for 1 min./level.<br>
					Stoneskin: 10 points damage reduction for 10 min./level.<br><br>
					
					<b>5th Level arcane spells</b><br>
					
					Cloudkill: Kills 3HD or less; 4-6HD save or die, 6+ HD take STR damage. lasts for 1min./level.<br>
					Feeblemind: Subject's mind score drops to 1.<br>
					Passwall: Creates passage through wood or stone wall for 1 hour/level.<br>
					Permanency: Makes certian spells permanent.<br>
					Teleport: Instantly transports you as far as 100 miles/level.<br><br>
					
					<b>6th Level arcane spells</b><br>
					
					Antimagic Field: Negates magic within 10 ft + 5/2 levels for 10min./level.<br>
					Chain Lightning: 1d6/level damage; bounces to new target for half damage until damage is less than 0.<br>
					Contingency: Sets trigger condition for another spell. Lasts for 1 day/level or until discharged.<br>
					Disintergrate: Destroys one creature (and it's equipment) or object.<br>
					Geas: Commands any creature, binding it to a specific task. Lasts for 1 day/level or until discharged.<br>
					True seeing: Lets you see all things as they really are for 1min./level.<br><br>
					
					<b>7th level arcane spells</b><br>
					
					Delayed Blast Fireball: 1d6/level fire damage; you can postpone blast for up to 5 rounds.<br>
					Etheral Jaunt: You become ethereal for 1 round/level.<br>
					Finger of Death: Subject must save vs instant death.<br>
					Plane Shift: As many as eight subjects travel to another plane.<br>
					Power Word Blind: Blinds creature with 200HP or less for 1d4+1 minutes.<br>
					Spell Turning: Reflect 1d4+6 spell leves back at caster for 10min./level or untill expended.<br><br>
					
					<b>8th Level arcane spells</b><br>
					
					Clone: Duplicate awakens when original dies.<br>
					Horrid Wilting: Deals 1d6/level damage within 30ft.<br>
					Incendiary Cloud: Cloud deals 4d6 fire damage/round for 1 round/level.<br>
					Irresistable Dance: Forces subject to dance for 1d4+1 rounds.<br>
					Power Word Stun: Stuns creature with 150HP or less for 2d4 rounds.<br>
					Trap the soul: Imprisons subject within gem.<br><br>
					
					<b>9th Level arcane spells</b><br>
					
					Astral Projection: Projects you and companions onto Astral Plane.<br>
					Etherealness: Travel to Ethereal Plane with companions for 1 min./level.<br>
					Gate: Connects two plains for travel or summoning. Open for 1 round/level.<br>
					Meteor Swarm: Four exploding spheres each deal 6d6 fire damage.<br>
					Power Word Kill: Kills one creature with 100HP or less.<br>
					Soul Bind: Traps newly dead soul to prevent resurrection.<br><br>
					
					<b>0 Level divine spells (orisons)</b><br>
					
					Create Water: Creates 2 gallons/level of pure water.<br>
					Guidance: +1 on one attack roll, save, or skill check. Lasts 1 min or untill discharged.<br>
					Light: As arcane verion.<br>
					Purify Food and Drink: Purifies 1cu. ft./level of food or water.<br>
					Resistance: Subject gains +1 on saving throws for 1 minute.<br>
					Virtue: Subject gains 1 temporary HP for 1 minute.<br><br>
					
					<b>1st Level divine spells</b><br>
					
					Bless: Allies gain +1 on attack rolls and communication + mind checks against fear for 1 min./level.<br>
					Bless Water: Makes holy water.<br>
					Cure Light Wounds: Cures 1d8 damage +1/level (max +5).<br>
					Divine Favor: You gain +1 per three levels on attack and damage rolls for 1 minute.<br>
					Magic stone: Three stones gain +1 on attack, deal 1d6+1 damage. lasts for one day or until discharged.<br>
					Shield of Faith: Aura grants +2 AC bonus for 1 min./level.<br><br>
					
					<b>2nd Level divine spells</b><br>
					
					Aid: +1 on attack rolls and saves against fear. 1d8 temporary HP +1/level (max +10).<br>
					Cure Moderate Wounds: Cures 2d8 damage +1/level (max +10).<br>
					Delay Poison: Stops poison from harming subject for 1 hour/level.<br>
					Gentle Repose: Preserves one corpse.<br>
					Remove Paralysis: Frees one or more creatures from paralysis or slow effect.<br>
					Restoration, lesser: Dispells magical ability penalty or repairs 1d4 ability damage.<br><br>
					
					<b>3rd Level divine spells</b><br>
					
					Create food and Water: Feeds three humans (or one horse)/level.<br>
					Cure Serious Wounds: Cures 3d8 damage +1/level (max +15).<br>
					Prayer: Allies get a +1 on every roll, enemies take a -1 penalty for 1 round/level.<br>
					Remove Disease: Cures all diseases affecting subject.<br>
					Searing Light: Ray deals 1d8/two levels damage, or 1d8/level against undead.<br>
					Speak with Dead: Corpse answers one question/two levels.<br><br>
					
					<b>4th Level divine spells</b><br>
					
					Cure Critical Wounds: Cures 4d8 damage +1/level (max +20).<br>
					Discern Lies: Reveals deliberate falsehoods for 1 round/level or until concentration ends.<br>
					Freedom of Movement: Subject moves normally dispite impediments for 10 min./level.<br>
					Neutralize Poison: Immunizes subject against poison for 10min./level, detoxifies venom on or in subject.<br>
					Restoration: Restores level and ability score drains.<br>
					Tongues: Speak any language for 10 min./level.<br><br>
					
					<b>5th Level divine spells</b><br>
					
					Cure Light Wounds, Mass: As Cure Light Wounds for 0 + level creatures.<br>
					Flame Strike: Smite foes with divine fire (1d6/level damage).<br>
					Raise dead: Restores life to subject who died as long as one day/level ago.<br>
					True seeing: As arcane version.<br><br>
					
					<b>6th Level divine spells</b><br>
					
					Banishment: Banishes 2HD/level of extraplanar creatures.<br>
					Cure Moderate Wounds, Mass: As Cure Moderate Wounds for 0 + level creatures.<br>
					Harm: Deals 10 points/level of damage to target.<br>
					Heal: Cures 10 points/level of damage, all diseases and mental conditions.<br>
					Heroes' feast: Food for one creature/level cures disease and grants +1 combat bonus for 12 hours.<br>
					Quest: Commands any creature, binding it to a specific task. Lasts for 1 day/level or until discharged.<br><br>
					
					<b>7th Level divine spells</b><br>
					
					Cure Serious Wounds, Mass: As Cure Serious Wounds for 0 + level creatures.<br>
					Destruction: Subject must save vs instant death and destruction of remains.<br>
					Ethereal Jaunt: As arcane version.<br>
					Regenerate: Subject's severed limbs grow back, cured 4d8 damage +1/level (max +35).<br>
					Restoration, Greater: As restoration, plus restores all levels and ability scores.<br>
					Resurrection: Fully restores a dead subject from a small portion of the corpse.<br><br>
					
					<b>8th Level divine spells</b><br>
					
					Antimagic Field: As arcane version.<br>
					Cure Critical Wounds, Mass: As Cure Critical Wounds for 0 + level creatures.<br>
					Dimensional Lock: Teleportation and interplanar travel locked for 1 day/level.<br>
					Discern Location: Reveals exact location of creature or object.<br>
					Fire Storm: Deals 1d6/level fire damage.<br>
					Holy Aura: +4 to AC +4 DR and SR25 against evil spells for 1 round/level.<br><br>
					
					<b>9th Level divine spells</b><br>
					
					Astral Projection: As arcane version.<br>
					Etherealness: As arcane version.<br>
					Gate: As arcane version.<br>
					Heal, Mass: As heal for 0 + level subjects.<br>
					Implosion: One creature/round must save vs instant gory death for 4 rounds or until concentration ends.<br>
					Soul Bind: As arcane verison.
				</body>
			</html>"}

/obj/item/weapon/book/manual/rpg/packs
	name = "Microlite20 - Fast Packs"
	icon_state ="bookCloning"
	author = "Silas Colt" // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Microlite20 - Fast Packs"
	desc = "A fan-made guide with premade equipment packs. Read this to get started with your campaign quickly."
	dat = {"<html>
				<head>
					<b><center><large>Microlite20 - Fast Packs</large></center></b>
				</head>
				<body>
					<br><br>
					Back in the day, there were standard equipment packages, pre-compiled and pre-calculated, to help new players get started quickly.<br>
					This document is inspired by those lists and provides a way for a player to quickly equip his or her PC or a GM to equip an NPC or Hireling on the fly. Additionally, these optional kits can be used to give a starting point from which to customize new characters.<br><br><hr><br>
					
					50 GP each<br><br>
					
					<b>Pack A</b><br><br>
					
					Backpack, Belt Pouch, Bedroll, Lantern (hooded), 10 Oil Flasks, Flint & Steel, Shovel, 2 sets of Caltrops, Signal Whistle, Waterskin, Iron Rations (4 days)<br><br>
					
					<b>Pack B</b><br><br>
					
					Backpack, Belt Pouch, Bedroll, 10 Torches, 4 Oil Flasks, Flint & Steel, 10 pieces of chalk, 10' Pole, Mirror, Crowbar, Waterskin, Iron Rations (4 days)<br><br>
					
					<b>Pack C</b><br><br>
					
					Backpack, Belt Pouch, Bedroll, Tent, 10 Torches, 5 Oil Flasks, Flint & Steel, 50. Rope, Grappling Hook, 10' Pole, Waterskin,Iron Rations (4 days)<br><br>
					
					<b>Finally, add the following, based on your Class:</b><br><br>
					
					Cleric: Silver Holy symbol & 5 Gold Pieces<br><br>
					
					Fighter: Vial of Holy Water & 5 Gold Pieces<br><br>
					
					Mage: Spellbook & 2 Spell Pouches & 5 Gold Pieces<br><br>
					
					Rogue: Thieves Tools
				</body>
			</html>"}
			
/obj/item/weapon/book/manual/dwarf
	name = "Slaves to Armok: God of Blood Chapter II: DF"
	icon_state ="bookDwarf"
	author = "Urist" // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Slaves to Armok: God of Blood Chapter II: DF"
	dat = {"<html>
				</body>
				It has been months since we left the safety of our mountainhome, but we have finally found a place to settle, a nearby river seems to offer plenty of food and the forest has wildlife, some of us are disturbed by the fact that it rains blood at times but i dont think that matters, anyways, enough writing, it's time to strike the earth!
				</body>
			</html>"}
	
/obj/item/weapon/book/manual/engineering_particle_accelerator
	name = "Particle Accelerator User's Guide"
	icon_state ="bookParticleAccelerator"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Particle Accelerator User's Guide"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h3>Experienced user's guide</h3>

				<h4>Setting up</h4>

				<ol>
					<li><b>Wrench</b> all pieces to the floor</li>
					<li>Add <b>wires</b> to all the pieces</li>
					<li>Close all the panels with your <b>screwdriver</b></li>
				</ol>

				<h4>Use</h4>

				<ol>
					<li>Open the control panel</li>
					<li>Set the speed to 2</li>
					<li>Start firing at the singularity generator</li>
					<li><font color='red'><b>When the singularity reaches a large enough size so it starts moving on it's own set the speed down to 0, but don't shut it off</b></font></li>
					<li>Remember to wear a radiation suit when working with this machine... we did tell you that at the start, right?</li>
				</ol>

				</body>
				</html>"}


/obj/item/weapon/book/manual/engineering_singularity_safety
	name = "Singularity Safety in Special Circumstances"
	icon_state ="bookEngineeringSingularitySafety"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Singularity Safety in Special Circumstances"
//big pile of shit below.

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>
				<h3>Singularity Safety in Special Circumstances</h3>

				<h4>Power outage</h4>

				A power problem has made the entire station lose power? Could be station-wide wiring problems or syndicate power sinks. In any case follow these steps:
				<p>
				<b>Step one:</b> <b><font color='red'>PANIC!</font></b><br>
				<b>Step two:</b> Get your ass over to engineering! <b>QUICKLY!!!</b><br>
				<b>Step three:</b> Make sure the SMES is still powering the emitters, if not, setup the generator in secure storage and disconnect the emitters from the SMES.<br>
				<b>Step four:</b> Next, head over to the APC and swipe it with your <b>ID card</b> - if it doesn't unlock, continue with step 15.<br>
				<b>Step five:</b> Open the console and disengage the cover lock.<br>
				<b>Step six:</b> Pry open the APC with a <b>Crowbar.</b><br>
				<b>Step seven:</b> Take out the empty <b>power cell.</b><br>
				<b>Step eight:</b> Put in the new, <b>full power cell</b> - if you don't have one, continue with step 15.<br>
				<b>Step nine:</b> Quickly put on a <b>Radiation suit.</b><br>
				<b>Step ten:</b> Check if the <b>singularity field generators</b> withstood the down-time - if they didn't, continue with step 15.<br>
				<b>Step eleven:</b> Since disaster was averted you now have to ensure it doesn't repeat. If it was a powersink which caused it and if the engineering apc is wired to the same powernet, which the powersink is on, you have to remove the piece of wire which links the apc to the powernet. If it wasn't a powersink which caused it, then skip to step 14.<br>
				<b>Step twelve:</b> Grab your crowbar and pry away the tile closest to the APC.<br>
				<b>Step thirteen:</b> Use the wirecutters to cut the wire which is conecting the grid to the terminal. <br>
				<b>Step fourteen:</b> Go to the bar and tell the guys how you saved them all. Stop reading this guide here.<br>
				<b>Step fifteen:</b> <b>GET THE FUCK OUT OF THERE!!!</b><br>
				</p>

				<h4>Shields get damaged</h4>

				Step one: <b>GET THE FUCK OUT OF THERE!!! FORGET THE WOMEN AND CHILDREN, SAVE YOURSELF!!!</b><br>
				</body>
				</html>
				"}

/obj/item/weapon/book/manual/hydroponics_pod_people
	name = "The Human Harvest - From seed to market"
	icon_state ="bookHydroponicsPodPeople"
	author = "Farmer John"
	title = "The Human Harvest - From seed to market"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>
				<h3>Growing Humans</h3>

				Why would you want to grow humans? Well I'm expecting most readers to be in the slave trade, but a few might actually
				want to revive fallen comrades. Growing pod people is easy, but prone to disaster.
				<p>
				<ol>
				<li>Find a dead person who is in need of cloning. </li>
				<li>Take a blood sample with a syringe. </li>
				<li>Inject a seed pack with the blood sample. </li>
				<li>Plant the seeds. </li>
				<li>Tend to the plants water and nutrition levels until it is time to harvest the cloned human.</li>
				</ol>
				<p>
				It really is that easy! Good luck!

				</body>
				</html>
				"}

/obj/item/weapon/book/manual/medical_cloning
	name = "Cloning techniques of the 26th century"
	icon_state ="bookCloning"
	author = "Medical Journal, volume 3"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Cloning techniques of the 26th century"
//big pile of shit below.

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<H3>How to Clone People</H3>
				So there’s 50 dead people lying on the floor, chairs are spinning like no tomorrow and you haven’t the foggiest idea of what to do? Not to worry! This guide is intended to teach you how to clone people and how to do it right, in a simple step-by-step process! If at any point of the guide you have a mental meltdown, genetics probably isn’t for you and you should get a job-change as soon as possible before you’re sued for malpractice.

				<ol>
					<li><a href='#1'>Acquire body</a></li>
					<li><a href='#2'>Strip body</a></li>
					<li><a href='#3'>Put body in cloning machine</a></li>
					<li><a href='#4'>Scan body</a></li>
					<li><a href='#5'>Clone body</a></li>
					<li><a href='#6'>Get clean Structurel Enzymes for the body</a></li>
					<li><a href='#7'>Put body in morgue</a></li>
					<li><a href='#8'>Await cloned body</a></li>
					<li><a href='#9'>Use the clean SW injector</a></li>
					<li><a href='#10'>Give person clothes back</a></li>
					<li><a href='#11'>Send person on their way</a></li>
				</ol>

				<a name='1'><H4>Step 1: Acquire body</H4>
				This is pretty much vital for the process because without a body, you cannot clone it. Usually, bodies will be brought to you, so you do not need to worry so much about this step. If you already have a body, great! Move on to the next step.

				<a name='2'><H4>Step 2: Strip body</H4>
				The cloning machine does not like abiotic items. What this means is you can’t clone anyone if they’re wearing clothes, so take all of it off. If it’s just one person, it’s courteous to put their possessions in the closet. If you have about seven people awaiting cloning, just leave the piles where they are, but don’t mix them around and for God’s sake don’t let the Clown in to steal them.

				<a name='3'><H4>Step 3: Put body in cloning machine</H4>
				Grab the body and then put it inside the DNA modifier. If you cannot do this, then you messed up at Step 2. Go back and check you took EVERYTHING off - a commonly missed item is their headset.

				<a name='4'><H4>Step 4: Scan body</H4>
				Go onto the computer and scan the body by pressing ‘Scan - <Subject Name Here>’. If you’re successful, they will be added to the records (note that this can be done at any time, even with living people, so that they can be cloned without a body in the event that they are lying dead on port solars and didn‘t turn on their suit sensors)! If not, and it says “Error: Mental interface failure.”, then they have left their bodily confines and are one with the spirits. If this happens, just shout at them to get back in their body, click ‘Refresh‘ and try scanning them again. If there’s no success, threaten them with gibbing. Still no success? Skip over to Step 7 and don‘t continue after it, as you have an unresponsive body and it cannot be cloned. If you got “Error: Unable to locate valid genetic data.“, you are trying to clone a monkey - start over.

				<a name='5'><H4>Step 5: Clone body</H4>
				Now that the body has a record, click ’View Records’, click the subject’s name, and then click ‘Clone’ to start the cloning process. Congratulations! You’re halfway there. Remember not to ‘Eject’ the cloning pod as this will kill the developing clone and you’ll have to start the process again.

				<a name='6'><H4>Step 6: Get clean SEs for body</H4>
				Cloning is a finicky and unreliable process. Whilst it will most certainly bring someone back from the dead, they can have any number of nasty disabilities given to them during the cloning process! For this reason, you need to prepare a clean, defect-free Structural Enzyme (SE) injection for when they’re done. If you’re a competent Geneticist, you will already have one ready on your working computer. If, for any reason, you do not, then eject the body from the DNA modifier (NOT THE CLONING POD) and take it next door to the Genetics research room. Put the body in one of those DNA modifiers and then go onto the console. Go into View/Edit/Transfer Buffer, find an open slot and click “SE“ to save it. Then click ‘Injector’ to get the SEs in syringe form. Put this in your pocket or something for when the body is done.

				<a name='7'><H4>Step 7: Put body in morgue</H4>
				Now that the cloning process has been initiated and you have some clean Structural Enzymes, you no longer need the body! Drag it to the morgue and tell the Chef over the radio that they have some fresh meat waiting for them in there. To put a body in a morgue bed, simply open the tray, grab the body, put it on the open tray, then close the tray again. Use one of the nearby pens to label the bed “CHEF MEAT” in order to avoid confusion.

				<a name='8'><H4>Step 8: Await cloned body</H4>
				Now go back to the lab and wait for your patient to be cloned. It won’t be long now, I promise.

				<a name='9'><H4>Step 9: Use the clean SE injector on person</H4>
				Has your body been cloned yet? Great! As soon as the guy pops out, grab your injector and jab it in them. Once you’ve injected them, they now have clean Structural Enzymes and their defects, if any, will disappear in a short while.

				<a name='10'><H4>Step 10: Give person clothes back</H4>
				Obviously the person will be naked after they have been cloned. Provided you weren’t an irresponsible little shit, you should have protected their possessions from thieves and should be able to give them back to the patient. No matter how cruel you are, it’s simply against protocol to force your patients to walk outside naked.

				<a name='11'><H4>Step 11: Send person on their way</H4>
				Give the patient one last check-over - make sure they don’t still have any defects and that they have all their possessions. Ask them how they died, if they know, so that you can report any foul play over the radio. Once you’re done, your patient is ready to go back to work! Chances are they do not have Medbay access, so you should let them out of Genetics and the Medbay main entrance.

				<p>If you’ve gotten this far, congratulations! You have mastered the art of cloning. Now, the real problem is how to resurrect yourself after that traitor had his way with you for cloning his target.



				</body>
				</html>
				"}


/obj/item/weapon/book/manual/ripley_build_and_repair
	name = "APLU \"Ripley\" Construction and Operation Manual"
	icon_state ="book"
	author = "Weyland-Yutani Corp"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "APLU \"Ripley\" Construction and Operation Manual"
//big pile of shit below.

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>
				<center>
				<b style='font-size: 12px;'>Weyland-Yutani - Building Better Worlds</b>
				<h1>Autonomous Power Loader Unit \"Ripley\"</h1>
				</center>
				<h2>Specifications:</h2>
				<ul>
				<li><b>Class:</b> Autonomous Power Loader</li>
				<li><b>Scope:</b> Logistics and Construction</li>
				<li><b>Weight:</b> 820kg (without operator and with empty cargo compartment)</li>
				<li><b>Height:</b> 2.5m</li>
				<li><b>Width:</b> 1.8m</li>
				<li><b>Top speed:</b> 5km/hour</li>
				<li><b>Operation in vacuum/hostile environment:</b> Possible</b>
				<li><b>Airtank Volume:</b> 500liters</li>
				<li><b>Devices:</b>
					<ul>
					<li>Hydraulic Clamp</li>
					<li>High-speed Drill</li>
					</ul>
				</li>
				<li><b>Propulsion Device:</b> Powercell-powered electro-hydraulic system.</li>
				<li><b>Powercell capacity:</b> Varies.</li>
				</ul>

				<h2>Construction:</h2>
				<ol>
				<li>Connect all exosuit parts to the chassis frame</li>
				<li>Connect all hydraulic fittings and tighten them up with a wrench</li>
				<li>Adjust the servohydraulics with a screwdriver</li>
				<li>Wire the chassis. (Cable is not included.)</li>
				<li>Use the wirecutters to remove the excess cable if needed.</li>
				<li>Install the central control module (Not included. Use supplied datadisk to create one).</li>
				<li>Secure the mainboard with a screwdriver.</li>
				<li>Install the peripherals control module (Not included. Use supplied datadisk to create one).</li>
				<li>Secure the peripherals control module with a screwdriver</li>
				<li>Install the internal armor plating (Not included due to Nanotrasen regulations. Can be made using 5 metal sheets.)</li>
				<li>Secure the internal armor plating with a wrench</li>
				<li>Weld the internal armor plating to the chassis</li>
				<li>Install the external reinforced armor plating (Not included due to Nanotrasen regulations. Can be made using 5 reinforced metal sheets.)</li>
				<li>Secure the external reinforced armor plating with a wrench</li>
				<li>Weld the external reinforced armor plating to the chassis</li>
				<li></li>
				<li>Additional Information:</li>
				<li>The firefighting variation is made in a similar fashion.</li>
				<li>A firesuit must be connected to the Firefighter chassis for heat shielding.</li>
				<li>Internal armor is plasteel for additional strength.</li>
				<li>External armor must be installed in 2 parts, totaling 10 sheets.</li>
				<li>Completed mech is more resiliant against fire, and is a bit more durable overall</li>
				<li>Nanotrasen is determined to the safety of its <s>investments</s> employees.</li>
				</ol>
				</body>
				</html>

				<h2>Operation</h2>
				Coming soon...
			"}

/obj/item/weapon/book/manual/experimentor
	name = "Mentoring your Experiments"
	icon_state = "rdbook"
	author = "Dr. H.P. Kritz"
	title = "Mentoring your Experiments"
	dat = {"<html>
		<head>
		<style>
		h1 {font-size: 18px; margin: 15px 0px 5px;}
		h2 {font-size: 15px; margin: 15px 0px 5px;}
		li {margin: 2px 0px 2px 15px;}
		ul {list-style: none; margin: 5px; padding: 0px;}
		ol {margin: 5px; padding: 0px 15px;}
		</style>
		</head>
		<body>
		<h1>THE E.X.P.E.R.I-MENTOR</h1>
		The Enhanced Xenobiological Period Extraction (and) Restoration Instructor is a machine designed to discover the secrets behind every item in existence.
		With advanced technology, it can process 99.95% of items, and discover their uses and secrets.
		The E.X.P.E.R.I-MENTOR is a Research apparatus that takes items, and through a process of elimination, it allows you to deduce new technological designs from them.
		Due to the volatile nature of the E.X.P.E.R.I-MENTOR, there is a slight chance for malfunction, potentially causing irreparable damage to you or your environment.
		However, upgrading the apparatus has proven to decrease the chances of undesirable, potentially life-threatening outcomes.
		Please note that the E.X.P.E.R.I-MENTOR uses a state-of-the-art random generator, which has a larger entropy than the observable universe,
		therefore it can generate wildly different results each day, therefore it is highly suggested to re-scan objects of interests frequently (e.g. each shift).

		<h2>BASIC PROCESS</h2>
		The usage of the E.X.P.E.R.I-MENTOR is quite simple:
		<ol>
			<li>Find an item with a technological background</li>
			<li>Insert the item into the E.X.P.E.R.I-MENTOR</li>
			<li>Cycle through each processing method of the device.</li>
			<li>Stand back, even in case of a successful experiment, as the machine might produce undesired behaviour.</li>
		</ol>

		<h2>ADVANCED USAGE</h2>
		The E.X.P.E.R.I-MENTOR has a variety of uses, beyond menial research work. The different results can be used to combat localised events, or even to get special items.

		The E.X.P.E.R.I-MENTOR's OBLITERATE function has the added use of transferring the destroyed item's material into a linked lathe.

		The IRRADIATE function can be used to transform items into other items, resulting in potential upgrades (or downgrades).

		Users should remember to always wear appropriate protection when using the machine, because malfunction can occur at any moment!

		<h1>EVENTS</h1>
		<h2>GLOBAL (happens at any time):</h2>
			<ol>
			<li>DETECTION MALFUNCTION - The machine's onboard sensors have malfunctioned, causing it to redefine the item's experiment type.
			Produces the message: The E.X.P.E.R.I-MENTOR's onboard detection system has malfunctioned!</li>

			<li>IANIZATION - The machine's onboard corgi-filter has malfunctioned, causing it to produce a corgi from.. somewhere.
			Produces the message: The E.X.P.E.R.I-MENTOR melts the banana, ian-izing the air around it!</li>

			<li>RUNTIME ERROR - The machine's onboard C4T-P processor has encountered a critical error, causing it to produce a cat from.. somewhere.
			Produces the message: The E.X.P.E.R.I-MENTOR encounters a run-time error!</li>

			<li>B100DG0D.EXE - The machine has encountered an unknown subroutine, which has been injected into it's runtime. It upgrades the held item!
			Produces the message: The E.X.P.E.R.I-MENTOR improves the banana, drawing the life essence of those nearby!</li>

			<li>POWERSINK - The machine's PSU has tripped the charging mechanism! It consumes massive amounts of power!
			Produces the message: The E.X.P.E.R.I-MENTOR begins to smoke and hiss, shaking violently!</li>
			</ol>
		<h2>FAIL:</h2>
			This event is produced when the item mismatches the selected experiment.
			Produces a random message similar to: "the Banana rumbles, and shakes, the experiment was a failure!"

		<h2>POKE:</h2>
			<ol>
			<li>WILD ARMS - The machine's gryoscopic processors malfunction, causing it to lash out at nearby people with it's arms.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions and destroys the banana, lashing it's arms out at nearby people!</li>

			<li>MISTYPE - The machine's interface has been garbled, and it switches to OBLITERATE.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions!</li>

			<li>THROW - The machine's spatial recognition device has shifted several meters across the room, causing it to try and repostion the item there.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, throwing the banana!</li>
			</ol>
		<h2>IRRADIATE:</h2>
			<ol>
			<li>RADIATION LEAK - The machine's shield has failed, resulting in a toxic radiation leak.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, melting the banana and leaking radiation!</li>

			<li>RADIATION DUMP - The machine's recycling and containment functions have failed, resulting in a dump of toxic waste around it
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, spewing toxic waste!</li>

			<li>MUTATION - The machine's radio-isotope level meter has malfunctioned, causing it over-irradiate the item, making it transform.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, transforming the banana!</li>
			</ol>
		<h2>GAS:</h2>
			<ol>
			<li>TOXIN LEAK - The machine's filtering and vent systems have failed, resulting in a cloud of toxic gas being expelled.
			Produces the message: The E.X.P.E.R.I-MENTOR destroys the banana, leaking dangerous gas!</li>

			<li>GAS LEAK - The machine's vent systems have failed, resulting in a cloud of harmless, but obscuring gas.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, spewing harmless gas!</li>

			<li>ELECTROMAGNETIC IONS - The machine's electrolytic scanners have failed, causing a dangerous Electromagnetic reaction.
			Produces the message: The E.X.P.E.R.I-MENTOR melts the banana, ionizing the air around it!</li>
			</ol>
		<h2>HEAT:</h2>
			<ol>
			<li>TOASTER - The machine's heating coils have come into contact with the machine's gas storage, causing a large, sudden blast of flame.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, melting the banana and releasing a burst of flame!</li>

			<li>SAUNA - The machine's vent loop has sprung a leak, resulting in a large amount of superheated air being dumped around it.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, melting the banana and leaking hot air!</li>

			<li>EMERGENCY VENT - The machine's temperature gauge has malfunctioned, resulting in it attempting to cool the area around it, but instead, dumping a cloud of steam.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, activating it's emergency coolant systems!</li>
			</ol>
		<h2>COLD:</h2>
			<ol>
			<li>FREEZER - The machine's cooling loop has sprung a leak, resulting in a cloud of super-cooled liquid being blasted into the air.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, shattering the banana and releasing a dangerous cloud of coolant!</li>

			<li>FRIDGE - The machine's cooling loop has been exposed to the outside air, resulting in a large decrease in temperature.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, shattering the banana and leaking cold air!</li>

			<li>SNOWSTORM - The machine's cooling loop has come into contact with the heating coils, resulting in a sudden blast of cool air.
			Produces the message: The E.X.P.E.R.I-MENTOR malfunctions, releasing a flurry of chilly air as the banana pops out!</li>
			</ol>
		<h2>OBLITERATE:</h2>
			<ol>
			<li>IMPLOSION - The machine's pressure leveller has malfunctioned, causing it to pierce the space-time momentarily, making everything in the area fly towards it.
			Produces the message: The E.X.P.E.R.I-MENTOR's crusher goes way too many levels too high, crushing right through space-time!</li>

			<li>DISTORTION - The machine's pressure leveller has completely disabled, resulting in a momentary space-time distortion, causing everything to fly around.
			Produces the message: The E.X.P.E.R.I-MENTOR's crusher goes one level too high, crushing right into space-time!</li>
			</ol>
		</body>
	</html>
	"}

/obj/item/weapon/book/manual/research_and_development
	name = "Research and Development 101"
	icon_state = "rdbook"
	author = "Dr. L. Ight"
	title = "Research and Development 101"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h1>Science For Dummies</h1>
				So you want to further SCIENCE? Good man/woman/thing! However, SCIENCE is a complicated process even though it's quite easy. For the most part, it's a three step process:
				<ol>
					<li> 1) Deconstruct items in the Destructive Analyzer to advance technology or improve the design.</li>
					<li> 2) Build unlocked designs in the Protolathe and Circuit Imprinter</li>
					<li> 3) Repeat!</li>
				</ol>

				Those are the basic steps to furthing science. What do you do science with, however? Well, you have four major tools: R&D Console, the Destructive Analyzer, the Protolathe, and the Circuit Imprinter.

				<h2>The R&D Console</h2>
				The R&D console is the cornerstone of any research lab. It is the central system from which the Destructive Analyzer, Protolathe, and Circuit Imprinter (your R&D systems) are controled. More on those systems in their own sections. On its own, the R&D console acts as a database for all your technological gains and new devices you discover. So long as the R&D console remains intact, you'll retain all that SCIENCE you've discovered. Protect it though, because if it gets damaged, you'll lose your data! In addition to this important purpose, the R&D console has a disk menu that lets you transfer data from the database onto disk or from the disk into the database. It also has a settings menu that lets you re-sync with nearby R&D devices (if they've become disconnected), lock the console from the unworthy, upload the data to all other R&D consoles in the network (all R&D consoles are networked by default), connect/disconnect from the network, and purge all data from the database.
				<b>NOTE:</b> The technology list screen, circuit imprinter, and protolathe menus are accessible by non-scientists. This is intended to allow 'public' systems for the plebians to utilize some new devices.

				<h2>Destructive Analyzer</h2>
				This is the source of all technology. Whenever you put a handheld object in it, it analyzes it and determines what sort of technological advancements you can discover from it. If the technology of the object is equal or higher then your current knowledge, you can destroy the object to further those sciences. Some devices (notably, some devices made from the protolathe and circuit imprinter) aren't 100% reliable when you first discover them. If these devices break down, you can put them into the Destructive Analyzer and improve their reliability rather then futher science. If their reliability is high enough ,it'll also advance their related technologies.

				<h2>Circuit Imprinter</h2>
				This machine, along with the Protolathe, is used to actually produce new devices. The Circuit Imprinter takes glass and various chemicals (depends on the design) to produce new circuit boards to build new machines or computers. It can even be used to print AI modules.

				<h2>Protolathe</h2>
				This machine is an advanced form of the Autolathe that produce non-circuit designs. Unlike the Autolathe, it can use processed metal, glass, solid plasma, silver, gold, and diamonds along with a variety of chemicals to produce devices. The downside is that, again, not all devices you make are 100% reliable when you first discover them.

				<h1>Reliability and You</h1>
				As it has been stated, many devices when they're first discovered do not have a 100% reliablity when you first discover them. Instead, the reliablity of the device is dependent upon a base reliability value, whatever improvements to the design you've discovered through the Destructive Analyzer, and any advancements you've made with the device's source technologies. To be able to improve the reliability of a device, you have to use the device until it breaks beyond repair. Once that happens, you can analyze it in a Destructive Analyzer. Once the device reachs a certain minimum reliability, you'll gain tech advancements from it.

				<h1>Building a Better Machine</h1>
				Many machines produces from circuit boards and inserted into a machine frame require a variety of parts to construct. These are parts like capacitors, batteries, matter bins, and so forth. As your knowledge of science improves, more advanced versions are unlocked. If you use these parts when constructing something, its attributes may be improved. For example, if you use an advanced matter bin when constructing an autolathe (rather then a regular one), it'll hold more materials. Experiment around with stock parts of various qualities to see how they affect the end results! Be warned, however: Tier 3 and higher stock parts don't have 100% reliability and their low reliability may affect the reliability of the end machine.
				</body>
				</html>
			"}


/obj/item/weapon/book/manual/robotics_cyborgs
	name = "Cyborgs for Dummies"
	icon_state = "borgbook"
	author = "XISC"
	title = "Cyborgs for Dummies"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
        h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h1>Cyborgs for Dummies</h1>

				<h2>Chapters</h2>

				<ol>
					<li><a href="#Equipment">Cyborg Related Equipment</a></li>
					<li><a href="#Modules">Cyborg Modules</a></li>
					<li><a href="#Construction">Cyborg Construction</a></li>
					<li><a href="#Deconstruction">Cyborg Deconstruction</a></li>
					<li><a href="#Maintenance">Cyborg Maintenance</a></li>
					<li><a href="#Repairs">Cyborg Repairs</a></li>
					<li><a href="#Emergency">In Case of Emergency</a></li>
				</ol>


				<h2><a name="Equipment">Cyborg Related Equipment</h2>

				<h3>Exosuit Fabricator</h3>
				The Exosuit Fabricator is the most important piece of equipment related to cyborgs. It allows the construction of the core cyborg parts. Without these machines, cyborgs can not be built. It seems that they may also benefit from advanced research techniques.

				<h3>Cyborg Recharging Station</h3>
				This useful piece of equipment will suck power out of the power systems to charge a cyborg's power cell back up to full charge.

				<h3>Robotics Control Console</h3>
				This useful piece of equipment can be used to immobolize or destroy a cyborg. A word of warning: Cyborgs are expensive pieces of equipment, do not destroy them without good reason, or Nanotrasen may see to it that it never happens again.


				<h2><a name="Modules">Cyborg Modules</h2>
				When a cyborg is created it picks out of an array of modules to designate its purpose. There are 6 different cyborg modules.

				<h3>Standard Cyborg</h3>
				The standard cyborg module is a multi-purpose cyborg. It is equipped with various modules, allowing it to do basic tasks.<br>

				<h3>Engineering Cyborg</h3>
				The Engineering cyborg module comes equipped with various engineering-related tools to help with engineering-related tasks.<br>

				<h3>Mining Cyborg</h3>
				The Mining Cyborg module comes equipped with the latest in mining equipment. They are efficient at mining due to no need for oxygen, but their power cells limit their time in the mines.

				<h3>Security Cyborg</h3>
				The Security Cyborg module is equipped with effective security measures used to apprehend and arrest criminals without harming them a bit.

				<h3>Janitor Cyborg</h3>
				The Janitor Cyborg module is equipped with various cleaning-facilitating devices.

				<h3>Service Cyborg</h3>
				The service cyborg module comes ready to serve your human needs. It includes various entertainment and refreshment devices. Occasionally some service cyborgs may have been referred to as "Bros"

				<h2><a name="Construction">Cyborg Construction</h2>
				Cyborg construction is a rather easy process, requiring a decent amount of metal and a few other supplies.<br>The required materials to make a cyborg are:
				<ul>
				  <li>Metal</li>
				  <li>Two Flashes</li>
				  <li>One Power Cell (Preferrably rated to 15000w)</li>
				  <li>Some electrical wires</li>
				  <li>One Human Brain</li>
				  <li>One Man-Machine Interface</li>
				</ul>
				Once you have acquired the materials, you can start on construction of your cyborg.<br>To construct a cyborg, follow the steps below:
				<ol>
				  <li>Start the Exosuit Fabricators constructing all of the cyborg parts</li>
				  <li>While the parts are being constructed, take your human brain, and place it inside the Man-Machine Interface</li>
				  <li>Once you have a Robot Head, place your two flashes inside the eye sockets</li>
				  <li>Once you have your Robot Chest, wire the Robot chest, then insert the power cell</li>
				  <li>Attach all of the Robot parts to the Robot frame</li>
				  <li>Insert the Man-Machine Interface (With the Brain inside) Into the Robot Body</li>
				  <li>Congratulations! You have a new cyborg!</li>
				</ol>

				<h2><a name="Deconstruction">Cyborg Deconstruction</h2>
				If you want to deconstruct a cyborg, say to remove its MMI without <a href="#Emergency">blowing the Cyborg to pieces</a>, they come apart very quickly, <b>and</b> very safely, in a few simple steps.
				<ul>
				  <li>Crowbar</li>
				  <li>Wrench</li>
				  Optional:
				  <li>Screwdriver</li>
				  <li>Wirecutters</li>
				</ul>
				<ol>
				  <li>Begin by unlocking the Cyborg's access panel using your ID</li>
				  <li>Use your crowbar to open the Cyborg's access panel</li>
				  <li>Using your bare hands, remove the power cell from the Cyborg</li>
				  <li>Lockdown the Cyborg to disengage safety protocols</li>
				  <ol>
				    Option 1: Robotics console
				    <li>Use the Robotics console in the RD's office</li>
				    <li>Find the entry for your Cyborg</li>
				    <li>Press the Lockdown button on the Robotics console</li>
				  </ol>
				  <ol>
				    Option 2: Lockdown wire
				    <li>Use your screwdriver to expose the Cyborg's wiring</li>
				    <li>Use your wirecutters to start cutting all of the wires until the lockdown light turns off, cutting all of the wires irregardless of the lockdown light works as well</li>
				  </ol>
				  <li>Use your wrench to unfasten the Cyborg's bolts, the Cyborg will then fall apart onto the floor, the MMI will be there as well</li>
				</ol>

				<h2><a name="Maintenance">Cyborg Maintenance</h2>
				Occasionally Cyborgs may require maintenance of a couple types, this could include replacing a power cell with a charged one, or possibly maintaining the cyborg's internal wiring.

				<h3>Replacing a Power Cell</h3>
				Replacing a Power cell is a common type of maintenance for cyborgs. It usually involves replacing the cell with a fully charged one, or upgrading the cell with a larger capacity cell.<br>The steps to replace a cell are follows:
				<ol>
				  <li>Unlock the Cyborg's Interface by swiping your ID on it</li>
				  <li>Open the Cyborg's outer panel using a crowbar</li>
				  <li>Remove the old power cell</li>
				  <li>Insert the new power cell</li>
				  <li>Close the Cyborg's outer panel using a crowbar</li>
				  <li>Lock the Cyborg's Interface by swiping your ID on it, this will prevent non-qualified personnel from attempting to remove the power cell</li>
				</ol>

				<h3>Exposing the Internal Wiring</h3>
				Exposing the internal wiring of a cyborg is fairly easy to do, and is mainly used for cyborg repairs.<br>You can easily expose the internal wiring by following the steps below:
				<ol>
				  <li>Follow Steps 1 - 3 of "Replacing a Cyborg's Power Cell"</li>
				  <li>Open the cyborg's internal wiring panel by using a screwdriver to unsecure the panel</li>
			  </ol>
			  To re-seal the cyborg's internal wiring:
			  <ol>
			    <li>Use a screwdriver to secure the cyborg's internal panel</li>
			    <li>Follow steps 4 - 6 of "Replacing a Cyborg's Power Cell" to close up the cyborg</li>
			  </ol>

			  <h2><a name="Repairs">Cyborg Repairs</h2>
			  Occasionally a Cyborg may become damaged. This could be in the form of impact damage from a heavy or fast-travelling object, or it could be heat damage from high temperatures, or even lasers or Electromagnetic Pulses (EMPs).

			  <h3>Dents</h3>
			  If a cyborg becomes damaged due to impact from heavy or fast-moving objects, it will become dented. Sure, a dent may not seem like much, but it can compromise the structural integrity of the cyborg, possibly causing a critical failure.
			  Dents in a cyborg's frame are rather easy to repair, all you need is to apply a welding tool to the dented area, and the high-tech cyborg frame will repair the dent under the heat of the welder.

        <h3>Excessive Heat Damage</h3>
        If a cyborg becomes damaged due to excessive heat, it is likely that the internal wires will have been damaged. You must replace those wires to ensure that the cyborg remains functioning properly.<br>To replace the internal wiring follow the steps below:
        <ol>
          <li>Unlock the Cyborg's Interface by swiping your ID</li>
          <li>Open the Cyborg's External Panel using a crowbar</li>
          <li>Remove the Cyborg's Power Cell</li>
          <li>Using a screwdriver, expose the internal wiring or the Cyborg</li>
          <li>Replace the damaged wires inside the cyborg</li>
          <li>Secure the internal wiring cover using a screwdriver</li>
          <li>Insert the Cyborg's Power Cell</li>
          <li>Close the Cyborg's External Panel using a crowbar</li>
          <li>Lock the Cyborg's Interface by swiping your ID</li>
        </ol>
        These repair tasks may seem difficult, but are essential to keep your cyborgs running at peak efficiency.

        <h2><a name="Emergency">In Case of Emergency</h2>
        In case of emergency, there are a few steps you can take.

        <h3>"Rogue" Cyborgs</h3>
        If the cyborgs seem to become "rogue", they may have non-standard laws. In this case, use extreme caution.
        To repair the situation, follow these steps:
        <ol>
          <li>Locate the nearest robotics console</li>
          <li>Determine which cyborgs are "Rogue"</li>
          <li>Press the lockdown button to immobolize the cyborg</li>
          <li>Locate the cyborg</li>
          <li>Expose the cyborg's internal wiring</li>
          <li>Check to make sure the LawSync and AI Sync lights are lit</li>
          <li>If they are not lit, pulse the LawSync wire using a multitool to enable the cyborg's Law Sync</li>
          <li>Proceed to a cyborg upload console. Nanotrasen usually places these in the same location as AI uplaod consoles.</li>
          <li>Use a "Reset" upload moduleto reset the cyborg's laws</li>
          <li>Proceed to a Robotics Control console</li>
          <li>Remove the lockdown on the cyborg</li>
        </ol>

        <h3>As a last resort</h3>
        If all else fails in a case of cyborg-related emergency. There may be only one option. Using a Robotics Control console, you may have to remotely detonate the cyborg.
        <h3>WARNING:</h3> Do not detonate a borg without an explicit reason for doing so. Cyborgs are expensive pieces of Nanotrasen equipment, and you may be punished for detonating them without reason.

        </body>
		</html>
		"}



/obj/item/weapon/book/manual/chef_recipes
	name = "Chef Recipes"
	icon_state = "cooked_book"
	author = "Lord Frenrir Cageth"
	title = "Chef Recipes"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h1>Food for Dummies</h1>
				Here is a guide on basic food recipes and also how to not poison your customers accidentally.


				<h2>Basic ingredients preparation:</h2>

				<b>Dough:</b> 10u water + 15u flour for simple dough.<br>
				15u egg yolk + 15u flour + 5u sugar for cake batter.<br>
				Doughs can be transformed by using a knife and rolling pin.<br>
				All doughs can be microwaved.<br>
				<b>Bowl:</b> Add water to it for soup preparation.<br>
				<b>Meat:</b> Microwave it, process it, slice it into microwavable cutlets with your knife, or use it raw.<br>
				<b>Cheese:</b> Add 5u universal enzyme (catalyst) to milk and soy milk to prepare cheese (sliceable) and tofu.<br>
				<b>Rice:</b> Mix 10u rice with 10u water in a bowl then microwave it.

				<h2>Custom food:</h2>
				Add ingredients to a base item to prepare a custom meal.<br>
				The bases are:<br>
				- bun (burger)<br>
				- breadslices(sandwich)<br>
				- plain bread<br>
				- plain pie<br>
				- vanilla cake<br>
				- empty bowl (salad)<br>
				- bowl with 10u water (soup)<br>
				- boiled spaghetti<br>
				- pizza bread<br>
				- metal rod (kebab)

				<h2>Table Craft:</h2>
				Put ingredients on table, then click and drag the table onto yourself to see what recipes you can prepare.

				<h2>Microwave:</h2>
				Use it to cook or boil food ingredients (meats, doughs, egg, spaghetti, donkpocket, etc...).
				It can cook multiple items at once.

				<h2>Processor:</h2>
				Use it to process certain ingredients (meat into meatballs, doughslice into spaghetti, potato into fries,etc...)

				<h2>Gibber:</h2>
				Stuff an animal in it to grind it into meat.

				<h2>Meat spike:</h2>
				Stick an animal on it then begin collecting its meat.


				<h2>Example recipes:</h2>
				<b>Vanilla Cake</b>: Microwave cake batter.<br>
				<b>Burger:</b> 1 bun + 1 meat steak<br>
				<b>Bread:</b> Microwave dough.<br>
				<b>Waffles:</b> 2 pastry base<br>
				<b>Popcorn:</b> Microwave corn.<br>
				<b>Meat Steak:</b> Microwave meat.<br>
				<b>Meat Pie:</b> 1 plain pie + 1u black pepper + 1u salt + 2 meat cutlets<br>
				<b>Boiled Spagetti:</b> Microwave spaghetti.<br>
				<b>Donuts:</b> 1u sugar + 1 pastry base<br>
				<b>Fries:</b> Process potato.

				<h2>Sharing your food:</h2>
				You can put your meals on your kitchen counter or load them in the snack vending machines.
				</body>
				</html>
			"}


/obj/item/weapon/book/manual/barman_recipes
	name = "Barman Recipes"
	icon_state = "barbook"
	author = "Sir John Rose"
	title = "Barman Recipes"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h1>Drinks for dummies</h1>
				Heres a guide for some basic drinks.

				<h2>Manly Dorf:</h2>
				Mix ale and beer into a glass.

				<h2>Grog:</h2>
				Mix rum and water into a glass.

				<h2>Black Russian:</h2>
				Mix vodka and kahlua into a glass.

				<h2>Irish Cream:</h2>
				Mix cream and whiskey into a glass.

				<h2>Screwdriver:</h2>
				Mix vodka and orange juice into a glass.

				<h2>Cafe Latte:</h2>
				Mix milk and coffee into a glass.

				<h2>Mead:</h2>
				Mix Enzyme, water and sugar into a glass.

				<h2>Gin Tonic:</h2>
				Mix gin and tonic into a glass.

				<h2>Classic Martini:</h2>
				Mix vermouth and gin into a glass.


				</body>
				</html>
			"}


/obj/item/weapon/book/manual/detective
	name = "The Film Noir: Proper Procedures for Investigations"
	icon_state ="bookDetective"
	author = "Nanotrasen"
	title = "The Film Noir: Proper Procedures for Investigations"
	dat = {"<html>
			<head>
			<style>
			h1 {font-size: 18px; margin: 15px 0px 5px;}
			h2 {font-size: 15px; margin: 15px 0px 5px;}
			li {margin: 2px 0px 2px 15px;}
			ul {list-style: none; margin: 5px; padding: 0px;}
			ol {margin: 5px; padding: 0px 15px;}
			</style>
			</head>
			<body>
			<h3>Detective Work</h3>

			Between your bouts of self-narration, and drinking whiskey on the rocks, you might get a case or two to solve.<br>
			To have the best chance to solve your case, follow these directions:
			<p>
			<ol>
			<li>Go to the crime scene. </li>
			<li>Take your scanner and scan EVERYTHING (Yes, the doors, the tables, even the dog.) </li>
			<li>Once you are reasonably certain you have every scrap of evidence you can use, find all possible entry points and scan them, too. </li>
			<li>Return to your office. </li>
			<li>Using your forensic scanning computer, scan your Scanner to upload all of your evidence into the database.</li>
			<li>Browse through the resulting dossiers, looking for the one that either has the most complete set of prints, or the most suspicious items handled. </li>
			<li>If you have 80% or more of the print (The print is displayed) go to step 10, otherwise continue to step 8.</li>
			<li>Look for clues from the suit fibres you found on your perp, and go about looking for more evidence with this new information, scanning as you go. </li>
			<li>Try to get a fingerprint card of your perp, as if used in the computer, the prints will be completed on their dossier.</li>
			<li>Assuming you have enough of a print to see it, grab the biggest complete piece of the print and search the security records for it. </li>
			<li>Since you now have both your dossier and the name of the person, print both out as evidence, and get security to nab your baddie.</li>
			<li>Give yourself a pat on the back and a bottle of the ships finest vodka, you did it!</li>
			</ol>
			<p>
			It really is that easy! Good luck!

			</body>
			</html>"}

/obj/item/weapon/book/manual/nuclear
	name = "Fission Mailed: Nuclear Sabotage 101"
	icon_state ="bookNuclear"
	author = "Syndicate"
	title = "Fission Mailed: Nuclear Sabotage 101"
	dat = {"<html>
			Nuclear Explosives 101:<br>
			Hello and thank you for choosing the Syndicate for your nuclear information needs.<br>
			Today's crash course will deal with the operation of a Fusion Class Nanotrasen made Nuclear Device.<br>
			First and foremost, DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE.<br>
			Pressing any button on the compacted bomb will cause it to extend and bolt itself into place.<br>
			If this is done to unbolt it one must completely log in which at this time may not be possible.<br>
			To make the nuclear device functional:<br>
			<li>Place the nuclear device in the designated detonation zone.</li>
			<li>Extend and anchor the nuclear device from its interface.</li>
			<li>Insert the nuclear authorisation disk into slot.</li>
			<li>Type numeric authorisation code into the keypad. This should have been provided. Note: If you make a mistake press R to reset the device.
			<li>Press the E button to log onto the device.</li>
			You now have activated the device. To deactivate the buttons at anytime for example when you've already prepped the bomb for detonation	remove the auth disk OR press the R on the keypad.<br>
			Now the bomb CAN ONLY be detonated using the timer. Manual detonation is not an option.<br>
			Note: Nanotrasen is a pain in the neck.<br>
			Toggle off the SAFETY.<br>
			Note: You wouldn't believe how many Syndicate Operatives with doctorates have forgotten this step.<br>
			So use the - - and + + to set a det time between 5 seconds and 10 minutes.<br>
			Then press the timer toggle button to start the countdown.<br>
			Now remove the auth. disk so that the buttons deactivate.<br>
			Note: THE BOMB IS STILL SET AND WILL DETONATE<br>
			Now before you remove the disk if you need to move the bomb you can:<br>
			Toggle off the anchor, move it, and re-anchor.<br><br>
			Good luck. Remember the order:<br>
			<b>Disk, Code, Safety, Timer, Disk, RUN!</b><br>
			Intelligence Analysts believe that normal Nanotrasen procedure is for the Captain to secure the nuclear authorisation disk.<br>
			Good luck!
			</html>"}

// Wiki books that are linked to the configured wiki link.

// A book that links to the wiki
/obj/item/weapon/book/manual/wiki
	var/page_link = ""
	window_size = "970x710"

/obj/item/weapon/book/manual/wiki/attack_self()
	if(!dat)
		initialize_wikibook()
	..()

/obj/item/weapon/book/manual/wiki/proc/initialize_wikibook()
	if(config.wikiurl)
		dat = {"

			<html><head>
			<style>
				iframe {
					display: none;
				}
			</style>
			</head>
			<body>
			<script type="text/javascript">
				function pageloaded(myframe) {
					document.getElementById("loading").style.display = "none";
					myframe.style.display = "inline";
    			}
			</script>
			<p id='loading'>You start skimming through the manual...</p>
			<iframe width='100%' height='97%' onload="pageloaded(this)" src="[config.wikiurl]/[page_link]?printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
			</body>

			</html>

			"}

/obj/item/weapon/book/manual/wiki/chemistry
	name = "Chemistry Textbook"
	icon_state ="chemistrybook"
	author = "Nanotrasen"
	title = "Chemistry Textbook"
	page_link = "Guide_to_chemistry"

/obj/item/weapon/book/manual/wiki/engineering_construction
	name = "Station Repairs and Construction"
	icon_state ="bookEngineering"
	author = "Engineering Encyclopedia"
	title = "Station Repairs and Construction"
	page_link = "Guide_to_construction"

/obj/item/weapon/book/manual/wiki/engineering_guide
	name = "Engineering Textbook"
	icon_state ="bookEngineering2"
	author = "Engineering Encyclopedia"
	title = "Engineering Textbook"
	page_link = "Guide_to_engineering"

/obj/item/weapon/book/manual/wiki/security_space_law
	name = "Space Law"
	desc = "A set of Nanotrasen guidelines for keeping law and order on their space stations."
	icon_state = "bookSpaceLaw"
	author = "Nanotrasen"
	title = "Space Law"
	page_link = "Space_Law"

/obj/item/weapon/book/manual/wiki/infections
	name = "Infections - Making your own pandemic!"
	icon_state = "bookInfections"
	author = "Infections Encyclopedia"
	title = "Infections - Making your own pandemic!"
	page_link = "Infections"

/obj/item/weapon/book/manual/wiki/telescience
	name = "Teleportation Science - Bluespace for dummies!"
	icon_state = "book7"
	author = "University of Bluespace"
	title = "Teleportation Science - Bluespace for dummies!"
	page_link = "Guide_to_telescience"

/obj/item/weapon/book/manual/wiki/engineering_hacking
	name = "Hacking"
	icon_state ="bookHacking"
	author = "Engineering Encyclopedia"
	title = "Hacking"
	page_link = "Hacking"

/obj/item/weapon/book/manual/wiki/surgery
	name = "Surgery for Dummies"
	icon_state = "bookCloning"
	author = "United Earth Surgical Association"
	title = "Surgery for Dummies"
	page_link = "Surgery"

/obj/item/weapon/book/manual/wiki/preternis
	name = "Managing your Preternis"
	icon_state = "bookEngineering"
	author = "United Earth Government"
	title = "Managing your Preternis - a guide to the future of human lifestyle advancement"
	page_link = "Preternis"

/obj/item/weapon/book/manual/wiki/phytosian
	name = "How to Treat a Phytosian"
	icon_state = "bookHydroponicsPodPeople"
	author = "United Earth Government"
	title = "How to Treat a Phytosian"
	page_link = "Phytosian"

/obj/item/weapon/book/manual/wiki/plasmaman
	name = "History of the Ossius Pyrus"
	icon_state = "bookfireball"
	author = "United Earth Government"
	title = "History of the Ossius Pyrus"
	desc = "Contains everything you didn't care about."
	page_link = "Plasmamen"
