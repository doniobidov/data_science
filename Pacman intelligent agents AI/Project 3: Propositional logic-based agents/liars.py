'''
The salt has been eaten!
Well, it was found that the culprit was either the Caterpillar, Bill the Lizard or the Cheshire Cat.
The three were tried and made the following statements in court:
  CATERPILLAR: Bill the Lizard ate the salt.
  BILL THE LIZARD: That is true!
  CHESHIRE CAT: I never ate the salt.
  As it happened, at least one of them lied and at least one told the truth. Who ate the salt?

Let 1 be CATERPILLAR tells the truth
Let 2 be BILL THE LIZARD tells the truth
Let 3 be CHESHIRE CAT tells the truth
Let 4 be CATERPILLAR ate the salt
Let 5 be BILL THE LIZARD ate the salt
Let 6 be CHESHIRE CAT ate the salt
'''

# **************
#  Question 5 
# **************
def rule_caterpillar():
    "Return the CNF form of CATERPILLAR's statement"
    "*** YOUR CODE HERE ***"
    return [[-1, 5], [-5, 1]]

def rule_bill():
    "Return the CNF form of BILL THE LIZARD's statement"
    "*** YOUR CODE HERE ***"
    return [[-2, 5], [-5, 2]]

def rule_cheshire():
    "Return the CNF form of CHESHIRE CAT's statement"
    "*** YOUR CODE HERE ***"
    return [[-3, -6], [6, 3]]

def rule_truth():
    "Return the CNF form of 'at least one of them lied and at least one told the truth'"
    "*** YOUR CODE HERE ***"
    return [[-1, -2, -3], [1, 2, 3]]

def rule_salt():
    "Return the CNF form of 'the salt has been eaten'"
    "HINT: one (and only one) culprit ate the salt"
    "*** YOUR CODE HERE ***"
    return [[4, 5, 6], [-4, -5], [-4, -6], [-5, -6]]