import UnityEngine

class Coin (MonoBehaviour): 

	def Start ():
		self.transform.eulerAngles.y = 90
		self.transform.eulerAngles.z = 90 
	
	def Update ():
		self.transform.Rotate(1, 0, 0)
		
	def OnTriggerEnter(other as Collider):
		if other.gameObject.CompareTag('Player'):
			controller as GameController = GameObject.FindWithTag('GameController').GetComponent[of GameController]()
			controller.AddCoin()	
			Destroy(gameObject)