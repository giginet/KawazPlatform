import UnityEngine

enum ChikuwaState:
	Normal
	Standby
	Shake
	Fall

class ChikuwaFloor (MonoBehaviour): 
	public duration as single = 1.0
	private onTimer as single = 0
	private state = ChikuwaState.Normal
	private floor as GameObject
	private onPlayer as bool

	def Start ():
		floor = transform.parent.Find('ChikuwaFloor').gameObject
	
	def Update ():
		if self.state == ChikuwaState.Standby:
			onTimer += Time.deltaTime
			if self.onTimer >= self.duration:
				self.onTimer = 0
				self.state = ChikuwaState.Shake
		elif self.state == ChikuwaState.Shake:
			onTimer += Time.deltaTime
			if self.onTimer < self.duration:
				floor.transform.eulerAngles.z = Mathf.Sin(onTimer * Mathf.Rad2Deg) * 5
			else:				
				floor.transform.eulerAngles.z = 0
				self.state = ChikuwaState.Fall
		elif self.state == ChikuwaState.Fall:
			if onPlayer:
				player = GameObject.FindWithTag('Player')
				player.transform.position += Vector3(0, -1, 0)
			transform.parent.position += Vector3(0, -1, 0)

	def OnTriggerStay (collision as Collider):
		player = collision.gameObject
		if player.CompareTag('Player'):
			if self.state == ChikuwaState.Normal:
				self.state = ChikuwaState.Standby
			if player.transform.position.y > self.transform.parent.position.y:
				self.onPlayer = true
			
	def OnTriggerExit (collision as Collider):
		player = collision.gameObject
		if player.CompareTag('Player'):
			self.onPlayer = false
			