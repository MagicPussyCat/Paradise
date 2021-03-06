
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/used_weapon = null, var/sharp = 0, var/edge = 0)
	blocked = (100-blocked)/100
	if(!damage || (blocked <= 0))	return 0
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage * blocked)
		if(BURN)
			if(RESIST_HEAT in mutations)	damage = 0
			adjustFireLoss(damage * blocked)
		if(TOX)
			adjustToxLoss(damage * blocked)
		if(OXY)
			adjustOxyLoss(damage * blocked)
		if(CLONE)
			adjustCloneLoss(damage * blocked)
		if(HALLOSS)
			adjustHalLoss(damage * blocked)
		if(STAMINA)
			adjustStaminaLoss(damage * blocked)
	updatehealth()
	return 1


/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone = null, var/blocked = 0, var/stamina = 0)
	if(blocked >= 100)	return 0
	if(brute)	apply_damage(brute, BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, CLONE, def_zone, blocked)
	if(halloss) apply_damage(halloss, HALLOSS, def_zone, blocked)
	if(stamina) apply_damage(stamina, STAMINA, def_zone, blocked)
	return 1



/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	blocked = (100-blocked)/100
	if(!effect || (blocked <= 0))	return 0
	switch(effecttype)
		if(STUN)
			Stun(effect * blocked)
		if(WEAKEN)
			Weaken(effect * blocked)
		if(PARALYZE)
			Paralyse(effect * blocked)
		if(AGONY)
			halloss += effect // Useful for objects that cause "subdual" damage. PAIN!
		if(IRRADIATE)
			radiation += max(effect * ((100-run_armor_check(null, "rad", "Your clothes feel warm.", "Your clothes feel warm."))/100),0)//Rads auto check armor
		if(SLUR)
			slurring = max(slurring,(effect * blocked))
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = max(stuttering,(effect * blocked))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry,(effect * blocked))
		if(DROWSY)
			drowsyness = max(drowsyness,(effect * blocked))
		if(JITTER)
			if(status_flags & CANSTUN)
				jitteriness = max(jitteriness,(effect * blocked))
	updatehealth()
	return 1


/mob/living/carbon/human/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if((species.flags & IS_SYNTHETIC) && (effecttype == IRRADIATE))
		return
	return ..()


/mob/living/carbon/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	return ..()

/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/slur = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0, var/blocked = 0, var/stamina = 0, var/jitter = 0)
	if(blocked >= 100)	return 0
	if(stun)		apply_effect(stun, STUN, blocked)
	if(weaken)		apply_effect(weaken, WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze, PARALYZE, blocked)
	if(irradiate)	apply_effect(irradiate, IRRADIATE, blocked)
	if(slur) 		apply_effect(slur, SLUR, blocked)
	if(stutter)		apply_effect(stutter, STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur, EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy, DROWSY, blocked)
	if(agony)		apply_effect(agony, AGONY, blocked)
	if(stamina)		apply_damage(stamina, STAMINA, null, blocked)
	if(jitter) 		apply_effect(jitter, JITTER, blocked)
	return 1
