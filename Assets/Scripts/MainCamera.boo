import UnityEngine

class MainCamera (MonoBehaviour): 

	public target as Transform
	public smoothTime as single = 0.3
	private velocity as Vector2

	def Start ():
		pass	
	
	def Update ():
		player = GameObject.FindWithTag('Player')
		if not player: return
		self.target = player.transform
		self.transform.position.x = Mathf.SmoothDamp( transform.position.x, 
		target.position.x, velocity.x, smoothTime)
		if self.transform.position.y >= -40:
			self.transform.position.y = Mathf.SmoothDamp( transform.position.y, 
			target.position.y, velocity.y, smoothTime)
			
	def Reset ():
		player = GameObject.FindWithTag('Player')
		if not player: return
		self.target = player.transform
		self.transform.position.x = target.position.x
		self.transform.position.y = target.position.y
