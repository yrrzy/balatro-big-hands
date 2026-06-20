--- STEAMODDED HEADER
--- MOD_NAME: Big Hands
--- MOD_ID: BigHands
--- MOD_AUTHOR: [Yrrzy]
--- MOD_DESCRIPTION: Adds a voucher that allows playing up to 6 cards, introduces 4 new Planet cards for the hands this creates, and one new Joker.
--- BADGE_COLOUR: ffc90e
--- PREFIX: bighands
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-0812d]

----------------------------------------------
------------ATLAS ----------------------------
SMODS.Atlas {
	key = 'bighandsatlas',
	path = 'bighands.png',
	px = 71,
	py = 95
}

----------------------------------------------
------------VOUCHERS -------------------------
SMODS.Voucher {
	key = "bighand",
    	loc_txt = {
        		name = 'Big Hand',
        		text = { 'Play up to {C:attention}6{} cards a hand' }
    	},
	atlas = "bighandsatlas",
	pos = { x = 4, y = 0 },
	redeem = function(self, card)
        		--Change highlight limit
        		G.hand.config.highlighted_limit = 6
        		G.GAME.pool_flags.bighandsreal = true

        		-- Make new hands visible
        		--G.GAME.hands.bighands_three_pair.visible = true
        		--G.GAME.hands.bighands_flush_triad.visible = true
        		--G.GAME.hands.bighands_flush_six.visible = true
        		--G.GAME.hands.bighands_6oak.visible = true
	end
}

SMODS.Voucher {
	key = "encore",
    	loc_txt = {
        		name = 'Encore',
        		text = { 'Retrigger {C:attention}6{}th played card in a hand' }
    	},
	atlas = "bighandsatlas",
	pos = { x = 5, y = 0 },
    	requires = { 'bighands_bighand' },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card == context.scoring_hand[6] then
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = card
                }
            end
        end
    end
}

----------------------------------------------
------------HAND TYPES -----------------------
SMODS.PokerHandPart {
    key = '6',
    func = function(hand)
        return get_X_same(6, hand)
    end
}

SMODS.PokerHand {
    key = 'three_pair',
    mult = 4,
    chips = 45,
    l_mult = 2,
    l_chips = 30,
    atlas = 'poker_hands',
    pos = { x = 0, y = 0 },
    example = {
        { 'S_A',    true },
        { 'C_A',    true },
        { 'H_5',    true },
        { 'C_5',    true },
        { 'S_K',    true },
        { 'D_K',    true },

    },
    loc_txt = {
        name = 'Three Pair',
        description = {
            "3 Pairs of cards with different ranks"
        }
    },
    visible = false,
    evaluate = function(parts, hand)
        return #parts._2 >= 3 and parts._all_pairs or {}
    end
}

SMODS.PokerHand {
    key = 'flush_triad',
    mult = 11,
    chips = 110,
    l_mult = 3,
    l_chips = 30,
    atlas = 'poker_hands',
    pos = { x = 0, y = 6 },
    example = {

        { 'S_A', true },
        { 'S_A', true },
        { 'S_5', true },
        { 'S_5', true },
        { 'S_K', true },
        { 'S_K', true }

    },
    loc_txt = {
        name = 'Flush Triad',
        description = {
            "3 Pairs of cards with different ranks with",
            "all cards sharing the same suit"
        }
    },
    visible = false,
    evaluate = function(parts, hand)
        return #parts._2 == 3 and next(parts._flush) and
            { SMODS.merge_lists(parts._all_pairs, parts._flush) } or {}
    end
}

SMODS.PokerHand {
    key = 'flush_six',
    mult = 18,
    chips = 180,
    l_mult = 4,
    l_chips = 80,
    atlas = 'poker_hands',
    pos = { x = 0, y = 10 },
    example = {

        { 'S_K', true },
        { 'S_K', true },
        { 'S_K', true },
        { 'S_K', true },
        { 'S_K', true },
        { 'S_K', true }

    },
    loc_txt = {
        name = 'Flush Six',
        description = {
            "6 cards with the same rank with",
            "all cards sharing the same suit"
        }
    },
    visible = false,
    evaluate = function(parts, hand)
        return next(parts.bighands_6) and next(parts._flush)
            and { SMODS.merge_lists(parts.bighands_6, parts._flush) } or {}
    end
}

SMODS.PokerHand {
    key = '6oak',
    mult = 14,
    chips = 140,
    l_mult = 4,
    l_chips = 60,
    atlas = 'poker_hands',
    pos = { x = 0, y = 2 },
    example = {

        { 'S_K', true },
        { 'D_K', true },
        { 'C_K', true },
        { 'H_K', true },
        { 'S_K', true },
        { 'D_K', true }

    },
    loc_txt = {
        name = 'Six of a Kind',
        description = {
            "6 cards with the same rank"
        }
    },
    visible = false,
    evaluate = function(parts, hand)
        return next(parts.bighands_6) and parts.bighands_6 or {}
    end
}

----------------------------------------------
------------RENAMES --------------------------

SMODS.PokerHand:take_ownership('Full House', {
	modify_display_text = function(self,cards,scoring_hand)
		if #scoring_hand == 6 then
			return "bh_doubletriple"
		end
	end
}, true)

SMODS.PokerHand:take_ownership('Straight', {
	modify_display_text = function(self,cards,scoring_hand)
		if #scoring_hand == 6 then --and #parts._2 < 1 then
			return "bh_bigstraight"
		end
	end
}, true)

SMODS.PokerHand:take_ownership('Flush', {
	modify_display_text = function(self,cards,scoring_hand)
		if #scoring_hand == 6 then
			return "bh_bigflush"
		end
	end
}, true)

SMODS.PokerHand:take_ownership('Flush House', {
	modify_display_text = function(self,cards,scoring_hand)
		if #scoring_hand == 6 then
			return "bh_bigflushhouse"
		end
	end
}, true)

----------------------------------------------
------------MOONS ----------------------------
SMODS.Consumable {
    key = 'g_io',
    set = 'Planet',
    loc_txt = {
        name = 'Io',
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        },
    },
    atlas = 'bighandsatlas',
    pos = {
        x = 0,
        y = 0
    },
    config = {
        hand_type = 'bighands_three_pair',
        softlock = true
    },
    cost = 4,
    loc_vars = function(self, info_queue, center)
        return {
            vars =
            {
                G.GAME.hands[center.ability.hand_type].level,
                localize(center.ability.hand_type, "poker_hands"),
                G.GAME.hands[center.ability.hand_type].l_mult,
                G.GAME.hands[center.ability.hand_type].l_chips,
                colours = {
                    (G.GAME.hands[center.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[center.ability.hand_type].level)])
                }
            },
        }
    end,
    in_pool = function(self, args)
        if (G.GAME.pool_flags.bighandsreal) then
            return true
        end

        return false
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('bh_gmoon'), get_type_colour(card.config.center), nil, 1.2)
    end
}

SMODS.Consumable {
    key = 'g_europa',
    set = 'Planet',
    loc_txt = {
        name = 'Europa',
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        },
    },
    atlas = 'bighandsatlas',
    pos = {
        x = 1,
        y = 0
    },
    config = {
        hand_type = 'bighands_flush_triad',
        softlock = true
    },
    cost = 4,
    loc_vars = function(self, info_queue, center)
        return {
            vars =
            {
                G.GAME.hands[center.ability.hand_type].level,
                localize(center.ability.hand_type, "poker_hands"),
                G.GAME.hands[center.ability.hand_type].l_mult,
                G.GAME.hands[center.ability.hand_type].l_chips,
                colours = {
                    (G.GAME.hands[center.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[center.ability.hand_type].level)])
                }
            },
        }
    end,
    in_pool = function(self, args)
        if (G.GAME.pool_flags.bighandsreal) then
            return true
        end

        return false
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('bh_gmoon'), get_type_colour(card.config.center), nil, 1.2)
    end
}

SMODS.Consumable {
    key = 'g_ganymede',
    set = 'Planet',
    loc_txt = {
        name = 'Ganymede',
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        },
    },
    atlas = 'bighandsatlas',
    pos = {
        x = 2,
        y = 0
    },
    config = {
        hand_type = 'bighands_flush_six',
        softlock = true
    },
    cost = 4,
    loc_vars = function(self, info_queue, center)
        return {
            vars =
            {
                G.GAME.hands[center.ability.hand_type].level,
                localize(center.ability.hand_type, "poker_hands"),
                G.GAME.hands[center.ability.hand_type].l_mult,
                G.GAME.hands[center.ability.hand_type].l_chips,
                colours = {
                    (G.GAME.hands[center.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[center.ability.hand_type].level)])
                }
            },
        }
    end,
    in_pool = function(self, args)
        if (G.GAME.pool_flags.bighandsreal) then
            return true
        end

        return false
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('bh_gmoon'), get_type_colour(card.config.center), nil, 1.2)
    end
}
SMODS.Consumable {
    key = 'g_callisto',
    set = 'Planet',
    loc_txt = {
        name = 'Callisto',
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        },
    },
    atlas = 'bighandsatlas',
    pos = {
        x = 3,
        y = 0
    },
    config = {
        hand_type = 'bighands_6oak',
        softlock = true
    },
    cost = 4,
    loc_vars = function(self, info_queue, center)
        return {
            vars =
            {
                G.GAME.hands[center.ability.hand_type].level,
                localize(center.ability.hand_type, "poker_hands"),
                G.GAME.hands[center.ability.hand_type].l_mult,
                G.GAME.hands[center.ability.hand_type].l_chips,
                colours = {
                    (G.GAME.hands[center.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[center.ability.hand_type].level)])
                }
            },
        }
    end,
    in_pool = function(self, args)
        if (G.GAME.pool_flags.bighandsreal) then
            return true
        end

        return false
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('bh_gmoon'), get_type_colour(card.config.center), nil, 1.2)
    end
}

----------------------------------------------
------------JOKERS ---------------------------
SMODS.Joker {
	key = 'carpool',
	loc_txt = {
		name = 'Carpool',
		text = {
			"This Joker gives {C:white,X:mult} X#1# {} Mult",
			"for each {C:attention}non-scoring{} card",
			"in {C:attention}played hand"
		}
	},
	config = { extra = { mult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	rarity = 1,
	atlas = 'bighandsatlas',
	pos = {
		x = 6,
		y = 0
	},
	cost = 2,
	calculate = function(self, card, context)
		if context.joker_main then
			local score = #context.full_hand - #context.scoring_hand
			if score>1 then
				return {
					xmult=score
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'moneyjoker',
	loc_txt = {
		name = 'Money Joker',
		text = {
			"This Joker gives {C:white,X:mult} X#1# {} Mult",
			"for each {C:attention}non-scoring{} card",
			"in {C:attention}played hand"
		}
	},
	config = { extra = { mult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	rarity = 1,
	atlas = 'bighandsatlas',
	pos = {
		x = 7,
		y = 0
	},
	cost = 2,
	calculate = function(self, card, context)
		if context.joker_main then
			local score = #context.full_hand - #context.scoring_hand
			if score>1 then
				return {
					xmult=score
				}
			end
		end
	end
}