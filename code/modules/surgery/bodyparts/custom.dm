/obj/item/bodypart/custom
	limb_type = null //Used for the icon format "[type]_[body_zone]_s"
	should_draw_gender = FALSE //You can safely change this in a subtype
	custom = TRUE

/obj/item/bodypart/custom/New()
	..()
	overlays += get_limb_icon()

/obj/item/bodypart/custom/robotic
	status = ORGAN_ROBOTIC
	limb_type = "robotic"
	brutemod = 0.8
	burnmod = 0.5

/obj/item/bodypart/custom/robotic/l_arm
	name = "robotic left arm"
	body_zone = "l_arm"
	body_part = ARM_LEFT

/obj/item/bodypart/custom/robotic/r_arm
	name = "robotic right arm"
	body_zone = "r_arm"
	body_part = ARM_RIGHT

/obj/item/bodypart/custom/robotic/l_leg
	name = "robotic left leg"
	body_zone = "l_leg"
	body_part = LEG_LEFT

/obj/item/bodypart/custom/robotic/r_leg
	name = "robotic right leg"
	body_zone = "r_leg"
	body_part = LEG_RIGHT

/obj/item/bodypart/custom/robotic/chest
	name = "robotic chest"
	body_zone = "chest"
	should_draw_gender = TRUE
	body_part = CHEST

/obj/item/bodypart/custom/robotic/head
	name = "robotic head"
	body_zone = "head"
	should_draw_gender = TRUE
	body_part = HEAD

