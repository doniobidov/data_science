# valueIterationAgents.py
# -----------------------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


# valueIterationAgents.py
# -----------------------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


import mdp, util

from learningAgents import ValueEstimationAgent
import collections

class ValueIterationAgent(ValueEstimationAgent):
    """
        * Please read learningAgents.py before reading this.*

        A ValueIterationAgent takes a Markov decision process
        (see mdp.py) on initialization and runs value iteration
        for a given number of iterations using the supplied
        discount factor.
    """
    def __init__(self, mdp, discount = 0.9, iterations = 100):
        """
          Your value iteration agent should take an mdp on
          construction, run the indicated number of iterations
          and then act according to the resulting policy.

          Some useful mdp methods you will use:
              mdp.getStates()
              mdp.getPossibleActions(state)
              mdp.getTransitionStatesAndProbs(state, action)
              mdp.getReward(state, action, nextState)
              mdp.isTerminal(state)
        """
        self.mdp = mdp
        self.discount = discount
        self.iterations = iterations
        self.values = util.Counter() # A Counter is a dict with default 0
        self.runValueIteration()

    # *********************
    #    Question 1
    # *********************
    def runValueIteration(self):
        # Write value iteration code here
        """ 
        Question 1: runValueIteration method 
        """
        "*** YOUR CODE HERE ***"
        V = util.Counter()
        for s in self.mdp.getStates():
            V[(s, 0)] = 0
        for limit in range(1, self.iterations + 1):
            for s in self.mdp.getStates():
                maxV = float("-infinity")
                for a in self.mdp.getPossibleActions(s):
                    v = 0
                    for next_state_probability in self.mdp.getTransitionStatesAndProbs(s, a):
                        v = v + next_state_probability[1] * (self.mdp.getReward(s, a, next_state_probability[0]) + self.discount * V[(next_state_probability[0], limit - 1)])
                    maxV = max(maxV, v)
                if maxV != float('-infinity'):
                    V[(s, limit)] = maxV
                else:
                    V[(s, limit)] = 0
        for s in self.mdp.getStates():
            self.values[s] = V[(s, self.iterations)]


    def getValue(self, state):
        """
          Return the value of the state (computed in __init__).
        """
        return self.values[state]

    # *********************
    #    Question 1
    # *********************
    def computeQValueFromValues(self, state, action):
        """
        Question 1 

          Compute the Q-value of action in state from the
          value function stored in self.values.
        """
        "*** YOUR CODE HERE ***"
        v = 0
        for next_state_probability in self.mdp.getTransitionStatesAndProbs(state, action):
            v = v + next_state_probability[1] * (self.mdp.getReward(state, action, next_state_probability[0]) + self.discount * self.values[next_state_probability[0]])
        return v
        util.raiseNotDefined()

    # *********************
    #    Question 1 
    # *********************
    def computeActionFromValues(self, state):
        """
        Question 1 

          The policy is the best action in the given state
          according to the values currently stored in self.values.

          You may break ties any way you see fit.  Note that if
          there are no legal actions, which is the case at the
          terminal state, you should return None.
        """
        "*** YOUR CODE HERE ***"
        max_Q_v = float("-infinity")
        return_a = "Stop"
        for a in self.mdp.getPossibleActions(state):
            if max_Q_v < self.getQValue(state, a):
                max_Q_v = self.getQValue(state, a)
                return_a = a
        return return_a
        util.raiseNotDefined()

    def getPolicy(self, state):
        return self.computeActionFromValues(state)

    def getAction(self, state):
        "Returns the policy at the state (no exploration)."
        return self.computeActionFromValues(state)

    def getQValue(self, state, action):
        return self.computeQValueFromValues(state, action)

class AsynchronousValueIterationAgent(ValueIterationAgent):
    """
        * Please read learningAgents.py before reading this.*

        An AsynchronousValueIterationAgent takes a Markov decision process
        (see mdp.py) on initialization and runs cyclic value iteration
        for a given number of iterations using the supplied
        discount factor.
    """
    def __init__(self, mdp, discount = 0.9, iterations = 1000):
        """
          Your cyclic value iteration agent should take an mdp on
          construction, run the indicated number of iterations,
          and then act according to the resulting policy. Each iteration
          updates the value of only one state, which cycles through
          the states list. If the chosen state is terminal, nothing
          happens in that iteration.

          Some useful mdp methods you will use:
              mdp.getStates()
              mdp.getPossibleActions(state)
              mdp.getTransitionStatesAndProbs(state, action)
              mdp.getReward(state)
              mdp.isTerminal(state)
        """
        ValueIterationAgent.__init__(self, mdp, discount, iterations)

    # *********************
    #    Question 4
    # *********************
    def runValueIteration(self):
        """
        Question 4
        """
        "*** YOUR CODE HERE ***"
        for limit in range(self.iterations):
            s = self.mdp.getStates()[limit % len(self.mdp.getStates())]
            if not len(self.mdp.getPossibleActions(s)) == 0:
                if not self.mdp.isTerminal(s):
                    maxV = float("-inf")
                    for a in self.mdp.getPossibleActions(s):
                        maxQ = self.computeQValueFromValues(s, a)
                        if maxV < maxQ:
                           maxV = maxQ
                    self.values[s] = maxV


class PrioritizedSweepingValueIterationAgent(AsynchronousValueIterationAgent):
    """
        * Please read learningAgents.py before reading this.*

        A PrioritizedSweepingValueIterationAgent takes a Markov decision process
        (see mdp.py) on initialization and runs prioritized sweeping value iteration
        for a given number of iterations using the supplied parameters.
    """
    def __init__(self, mdp, discount = 0.9, iterations = 100, theta = 1e-5):
        """
          Your prioritized sweeping value iteration agent should take an mdp on
          construction, run the indicated number of iterations,
          and then act according to the resulting policy.
        """
        self.theta = theta
        ValueIterationAgent.__init__(self, mdp, discount, iterations)

    # *********************
    #    Question 5 
    # *********************
    def runValueIteration(self):
        """
        Question 5 - Extra Credit
        """
        "*** YOUR CODE HERE ***"
        # finish later