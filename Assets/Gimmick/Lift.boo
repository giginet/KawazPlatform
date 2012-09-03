import UnityEngine

enum LiftType:
	Normal
	Vertical
	Horizontal
	Rotate

class Lift (MonoBehaviour): 
	public type = LiftType.Normal
	public horizontalRange = 100
	public verticalRange = 50
	
	public speed = 0.8
	private time as single = 0
	private liftTransform as Transform
	private playerParent as Transform
	private onPlayer as bool = false
	private initialPosition as Vector3
	private prevPosition as Vector3
	private velocity as Vector3

	def Start ():
		liftTransform = transform.parent
		initialPosition = Vector3(transform.position.x, transform.position.y, transform.position.z)
		prevPosition = initialPosition
	
	def Update ():
		time += speed
		player = GameObject.FindWithTag('Player')
		if self.type == LiftType.Vertical:
			transform.parent.position = initialPosition + Vector3(0, Mathf.Sin(time * Mathf.Deg2Rad), 0) * verticalRange
			velocity = transform.position - prevPosition
			if onPlayer:
				player.transform.position = player.transform.position + velocity
		elif self.type == LiftType.Horizontal:
			transform.parent.position = initialPosition + Vector3(Mathf.Sin(time * Mathf.Deg2Rad), 0, 0) * horizontalRange
			velocity = transform.position - prevPosition	
			if onPlayer:
				player.transform.position = player.transform.position + velocity
		elif self.type == LiftType.Rotate:
			liftTransform.Rotate(Vector3(0, 0, speed))
		prevPosition = Vector3(transform.position.x, transform.position.y, transform.position.z)

	def SetType (t as LiftType):
		self.type = t
		
	def OnTriggerStay (collider as Collider):
		player = collider.gameObject
		if player.CompareTag('Player'):
			if player.transform.position.y > transform.parent.position.y:
				self.onPlayer = true
			else:
				self.onPlayer = false
			
	def OnTriggerExit (collider as Collider):
		player = collider.gameObject
		if player.CompareTag('Player'):
			self.onPlayer = false