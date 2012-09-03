import UnityEngine

class Background (MonoBehaviour): 

	public smoothTime as single = 0.3
	private velocity as Vector2
	
	def Start ():
		pass
	
	def Update ():
		player as GameObject = GameObject.FindWithTag('Player')
		if not player: return
		self.transform.position.x = Mathf.SmoothDamp( transform.position.x, 
		player.transform.position.x, velocity.x, smoothTime)
		self.transform.position.y = Mathf.SmoothDamp( transform.position.y, 
		player.transform.position.y, velocity.y, smoothTime)
