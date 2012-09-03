import UnityEngine

enum GameState:
	Ready
	Main
	Clear
	GameOver

class GameController (MonoBehaviour): 
	public initialLevel as int = 1
	public maxLevel = 1
	private missCount = 0
	private coinCount = 0
	private catCount = 0
	private lifeCount = 3
	private maxCatCount = 3
	private currentLevel = initialLevel
	private player as GameObject
	private state as GameState
	private guguguFlag as bool = true

	def Start ():
		self.currentLevel = self.initialLevel
		self.CreateStage(self.currentLevel)
	
	def Update ():
		player = GameObject.FindWithTag('Player')
		if self.state == GameState.GameOver:
			if Input.GetKeyDown(KeyCode.Space):
				self.Replay()
		elif self.state == GameState.Clear:
			if Input.GetKeyDown(KeyCode.Space):
				if (self.currentLevel < self.maxLevel) or (self.currentLevel == self.maxLevel and self.guguguFlag):
					self.NextLevel()
						
	def CreateStage(stageNo as int):
		loader = GameObject.Find('StageLoader')
		loader.SendMessage('DestroyStage')
		self.catCount = 0
		loader.SendMessage('CreateStage', stageNo)
	
	def OnGUI ():
		style as GUIStyle = GUIStyle()
		style.fontSize = 24 
		style.normal.textColor = Color.red
		style.alignment = TextAnchor.MiddleRight
		GUI.Label(Rect(30, 30, 80, 50), "Floor: ", style)
		GUI.Label(Rect(180, 30, 80, 50), "Coin: ", style)
		GUI.Label(Rect(330, 30, 80, 50), "Cat: ", style)
		style.alignment = TextAnchor.MiddleLeft
		GUI.Label(Rect(110, 30, 50, 50), self.currentLevel.ToString(), style)
		GUI.Label(Rect(260, 30, 50, 50), self.GetCoin().ToString(), style)
		GUI.Label(Rect(410, 30, 50, 50), self.catCount.ToString() + " / " + self.maxCatCount, style)
		labelStyle = GUIStyle()
		labelStyle.fontSize = 64 
		labelStyle.alignment = TextAnchor.MiddleCenter
		labelStyle.normal.textColor = Color.white
		shadowStyle = GUIStyle()
		shadowStyle.fontSize = 64 
		shadowStyle.alignment = TextAnchor.MiddleCenter
		shadowStyle.normal.textColor = Color.gray
		if self.state == GameState.GameOver:
			width = Screen.width
			height = Screen.height
			GUI.Label(Rect(width / 2 - 300 + 3, height / 2 - 200 + 3, 600, 400), "Game Over", shadowStyle)	
			GUI.Label(Rect(width / 2 - 300, height / 2 - 200, 600, 400), "Game Over", labelStyle)	
			if GUI.Button( Rect(width / 2 - 210, height / 2 + 100, 200, 60), "Replay(Space)"):
				self.Replay()
			elif GUI.Button( Rect(width / 2 + 10, height / 2 + 100, 200, 60), "Exit"):
				self.Exit()
		elif self.state == GameState.Clear:
			width = Screen.width
			height = Screen.height	
			text as string
			if self.currentLevel == self.maxLevel:
				if self.guguguFlag:
					text = "Incredible!"
					if GUI.Button( Rect(width / 2 - 100, height / 2 + 100, 200, 60), "GuguguMode(Space)"):
						self.NextLevel()
				else:
					if GUI.Button( Rect(width / 2 - 100, height / 2 + 100, 200, 60), "Exit"):
						self.Exit()
					text = "Congratulation!"
			elif self.currentLevel == self.maxLevel + 1:
				if GUI.Button( Rect(width / 2 - 100, height / 2 + 100, 200, 60), "Exit"):
					self.Exit()
				text = "Awesome!"
			else:
				if GUI.Button( Rect(width / 2 - 100, height / 2 + 100, 200, 60), "Next Level(Space)"):
					self.NextLevel()
				text = "Clear!"
				if self.maxCatCount == self.catCount:
					text = "Complete!"
			GUI.Label(Rect(width / 2 - 300 + 3, height / 2 - 200 + 3, 600, 400), text, shadowStyle)	
			GUI.Label(Rect(width / 2 - 300, height / 2 - 200, 600, 400), text, labelStyle)	
		
	def Death ():
		self.state = GameState.GameOver
		clip as AudioClip = Resources.Load("Sound/gameover", AudioClip)
		audio.PlayOneShot(clip)
		self.coinCount = self.coinCount / 2 + 1
		self.lifeCount -= 1
		self.catCount = 0
		player.SendMessage('Death')
		if guguguFlag and currentLevel == maxLevel + 1:
			out0 as AudioClip = Resources.Load("Sound/out0", AudioClip)
			audio.PlayOneShot(out0)
		elif Random.Range(0, 64) == 0:
			out1 as AudioClip = Resources.Load("Sound/out1", AudioClip)
			audio.PlayOneShot(out1)
		
	def Clear ():
		self.state = GameState.Clear
		if self.catCount < self.maxCatCount:
			self.guguguFlag =  false
		player.SendMessage('Death')
		clip = Resources.Load("Sound/clear", AudioClip)
		audio.PlayOneShot(clip)
		
	def NextLevel():
		self.state = GameState.Main
		self.currentLevel += 1
		self.CreateStage(self.currentLevel)
		
	def Replay():
		self.state = GameState.Main
		self.CreateStage(self.currentLevel)
		
	def Exit():
		Application.Quit()

	def GetCurrentState ():
		return self.state
		
	def GetCoin ():
		return self.coinCount
		
	def AddCoin():	
		self.coinCount += 1
		clip as AudioClip
		clip = Resources.Load("Sound/coin", AudioClip)
		audio.PlayOneShot(clip)
		
	def AddCat():
		self.catCount += 1	
		clip as AudioClip = Resources.Load("Sound/cat", AudioClip)
		audio.PlayOneShot(clip)
		
	def SetMaxCatCount (max as int):
		self.maxCatCount = max