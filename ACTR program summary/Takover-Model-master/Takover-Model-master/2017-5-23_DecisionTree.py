from pyschedule import solvers, plotters
import Sclass

class makeSchedule(object):
    
    def inputs(self, expert, gazeoff, longgaze, bodyTurned, lockout, handsOccupied, distanceHands, feetOnPedals, dangerousScenario, drivingSpeed, perceivedUrgent, mentalWL, traffic, S):
    #ToDo: input from GUI
        self.expert = expert
        self.gazeoff = gazeoff # always means headoff, too!
        self.longgaze = longgaze 
        self.bodyTurned = bodyTurned
        self.lockout = lockout
        self.handsOccupied = handsOccupied
        self.distanceHands = distanceHands
        self.feetOnPedals = feetOnPedals
        self.dangerousScenario = dangerousScenario
        self.drivingSpeed = drivingSpeed #in km/h
        self.perceivedUrgent = perceivedUrgent
        self.mentalWL = mentalWL
        self.traffic = traffic
        self.S = S
    
    def main(self):
        #create instance of a situation
        currSituation = Sclass.situation(self.dangerousScenario, self.S, self.distanceHands, self.drivingSpeed, self.perceivedUrgent, self.mentalWL, self.traffic)
        Sclass.situation.resources(currSituation)
        
        #decision tree       
        if not self.expert:
            if not self.dangerousScenario:
                Sclass.situation.nov(currSituation)
            else:
                Sclass.situation.exp(currSituation)
        else:
            Sclass.situation.exp(currSituation)
            
        Sclass.situation.start(currSituation)
        
        if not self.lockout:
            if not self.dangerousScenario:
                Sclass.situation.lockout(currSituation)
                    
        if self.gazeoff: 
            Sclass.situation.gazeOnRoad(currSituation)
            if self.longgaze:
                Sclass.situation.turnSA(currSituation) 
            if self.bodyTurned:
                Sclass.situation.turnBody(currSituation)
        if not self.gazeoff:
            if not self.longgaze:#if the driver JUST started looking to the street (he does not need
    #to turn the head anymore, but needs to build up situation awareness)
                Sclass.situation.SA(currSituation)
        if self.handsOccupied:
            Sclass.situation.hands2wheel(currSituation)
            Sclass.situation.unoccupyHands(currSituation)
        if not self.handsOccupied:
            if self.distanceHands > 0:
                Sclass.situation.hands2wheel(currSituation)
        if not self.feetOnPedals:
            Sclass.situation.feet2pedal(currSituation) 
        Sclass.situation.TO(currSituation)        
        return

    ###############################################################################
    # A small helper method to solve and plot a scenario
    def run(self) :
        #enable this one for using 'running manytimes':
        #return solvers.ortools.solve(self.S)
        
        #for plotting the substeps:
        #'ortools' or 'mip' before 'solve'
        if solvers.ortools.solve(self.S):
            
            plotters.matplotlib.plot(self.S,fig_size=(60,5))
            print solvers.ortools.solve(self.S)
        else:
            print('no solution exists')
