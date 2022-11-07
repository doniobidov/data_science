'''cluedo.py - project skeleton for a propositional reasoner
for the game of Clue.  Unimplemented portions have the comment "TO
BE IMPLEMENTED AS AN EXERCISE".  The reasoner does not include
knowledge of how many cards each player holds.
Originally by Todd Neller
Ported to Python by Dave Musicant
Adapted to course needs by Laura Brown

Copyright (C) 2008 Dave Musicant

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Information about the GNU General Public License is available online at:
  http://www.gnu.org/licenses/
To receive a copy of the GNU General Public License, write to the Free
Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.'''
import itertools

import cnf

class Cluedo:
    suspects = ['sc', 'mu', 'wh', 'gr', 'pe', 'pl']
    weapons  = ['kn', 'cs', 're', 'ro', 'pi', 'wr']
    rooms    = ['ha', 'lo', 'di', 'ki', 'ba', 'co', 'bi', 'li', 'st']
    casefile = "cf"
    hands    = suspects + [casefile]
    cards    = suspects + weapons + rooms

    """
    Return ID for player/card pair from player/card indicies
    """
    @staticmethod
    def getIdentifierFromIndicies(hand, card):
        return hand * len(Cluedo.cards) + card + 1

    """
    Return ID for player/card pair from player/card names
    """
    @staticmethod
    def getIdentifierFromNames(hand, card):
        return Cluedo.getIdentifierFromIndicies(Cluedo.hands.index(hand), Cluedo.cards.index(card))


# **************
#  Question 6 
# **************
def deal(hand, cards):
    "Construct the CNF clauses for the given cards being in the specified hand"
    "*** YOUR CODE HERE ***"
    hand_card_list = [[Cluedo.getIdentifierFromNames(hand, a_card)] for a_card in cards]
    return hand_card_list

# **************
#  Question 7 
# **************
def axiom_card_exists():
    """
    Construct the CNF clauses which represents:
        'Each card is in at least one place'
    """
    "*** YOUR CODE HERE ***"
    all_cards_served_list = [[Cluedo.getIdentifierFromNames(a_hand, a_card) for a_hand in Cluedo.hands] for a_card in Cluedo.cards]
    return all_cards_served_list


# **************
#  Question 7 
# **************
def axiom_card_unique():
    """
    Construct the CNF clauses which represents:
        'If a card is in one place, it can not be in another place'
    """
    "*** YOUR CODE HERE ***"
    one_card_one_hand_list = []
    for card_hands_list in axiom_card_exists():
        card_hands_list_negations = [-card_hand for card_hand in card_hands_list]
        negations_combinations = itertools.combinations(card_hands_list_negations, 2)
        negations_combinations_conjunctions = [list(negations_combination) for negations_combination in negations_combinations]
        one_card_one_hand_list.append(negations_combinations_conjunctions)
    merged_one_card_one_hand_list = [inner_element for element in one_card_one_hand_list for inner_element in element]
    return merged_one_card_one_hand_list


# **************
#  Question 7 
# **************
def axiom_casefile_exists():
    """
    Construct the CNF clauses which represents:
        'At least one card of each category is in the case file'
    """
    "*** YOUR CODE HERE ***"
    casefile_one_each_category_card_list = [] # at least
    casefile_one_suspect_list = [Cluedo.getIdentifierFromNames(Cluedo.casefile, suspect) for suspect in Cluedo.suspects] # at least
    casefile_one_weapon_list = [Cluedo.getIdentifierFromNames(Cluedo.casefile, weapon) for weapon in Cluedo.weapons] # at least
    casefile_one_room_list = [Cluedo.getIdentifierFromNames(Cluedo.casefile, room) for room in Cluedo.rooms] # at least
    casefile_one_each_category_card_list = [casefile_one_suspect_list, casefile_one_weapon_list, casefile_one_room_list] # at least
    return casefile_one_each_category_card_list


# **************
#  Question 7 
# **************
def axiom_casefile_unique():
    """
    Construct the CNF clauses which represents:
        'No two cards in each category are in the case file'
    """
    "*** YOUR CODE HERE ***"
    casefile_suspect_list = [Cluedo.getIdentifierFromNames(Cluedo.casefile, suspect) for suspect in Cluedo.suspects]
    casefile_weapon_list = [Cluedo.getIdentifierFromNames(Cluedo.casefile, weapon) for weapon in Cluedo.weapons]
    casefile_room_list = [Cluedo.getIdentifierFromNames(Cluedo.casefile, room) for room in Cluedo.rooms]
    casefile_suspect_list_negations = [-casefile_suspect for casefile_suspect in casefile_suspect_list]
    casefile_weapon_list_negations = [-casefile_weapon for casefile_weapon in casefile_weapon_list]
    casefile_room_list_negations = [-casefile_room for casefile_room in casefile_room_list]
    casefile_suspect_negations_combinations = itertools.combinations(casefile_suspect_list_negations, 2)
    casefile_weapon_negations_combinations = itertools.combinations(casefile_weapon_list_negations, 2)
    casefile_room_negations_combinations = itertools.combinations(casefile_room_list_negations, 2)
    casefile_at_most_one_each_list = list(casefile_suspect_negations_combinations) + list(casefile_weapon_negations_combinations) + list(casefile_room_negations_combinations)
    return casefile_at_most_one_each_list


# **************
#  Question 8 
# **************
def suggest(suggester, card1, card2, card3, refuter, cardShown):
    "Construct the CNF clauses representing facts and/or clauses learned from a suggestion"
    "*** YOUR CODE HERE ***"
    if refuter:
        between_list = [[Cluedo.suspects[i]] for i in range(Cluedo.suspects.index(suggester) + 1, Cluedo.suspects.index(refuter))]
    else:
        all_except_suggester_list = Cluedo.suspects.copy()
        all_except_suggester_list.remove(suggester)
        between_list = [[all_except_suggester_list[i]] for i in range(0, len(all_except_suggester_list))]
    one = [[-Cluedo.getIdentifierFromNames(between, card1)] for transit_list in between_list for between in transit_list] # between don't have card 1
    two = [[-Cluedo.getIdentifierFromNames(between, card2)] for transit_list in between_list for between in transit_list]  # between don't have card 2
    three = [[-Cluedo.getIdentifierFromNames(between, card3)] for transit_list in between_list for between in transit_list]  # between don't have card 3
    card_list = [card1, card2, card3]
    four = []
    five = []
    if refuter and cardShown:
        four.append(Cluedo.getIdentifierFromNames(refuter, cardShown))
        return one + two + three + [four]
    elif refuter and not cardShown:
        for card in card_list:
            five.append(Cluedo.getIdentifierFromNames(refuter, card))
        return one + two + three + [five]
    else:
        return one + two + three


# **************
#  Question 9 
# **************
def accuse(accuser, card1, card2, card3, correct):
    "Construct the CNF clauses representing facts and/or clauses learned from an accusation"
    "*** YOUR CODE HERE ***"
    card_list = [card1, card2, card3]
    if correct == True:
        return [[Cluedo.getIdentifierFromNames(Cluedo.casefile, card)] for card in card_list]
    else:
        one = [[-Cluedo.getIdentifierFromNames(Cluedo.casefile, card) for card in card_list]]
        two = [[-Cluedo.getIdentifierFromNames(accuser, card)] for card in card_list]
        return one + two