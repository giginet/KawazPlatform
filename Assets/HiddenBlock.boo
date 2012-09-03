import UnityEngine

class HiddenBlock (MonoBehaviour): 
	public blockPrefab as GameObject
	def Start ():
		blockPrefab.renderer.enabled = false
	
	def Update ():
		pass
		
	def OnTriggerStay(collision as Collider):
		if collision.gameObject.CompareTag('Player'):
			if not blockPrefab.renderer.enabled :
				blockPrefab.renderer.enabled = true
				clip = Resources.Load("Sound/hidden", AudioClip)
				controller = GameObject.FindWithTag('GameController')
				controller.audio.PlayOneShot(clip)