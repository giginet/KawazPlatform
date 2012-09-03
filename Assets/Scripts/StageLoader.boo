import UnityEngine

class StageLoader (MonoBehaviour): 
	public groundPrefab as GameObject
	public goalPrefab as GameObject
	public gatePrefab as GameObject
	public bonusPrefab as GameObject
	public playerPrefab as GameObject
	public chikuwaPrefab as GameObject
	public liftPrefab as GameObject
	public coinPrefab as GameObject
	public guguguPrefab as GameObject
	public hiddenPrefab as GameObject
	private playerPlaced as bool
	private stage as GameObject
	private catCount as int
	
	def Start ():
		self.playerPlaced = false
		
	def Update ():
		pass
		
	def CreateStage (stageNo as int):
		self.playerPlaced = false
		self.catCount = 0
		self.stage = GameObject.CreatePrimitive(PrimitiveType.Cube)
		self.stage.tag = "Stage"
		self.stage.renderer.enabled = false
		self.stage.name = "Stage"	
		self.ParseFromStageData("stage" + stageNo, 0)
		self.ParseFromStageData("stage" + stageNo + "_back", 60)
		self.ConnectGates()
		controller as GameObject = GameObject.FindWithTag('GameController')
		controller.SendMessage('SetMaxCatCount', self.catCount)
		GameObject.FindWithTag('MainCamera').SendMessage('Reset')
		GameObject.Find('Background').SendMessage('Reset')
		GameObject.Find('Mask').SendMessage('Reset')
				
	def ParseFromStageData (stageDataName as string, z as single):
		stageData as TextAsset = Instantiate(Resources.Load("StageData/" + stageDataName,  TextAsset))
		width as single = groundPrefab.transform.localScale.x
		height as single = groundPrefab.transform.localScale.z
		lines = stageData.text.Split("\n"[0])
		stageWidth = len(lines)	
		for y as int, line as string in enumerate(lines):
			for x as int in range(line.Length):
				position = Vector3(x * width, (stageWidth - 1 - y) * height + z / 5.0, z)
				c = line[x]
				if c == "#"[0]:
					ground as GameObject = Instantiate(groundPrefab, position, Quaternion.identity)
					ground.transform.parent = stage.transform
				elif c == "S"[0]:
					if self.playerPlaced: continue
					player as GameObject = Instantiate(playerPrefab, position, Quaternion.identity)
					player.transform.position = position + Vector3(0, height, 0)
					player.transform.parent = stage.transform
					self.playerPlaced = true	
				elif c == "G"[0]:
					goalGate as GameObject = Instantiate(goalPrefab, position, Quaternion.identity) 
					goalGate.transform.parent = stage.transform
					goalGate.transform.eulerAngles = Vector3(0, 180, 0)
				elif c == "!"[0]:
					bonus as GameObject = Instantiate(bonusPrefab, position, Quaternion.identity) 
					bonus.transform.parent = stage.transform
					self.catCount += 1
				elif c == "*"[0]:
					chikuwa as GameObject = Instantiate(chikuwaPrefab, position, Quaternion.identity) 
					chikuwa.transform.parent = stage.transform
				elif c == "r"[0] or c == "v"[0] or c == "h"[0]:
					lift as GameObject = Instantiate(liftPrefab, position, Quaternion.identity) 
					type = LiftType.Rotate
					if c == "v"[0]:
						type = LiftType.Vertical
					elif c == "h"[0]:
						type = LiftType.Horizontal
					lift.transform.Find('LiftSensor').gameObject.SendMessage("SetType", type)
					lift.transform.parent = stage.transform
				elif c == "c"[0]:
					coin as GameObject = Instantiate(coinPrefab, position, Quaternion.identity) 
					coin.transform.parent = stage.transform
				elif c == "m"[0] or c == "M"[0]:
					gugugu as GameObject = Instantiate(guguguPrefab, position, Quaternion.identity) 
					gugugu.transform.parent = stage.transform
					if c == "M"[0]:
						gugugu.transform.Find('gugugu-body').SendMessage('SetSpeed', 0.0)
				elif c == "k"[0]:
					block as GameObject = Instantiate(hiddenPrefab, position, Quaternion.identity) 
					block.transform.parent = stage.transform
				elif char.IsDigit(c):
					number = int.Parse(c.ToString())
					gate as GameObject = Instantiate(gatePrefab, position, Quaternion.identity) 
					gate.transform.parent = stage.transform
					gate.transform.position = position + Vector3(0, -7.5, 0)
					gate.transform.eulerAngles = Vector3(-90, 180, 0)
					gate.SendMessage('SetGateNumber', number)
					gate.tag = "Gate"	
							
	def ConnectGates():
		gates = GameObject.FindGameObjectsWithTag('Gate')
		for gate in gates:
			component = gate.GetComponent[of Gate]()
			if component.gateNumber == -1: continue
			for other in gates:
				otherComponent = other.GetComponent[of Gate]() 
				if otherComponent.gateNumber == component.gateNumber and not gate.Equals(other):
					component.pairGate = other
					otherComponent.pairGate = gate
	
	def DestroyStage():
		Destroy(self.stage)
		self.stage = null
					
	