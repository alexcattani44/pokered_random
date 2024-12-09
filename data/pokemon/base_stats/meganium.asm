db DEX_MEGANIUM ; pokedex id

	db  80,  82,  100,  80, 83
	;   hp  atk  def  spd  spc

	db GRASS, GRASS ; type
	db 45 ; catch rate
	db 208 ; base exp

	INCBIN "gfx/pokemon/front/meganium.pic", 0, 1 ; sprite dimensions
	dw MeganiumPicFront, MeganiumPicBack

	db TACKLE, GROWL, LEECH_SEED, VINE_WHIP ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         SUBSTITUTE,   \
	     CUT
	; end

	db 0 ; padding