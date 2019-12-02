import os
# list_of_movies = ["Basterds",
# 	"Oldboy", "BatmanBegins", "HarryPotter1", "100thlove", "HarryPotter7", "Wallflower",
# 	"KickAss", "Seven", "LateAutumn", "Dongmakgol", "500Summer", "Shame", "CrazyStupidLove",
# 	"HarryPotter3", "BeforeSunset", "NoCountryforOldMen", "ChoIn", "KillingMeSoftly"]
list_of_movies = ["2days1night", "20thCWomen", "AfricanCats", "AgeofShadows", "AmericanHustle", "BabyDriver", "Bladerunner", "Childrenofmen", "Dark_knight", "GOTRS07E04", "Gravity", "IT",
"Kingsman2", "Merciless", "Moonlight", "Mother", "Once", "TokyoKazoku", "VIP", "ZeroDarkThirty", "MidnightinParis", "UsualSuspects", "KingsSpeech", "Moneyball","Basterds",
	"Oldboy", "BatmanBegins", "HarryPotter1", "100thlove", "HarryPotter7", "Wallflower",
	"KickAss", "Seven", "LateAutumn", "Dongmakgol", "500Summer", "Shame", "CrazyStupidLove",
	"HarryPotter3", "BeforeSunset", "NoCountryforOldMen", "ChoIn", "KillingMeSoftly", 
	"BatvSup", "SuicideSquad", "Stoker", "TheRoom", "MemoriesofMurder", "Madeo", "AllaboutMyWife", "ColdEyes", "OurSunhi"]
print(len(list_of_movies))

for i, movie in enumerate(list_of_movies):

	print("Start Processing Act-R for %s" %(movie))

	os.system("python eyegaze_actr.py %s" %(movie))

	print("Finished Processing Act-R for %s" %(movie))


