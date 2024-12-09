PrepareRandomBattle:
	call ClearScreen ; reset screen before loading new data

	xor a
	ld [wWinStreakCounter], a

	ld hl, BattlePlayerName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData

	ld hl, BattleRivalName
	ld de, wRivalName
	ld bc, NAME_LENGTH
	call CopyData

	call LoadFontTilePatterns
	call LoadHpBarAndStatusTilePatterns
	call ClearSprites
	call RunDefaultPaletteCommand

	hlcoord 5, 6
	ld b, 3
	ld c, 9
	call TextBoxBorder

	hlcoord 7, 7
	ld de, PreBattleOptions
	call PlaceString

	ld a, TEXT_DELAY_MEDIUM
	ld [wOptions], a

	ld a, A_BUTTON | B_BUTTON | START
	ld [wMenuWatchedKeys], a
	xor a
	ld [wMenuJoypadPollCount], a
	inc a
	ld [wMaxMenuItem], a
	ld a, 7
	ld [wTopMenuItemY], a
	dec a
	ld [wTopMenuItemX], a
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a

	call HandleMenuInput
	bit BIT_B_BUTTON, a
	jp nz, DisplayTitleScreen

	ld a, [wCurrentMenuItem]
	and a ; BATTLE
	jp z, RandomBattle

	; EXIT - the illusion of choice
	ld hl, wStatusFlags6
	set BIT_DEBUG_MODE, [hl]
	jp StartNewGame

BattlePlayerName:
	db "Player@"

BattleRivalName:
	db "Rival@"

PreBattleOptions:
	db   "BATTLE"
	next "EXIT@"

RandomBattle:
.loop
	call GBPalNormal

	; Max obedience for Pokemon
	ld a, 1 << BIT_EARTHBADGE
	ld [wObtainedBadges], a

	; Reset the party.
	ld hl, wPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	; Give the player a random level 50 Pokemon.
    call PrepRandomPokemon
	ld [wCurPartySpecies], a
	ld a, 50
	ld [wCurEnemyLevel], a
	xor a
	ld [wMonDataLocation], a
	ld [wCurMap], a
	call AddPartyMon

	; Fight against a random level 50 Pokemon.
	call PrepRandomPokemon
	ld [wCurOpponent], a

	predef InitOpponent

	; code below does not correctly display the win streak,
	; instead shows white screen
	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Increment win streak after the battle ends
	; call AnyEnemyPokemonAliveCheck
	; and a
	; jr nz, .continueToLoop
	; fallthrough if no pokemon alive to increment win streak
	; ld a, [wWinStreakCounter]
	; inc a             ; Increment counter
	; ld [wWinStreakCounter], a
	; ld hl, WinStreakText
	; call PrintText

; .continueToLoop
	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; When the battle ends, do it all again.
	; There are some graphical quirks in SGB mode.
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	ldh [hAutoBGTransferEnabled], a
	jr .loop

PrepRandomPokemon:
	call Random
	and 255              		; Use only the lower 8 bits (A = 0–255)
	cp 151
	jr nc, PrepRandomPokemon 	; If A >= 151, redo
	add 1                 		; Shift range to 1–151
	ret

; WinStreakText:
; 	text_far _WinStreakText
; 	text_end

; WinStreakResetText:
; 	text_far _WinStreakResetText
; 	text_end