import UnityEngine

class GoalGate (MonoBehaviour): 

	def Start ():
		pass
	
	def Update ():
		pass
		
	def OnTriggerEnter (other as Collider):
		if other.gameObject.CompareTag('Player'):
			controller as GameObject = GameObject.FindWithTag('GameController')
			controller.SendMessage('Clear')
