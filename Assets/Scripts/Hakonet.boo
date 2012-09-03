import UnityEngine

class Hakonet (MonoBehaviour): 

	def Start ():
		pass
	
	def Update ():
		transform.Rotate(Vector3(0, 1, 0))
		
	def OnTriggerEnter(other as Collider):
		if other.gameObject.CompareTag('Player'):
			controller as GameObject = GameObject.FindWithTag('GameController')
			controller.SendMessage('AddCat')
			Destroy(gameObject)
