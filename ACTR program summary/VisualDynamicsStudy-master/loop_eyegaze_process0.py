import os
# list_of_movies = movie_list = ["MidnightinParis", "UsualSuspects", "KingsSpeech", "Moneyball","Basterds",
# 	"Oldboy", "BatmanBegins", "HarryPotter1", "100thlove", "HarryPotter7", "Wallflower",
# 	"KickAss", "Seven", "LateAutumn", "Dongmakgol", "500Summer", "Shame", "CrazyStupidLove",
# 	"HarryPotter3", "BeforeSunset", "NoCountryforOldMen", "ChoIn", "KillingMeSoftly"]
list_of_movies = ["Basterds",
	"Oldboy", "BatmanBegins", "HarryPotter1", "100thlove", "HarryPotter7", "Wallflower",
	"KickAss", "Seven", "LateAutumn", "Dongmakgol", "500Summer", "Shame", "CrazyStupidLove",
	"HarryPotter3", "BeforeSunset", "NoCountryforOldMen", "ChoIn", "KillingMeSoftly"]
print(len(list_of_movies))

for i, movie in enumerate(list_of_movies):
	if i%5 ==0:
		print("Start Processing Act-R for %s" %(movie))

		os.system("python eyegaze_actr.py %s" %(movie))

		print("Finished Processing Act-R for %s" %(movie))


