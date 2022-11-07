# multiAgents.py
# --------------
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


from util import manhattanDistance
from game import Directions
import random, util

from game import Agent

class ReflexAgent(Agent):
    """
    A reflex agent chooses an action at each choice point by examining
    its alternatives via a state evaluation function.

    The code below is provided as a guide.  You are welcome to change
    it in any way you see fit, so long as you don't touch our method
    headers.
    """


    def getAction(self, gameState):
        """
        You do not need to change this method, but you're welcome to.

        getAction chooses among the best options according to the evaluation function.

        Just like in the previous project, getAction takes a GameState and returns
        some Directions.X for some X in the set {NORTH, SOUTH, WEST, EAST, STOP}
        """
        # Collect legal moves and successor states
        legalMoves = gameState.getLegalActions()

        # Choose one of the best actions
        scores = [self.evaluationFunction(gameState, action) for action in legalMoves]
        bestScore = max(scores)
        bestIndices = [index for index in range(len(scores)) if scores[index] == bestScore]
        chosenIndex = random.choice(bestIndices) # Pick randomly among the best

        "Add more of your code here if you want to"

        return legalMoves[chosenIndex]

    def evaluationFunction(self, currentGameState, action):
        """
        Design a better evaluation function here.

        The evaluation function takes in the current and proposed successor
        GameStates (pacman.py) and returns a number, where higher numbers are better.

        The code below extracts some useful information from the state, like the
        remaining food (newFood) and Pacman position after moving (newPos).
        newScaredTimes holds the number of moves that each ghost will remain
        scared because of Pacman having eaten a power pellet.

        Print out these variables to see what you're getting, then combine them
        to create a masterful evaluation function.
        """
        # Useful information you can extract from a GameState (pacman.py)
        walls = currentGameState.getWalls()
        successorGameState = currentGameState.generatePacmanSuccessor(action)
        currentPos = currentGameState.getPacmanPosition()
        newPos = successorGameState.getPacmanPosition()
        currentFood = currentGameState.getFood()
        newFood = successorGameState.getFood()
        newGhostStates = successorGameState.getGhostStates()
        newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]

        "*** YOUR CODE HERE ***"
        return_value = 0
        # current_score = currentGameState.getScore()
        # successor_score = successorGameState.getScore()
        # score_improvement = successor_score - current_score
        # return_value = return_value + score_improvement # adding score improvement part
        current_food_list = currentFood.asList()
        new_food_list = newFood.asList()
        if newPos in current_food_list:
            return_value = return_value + 10
        # food_decrease = len(current_food_list) - len(new_food_list)
        # return_value = return_value + 10*food_decrease # adding eaten food part
        try:
            closest_food_distance = min([manhattanDistance(new_food_location, newPos) for new_food_location in new_food_list])
            return_value = return_value + 5/(closest_food_distance) # adding closest food distance part
        except ValueError:
            return_value += 0
        min_scared_time = min(newScaredTimes)
        if min_scared_time > 1:
            weight_ghost_distance = 0
        else:
            weight_ghost_distance = 1
        closest_ghost_distance = min([manhattanDistance(new_ghost_state.getPosition(), newPos) for new_ghost_state in newGhostStates])
        if closest_ghost_distance < 2*weight_ghost_distance:
            return_value = return_value - 20 # adding distance to ghost part
        if closest_ghost_distance < 4*weight_ghost_distance:
            return_value = return_value - 10 # adding distance to ghost part
        old_capsule_list = currentGameState.getCapsules()
        new_capsule_list = successorGameState.getCapsules()
        if newPos in old_capsule_list:
            return_value = return_value + 10
        # capsule_decrease = len(new_capsule_list) - len(old_capsule_list)
        # return_value = return_value + 10*capsule_decrease # adding eaten capsule part
        try:
            closest_capsule_distance = min([manhattanDistance(new_capsule_location, newPos) for new_capsule_location in new_capsule_list])
            return_value = return_value + 5/(closest_capsule_distance) # adding closest capsule distance part
        except ValueError:
            return_value += 0
        # if action == "Stop":
            # return -999
        if currentPos in walls:
            return -999
        return return_value

def scoreEvaluationFunction(currentGameState):
    """
    This default evaluation function just returns the score of the state.
    The score is the same one displayed in the Pacman GUI.

    This evaluation function is meant for use with adversarial search agents
    (not reflex agents).
    """
    return currentGameState.getScore()

class MultiAgentSearchAgent(Agent):
    """
    This class provides some common elements to all of your
    multi-agent searchers.  Any methods defined here will be available
    to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

    You *do not* need to make any changes here, but you can if you want to
    add functionality to all your adversarial search agents.  Please do not
    remove anything, however.

    Note: this is an abstract class: one that should not be instantiated.  It's
    only partially specified, and designed to be extended.  Agent (game.py)
    is another abstract class.
    """

    def __init__(self, evalFn = 'scoreEvaluationFunction', depth = '2'):
        self.index = 0 # Pacman is always agent index 0
        self.evaluationFunction = util.lookup(evalFn, globals())
        self.depth = int(depth)

class MinimaxAgent(MultiAgentSearchAgent):
    """
    Your minimax agent (question 2)
    """

    def getAction(self, gameState):
        """
        Returns the minimax action from the current gameState using self.depth
        and self.evaluationFunction.

        Here are some method calls that might be useful when implementing minimax.

        gameState.getLegalActions(agentIndex):
        Returns a list of legal actions for an agent
        agentIndex=0 means Pacman, ghosts are >= 1

        gameState.generateSuccessor(agentIndex, action):
        Returns the successor game state after an agent takes an action

        gameState.getNumAgents():
        Returns the total number of agents in the game

        gameState.isWin():
        Returns whether or not the game state is a winning state

        gameState.isLose():
        Returns whether or not the game state is a losing state
        """
        "*** YOUR CODE HERE ***"
        def Minimax(state, agent_index, depth):
            return_move_utility = []
            if depth == self.depth or len(state.getLegalActions(agent_index)) == 0:
                return ["Stop", self.evaluationFunction(state)]
            if agent_index == state.getNumAgents() - 1:
                depth = depth + 1
                agent_index_next = self.index
            else:
                agent_index_next = agent_index + 1
            for move in state.getLegalActions(agent_index):
                next_utility = Minimax(state.generateSuccessor(agent_index, move), agent_index_next, depth)
                if len(return_move_utility) == 0:
                    return_move_utility.append(move)
                    return_move_utility.append(next_utility[1])
                else:
                    previous_utility = return_move_utility[1]
                    if agent_index == self.index:
                        if next_utility[1] > previous_utility:
                            return_move_utility[0] = move
                            return_move_utility[1] = next_utility[1]
                    else:
                        if next_utility[1] < previous_utility:
                            return_move_utility[0] = move
                            return_move_utility[1] = next_utility[1]
            return return_move_utility
        return Minimax(gameState, 0, 0)[0]
        util.raiseNotDefined()

class AlphaBetaAgent(MultiAgentSearchAgent):
    """
    Your minimax agent with alpha-beta pruning (question 3)
    """

    def getAction(self, gameState):
        """
        Returns the minimax action using self.depth and self.evaluationFunction
        """
        "*** YOUR CODE HERE ***"
        def Alpha_Beta_Minimax(state, agent_index, depth, alpha, beta):
            return_move_utility = []
            if depth == self.depth or len(state.getLegalActions(agent_index)) == 0:
                return ["Stop", self.evaluationFunction(state)]
            if agent_index == state.getNumAgents() - 1:
                depth = depth + 1
                agent_index_next = self.index
            else:
                agent_index_next = agent_index + 1
            for move in state.getLegalActions(agent_index):
                if len(return_move_utility) == 0:
                    next_utility = Alpha_Beta_Minimax(state.generateSuccessor(agent_index, move), agent_index_next, depth, alpha, beta)
                    return_move_utility.append(move)
                    return_move_utility.append(next_utility[1])
                    if agent_index == self.index:
                        alpha = max(alpha, return_move_utility[1])
                    else:
                        beta = min(beta, return_move_utility[1])
                else:
                    if agent_index == self.index and beta < return_move_utility[1]:
                        return return_move_utility
                    if agent_index != self.index and alpha > return_move_utility[1]:
                        return return_move_utility
                    previous_utility = return_move_utility[1]
                    next_utility = Alpha_Beta_Minimax(state.generateSuccessor(agent_index, move), agent_index_next, depth, alpha, beta)
                    if agent_index == self.index:
                        if next_utility[1] > previous_utility:
                            return_move_utility[0] = move
                            return_move_utility[1] = next_utility[1]
                            alpha = max(alpha, return_move_utility[1])
                    else:
                        if next_utility[1] < previous_utility:
                            return_move_utility[0] = move
                            return_move_utility[1] = next_utility[1]
                            beta = min(beta, return_move_utility[1])
            return return_move_utility
        return Alpha_Beta_Minimax(gameState, 0, 0, -9999, 9999)[0]
        util.raiseNotDefined()

class ExpectimaxAgent(MultiAgentSearchAgent):
    """
      Your expectimax agent (question 4)
    """

    def getAction(self, gameState):
        """
        Returns the expectimax action using self.depth and self.evaluationFunction

        All ghosts should be modeled as choosing uniformly at random from their
        legal moves.
        """
        "*** YOUR CODE HERE ***"
        def Expectimax(state, agent_index, depth):
            return_move_utility = []
            if depth == self.depth or len(state.getLegalActions(agent_index)) == 0:
                return ["Stop", self.evaluationFunction(state)]
            if agent_index == state.getNumAgents() - 1:
                depth = depth + 1
                agent_index_next = self.index
            else:
                agent_index_next = agent_index + 1
            for move in state.getLegalActions(agent_index):
                number_of_moves = len(state.getLegalActions(agent_index))
                next_utility = Expectimax(state.generateSuccessor(agent_index, move), agent_index_next, depth)
                if len(return_move_utility) == 0:
                    if agent_index == self.index:
                        return_move_utility.append(move)
                        return_move_utility.append(next_utility[1])
                    else:
                        return_move_utility.append("Average")
                        return_move_utility.append(next_utility[1]/number_of_moves)
                else:
                    previous_utility = return_move_utility[1]
                    if agent_index == self.index:
                        if next_utility[1] > previous_utility:
                            return_move_utility[0] = move
                            return_move_utility[1] = next_utility[1]
                    else:
                        return_move_utility[0] = "Average"
                        return_move_utility[1] = next_utility[1]/number_of_moves + previous_utility
            return return_move_utility
        return Expectimax(gameState, 0, 0)[0]
        util.raiseNotDefined()

def betterEvaluationFunction(currentGameState):
    """
    Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
    evaluation function (question 5).

    DESCRIPTION: <write something here so we know what you did>
    """
    "*** YOUR CODE HERE ***"
    pacman_location = currentGameState.getPacmanPosition()
    food_locations = currentGameState.getFood().asList()
    food_free_locations = currentGameState.getFood().asList(False)
    capsule_locations = currentGameState.getCapsules()
    capsule_count = len(capsule_locations)
    dot_locations = food_locations + capsule_locations
    food_free_locations = food_free_locations
    food_free_count = len(food_free_locations)
    dot_distances = []
    for dot_location in dot_locations:
        dot_distances.append(manhattanDistance(pacman_location, dot_location))
    dot_distance_sum = sum(dot_distances)
    ghost_states = currentGameState.getGhostStates()
    ghost_scared_times = [ghost_state.scaredTimer for ghost_state in ghost_states]
    ghost_distances = []
    for ghost_state in ghost_states:
        ghost_location = ghost_state.getPosition()
        ghost_distances.append(manhattanDistance(pacman_location, ghost_location))
    ghost_distances_sum = sum(ghost_distances)
    if min(ghost_scared_times) > 1 or ghost_distances_sum > 8:
        ghost_distance_weight = -1
    else:
        ghost_distance_weight = 1
    if ghost_distances_sum < 2:
        ghost_distance_weight = 999
    state_value = 1/(dot_distance_sum+1)**2 + (food_free_count+1)**2 - (capsule_count+1)**2 + ghost_distance_weight*ghost_distances_sum**0.5
    return state_value
    util.raiseNotDefined()

# Abbreviation
better = betterEvaluationFunction