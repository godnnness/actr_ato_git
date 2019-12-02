import ccm
log=ccm.log()

class Button(ccm.Model):
    def press(self):
        log.action=self.letter
        self.parent.display.reward=self.reward

        self.parent.display.visible=True
        self.parent.button1.visible=False
        self.parent.button2.visible=False
        yield 0.5
        self.parent.display.visible=False
        self.parent.button1.visible=True
        self.parent.button2.visible=True
        
        self.parent.score+=self.reward
        self.parent.trials+=1
        if self.parent.trials==200: self.stop()

class Reward(ccm.Model):
    def text(self):
        return self.reward
      

class ForcedChoiceEnvironment(ccm.Model):
  trials=0
  score=0
  button1=Button(letter='A',reward=1,x=0.2,y=100,text='A',color='blue')
  button2=Button(letter='B',reward=0,x=0.8,y=100,text='B',color='red')
  display=Reward(reward=0,x=0.5,y=0.5,visible=False)

  def key_pressed(self,key):
      if not self.display.visible:
          if key=='a': self.button1.press()
          if key=='b': self.button2.press()

          

env=ForcedChoiceEnvironment()
display=ccm.display(env)
env.run()
