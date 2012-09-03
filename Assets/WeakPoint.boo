import UnityEngine

class WeakPoint (MonoBehaviour): 
	public explodePrefab as GameObject
	public coinPrefab as GameObject
	public bodyPrefab as GameObject
	private velocity as single = 0
	private prev as single = 0
	private relativePosition as Vector3

	def Start ():
		relativePosition = self.transform.position - bodyPrefab.transform.position
	
	def Update ():
		transform.position = bodyPrefab.transform.position + relativePosition
		player = GameObject.FindWithTag('Player')
		if player:
			velocity = prev - player.transform.position.y
			prev = player.transform.position.y
		
	def OnTriggerStay(collide as Collider):
		player = collide.gameObject
		if player.CompareTag('Player'):
			if self.velocity >= -1 and player.transform.position.y > transform.position.y - 5:
				if explodePrefab:
					Instantiate(explodePrefab, self.transform.position, Quaternion.identity)
					clip = Resources.Load("Sound/explode", AudioClip)
					controller = GameObject.FindWithTag('GameController')
					controller.audio.PlayOneShot(clip)
				coin as GameObject = Instantiate(coinPrefab, transform.position, Quaternion.identity) 
				coin.transform.parent = GameObject.FindWithTag('Stage').transform
				Destroy(transform.parent.gameObject)
		
			