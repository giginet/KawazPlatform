import UnityEngine

class Gugugu (MonoBehaviour): 
	public speed = 1.0
	public rotationSpeed = 30
	private angle = 0
	private stopTime = 0
	private isStop = false
	private isTrigger = false
	private direction as single = 1.0
	private prevPosition = null

	def Start ():
		transform.eulerAngles = Vector3(0, 180, 0)
		prevPosition = transform.position
	
	def Update ():
		point = Camera.main.WorldToScreenPoint(self.transform.position)
		if 0 <= point.x and point.x <= Screen.width and 0 <= point.y and point.y <= Screen.height:			
			if not isTrigger:
				self.SetDirection()
			isTrigger = true
		if not isTrigger: return
		if not isStop:
			angle += rotationSpeed	
			transform.eulerAngles = Vector3(0, angle % 360 + 180, 0)
			transform.position += Vector3(speed, 0, 0) * direction
		else:
			stopTime += 1
			if stopTime >= 60:
				isStop = false
				stopTime = 0
		if angle == 360 * 5:
			self.SetDirection()
			isStop = true
			angle = 0
		prevPosition = transform.position
			
	def OnCollisionStay(collide as Collision):
		other = collide.gameObject
		if other.CompareTag('Player'):
			controller = GameObject.FindWithTag('GameController')
			controller.SendMessage('Death')
		elif other.CompareTag('Wall') and other.transform.position.y > transform.position.y:	
			if not prevPosition is null:
				transform.position = prevPosition
			isStop = true
			angle = 0
			transform.eulerAngles = Vector3(0, angle % 360 + 180, 0)

	def SetSpeed(s as single):
		self.speed = s
		
	def SetDirection():
		player = GameObject.FindWithTag('Player')
		direction = 1	
		if player and player.transform.position.x < transform.position.x:
			direction = -1