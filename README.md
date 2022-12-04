# Text WordCloud Analysis Dashboard
In this dashboard, we can display and analyse text wordclouds for any language supported by R.
To use this for your text data you need to:
1. Name your text data csv file to "text.csv" and place it in the data folder.
2. Define the used language in line 7 in server.R.
3. Define the sentiment labels in line 4 in ui.R.
4. Keep only the necessary columns (named respectively text and Sentiment) and remove the rest in the read_dataset function, global.R file, line 45.
5. You're good to go !

PS: In the beginning the app may take some time to read your file, once it finished it will reactively display the loading of the wordcloud.
