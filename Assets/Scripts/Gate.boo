import UnityEngine

class Gate (MonoBehaviour): 

	public gateNumber as int = -1
	public pairGate as GameObject

	def Start ():
		pass
	
	def Update ():
		pass
		
	def SetGateNumber (number as int):
		self.gateNumber = number
		
	def SetPairGate (pair as GameObject):
		self.pairGate = pair

	def OnTriggerStay (other as Collider):
		gameObject as GameObject = other.gameObject
		if gameObject.CompareTag('Player'):
			v = Input.GetAxis('Vertical')
			player as GameObject = GameObject.FindWithTag('Player')
			if v > 0.1:
				if self.pairGate:
					player.SendMessage('Warp', pairGate.transform.position + Vector3(0, 5, 0))	
				else:
					Debug.Log("GateNumber " + self.gateNumber + "is Nothing.")
			else:
				player.SendMessage('SetWarped', false)