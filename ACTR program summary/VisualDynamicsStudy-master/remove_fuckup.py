import os

movie_list = ["BatvSup", "SuicideSquad", "Stoker", "TheRoom", "MemoriesofMurder", "Madeo", "AllaboutMyWife", "ColdEyes", "OurSunhi"]


movie_list = ["MidnightinParis", "UsualSuspects", "KingsSpeech", "Moneyball","Basterds",
	"Oldboy", "BatmanBegins", "HarryPotter1", "100thlove", "HarryPotter7", "Wallflower",
	"KickAss", "Seven", "LateAutumn", "Dongmakgol", "500Summer", "Shame", "CrazyStupidLove",
	"HarryPotter3", "BeforeSunset", "NoCountryforOldMen", "ChoIn", "KillingMeSoftly"]
print(len(movie_list))
for movie in movie_list:
	os.system("mv ./%s/%s_Detected_objects.csv  ./%s/%s_2fps_Detected_objects.csv" %(movie, movie, movie, movie))

	# os.system("mkdir ./%s" %(movie))

	# os.system("mv ./%s_Detected_objects.csv ./%s/" %(movie,movie))