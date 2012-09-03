import UnityEngine

class Player (MonoBehaviour): 

	private warped = false
	private controller as GameObject

	def Start ():
		controller = GameObject.FindWithTag('GameController')
	
	def Update ():
		if transform.position.y < -200:
			controller.SendMessage('Death')
				
	def SetWarped(warp as bool):
		self.warped = warp
		
	def Warp (to as Vector3):
		if not warped:
			self.transform.position = to
			warped = true
			
	def Death ():		
		Destroy(gameObject)
